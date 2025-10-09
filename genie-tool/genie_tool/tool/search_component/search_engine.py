# -*- coding: utf-8 -*-
# =====================
# 
# 
# Author: liumin.423
# Date:   2025/7/9
# =====================
import asyncio
import json
import os
from loguru import logger
from abc import ABC, abstractmethod
from typing import List
import aiohttp
from bs4 import BeautifulSoup

from genie_tool.model.document import Doc
from genie_tool.util.log_util import timer


class SearchBase(ABC):
    """搜索基类"""

    def __init__(self):
        self._count = int(os.getenv("SEARCH_COUNT", 10))
        self._timeout = int(os.getenv("SEARCH_TIMEOUT", 10))
        self._use_jd_gateway = os.getenv("USE_JD_SEARCH_GATEWAY", "true") == "true"

    @staticmethod
    def _sanitize(value: str | None) -> str:
        if not value:
            return ""
        cleaned = value.replace("\r", "").replace("\n", "").strip()
        return cleaned

    @abstractmethod
    async def search(self, query: str, request_id: str = None, *args, **kwargs) -> List[Doc]:
        """抽象搜索方法"""
        raise NotImplementedError

    @staticmethod
    @timer()
    async def parser(docs: List[Doc], timeout: int=10, **kwargs) -> List[Doc]:
        async def _parser(source_url, timeout):
            async with aiohttp.ClientSession() as session:
                try:
                    async with session.get(source_url, timeout=timeout) as response:
                        if response.content_type.lower() in [
                                "text/html", "text/plain", "text/xml", "application/json", "application/xml", "application/octet-stream"]:
                            return await response.text()
                        else:
                            # TODO 其他类型暂时不解析
                            logger.warning(f"parser content-type[{response.content_type}] not parser: url=[{source_url}]")
                            return ""
                except UnicodeDecodeError as ude:
                    return ude.args[1].decode("gb2312", errors="ignore")
                except Exception as e:
                    logger.warning(f"parser error: url=[{source_url}] error={e}")
                    return ""
        async with asyncio.TaskGroup() as tg:
            tasks = [tg.create_task(_parser(doc.link, timeout)) for doc in docs]
        results = [BeautifulSoup(task.result(), "html.parser") for task in tasks]
        results = [soup.get_text() if soup.get_text() and len(soup.get_text().strip()) > 50 else str(soup.text) for soup in results]
        for doc, result in zip(tasks, results):
            if result:
                doc.content = result
        return docs

    @timer()
    async def search_and_dedup(
            self, query: str, request_id: str = None, *args, **kwargs
    ) -> List[Doc]:
        """
        搜索并去重，同时删除没有内容的文档
        """
        docs = await self.search(query=query, request_id=request_id, *args, **kwargs)
        docs = await self.parser(docs=docs)

        seen_docs = set()
        deduped_docs = []
        for doc in docs:
            if doc.content and doc.content not in seen_docs:
                deduped_docs.append(doc)
                seen_docs.add(doc.content)
        return deduped_docs


class BingSearch(SearchBase):

    def __init__(self):
        super().__init__()
        self._engine = "bing-search"
        self._url = os.getenv("BING_SEARCH_URL")
        self._api_key = os.getenv("BING_SEARCH_API_KEY")

        self.headers = {
            "Content-Type": "application/json",
        }
        self.set_auth()

    def set_auth(self):
        if self._use_jd_gateway:
            self.headers["Authorization"] = f"Bearer {self._api_key}"
        else:
            self.headers["Ocp-Apim-Subscription-Key"] = self._api_key

    def construct_body(self, query: str, request_id: str = None):
        if self._use_jd_gateway:
            return {
                "request_id": request_id,
                "model": self._engine,

                "messages": [{
                    "role": "user",
                    "content": query
                }],
                "count": self._count,
                "stream": False,
            }
        else:
            return {
                "q": query,
                "textDecorations": True
            }

    async def search(self, query: str, request_id: str = None, *args, **kwargs) -> List[Doc]:
        body = self.construct_body(query, request_id)
        async with aiohttp.ClientSession() as session:
            async with session.post(self._url, json=body, headers=self.headers, timeout=self._timeout) as response:
                result = json.loads(await response.text())
                return [
                    Doc(
                        doc_type="web_page",
                        content=item.get("snippet", ""),
                        title=item.get("name", ""),
                        link=item.get("url", ""),
                        data={"search_engine": self._engine},
                    ) for item in result.get("webPages", {}).get("value", [])
                ]


class JinaSearch(BingSearch):

    def __init__(self):
        super().__init__()
        self._engine = "search_pro_jina"
        self._url = os.getenv("JINA_SEARCH_URL")
        self._api_key = os.getenv("JINA_SEARCH_API_KEY")


    async def search(self, query: str, request_id: str = None, *args, **kwargs) -> List[Doc]:
        if self._use_jd_gateway:
            body = self.construct_body(query, request_id)
            async with aiohttp.ClientSession() as session:
                async with session.post(self._url, json=body, headers=self.headers, timeout=self._timeout) as response:
                    result = json.loads(await response.text())
                    return [
                        Doc(
                            doc_type="web_page",
                            content=item.get("content", ""),
                            title=item.get("title", ""),
                            link=item.get("link", ""),
                            data={"search_engine": self._engine},
                        ) for item in result.get("search_result", [])
                    ]
        else:
            headers = {
                "Accept": "application/json",
                "Authorization": f"Bearer {self._api_key}"
            }
            async with aiohttp.ClientSession() as session:
                async with session.get(f"{self._url}?q={query}", headers=headers, timeout=self._timeout) as response:
                    result = json.loads(await response.text())
                    return [
                        Doc(
                            doc_type="web_page",
                            content=item.get("content", ""),
                            title=item.get("title", ""),
                            link=item.get("url", ""),
                            data={"search_engine": self._engine},
                        ) for item in result.get("data", [])
                    ]


class SogouSearch(JinaSearch):

    def __init__(self):
        super().__init__()
        self._engine = "search_pro_sogou"
        self._url = os.getenv("SOGOU_SEARCH_URL")
        self._api_key = os.getenv("SOGOU_SEARCH_API_KEY")


class SerperSearch(JinaSearch):

    def __init__(self):
        super().__init__()
        self._engine = "serper"
        self._url = os.getenv("SERPER_SEARCH_URL")
        self._api_key = os.getenv("SERPER_SEARCH_API_KEY")
        self.set_auth()
    
    def set_auth(self):
        self.headers["X-API-KEY"] = self._api_key

    def construct_body(self, query: str, request_id: str = None):
        return {
            "q": query,
            "count": self._count,
        }
    
    async def search(self, query: str, request_id: str = None, *args, **kwargs) -> List[Doc]:
        body = self.construct_body(query, request_id)
        async with aiohttp.ClientSession() as session:
            async with session.post(self._url, json=body, headers=self.headers, timeout=self._timeout) as response:
                result = json.loads(await response.text())
                return [
                    Doc(
                        doc_type="web_page",
                        content=item.get("snippet", ""),
                        title=item.get("title", ""),
                        link=item.get("link", ""),
                        data={"search_engine": self._engine},
                    ) for item in result.get("organic", [])
                ]


class MixSearch(BingSearch):

    def __init__(self):
        super().__init__()
        self._engine = "mix_search"
        self._bing_engine = BingSearch()
        self._jina_engine = JinaSearch()
        self._sogou_engine = SogouSearch()
        self._serp_engine = SerperSearch()
        self._bocha_engine = BochaSearch()

    async def search(
            self, query: str, request_id: str = None,
            use_bing: bool = True, use_jina: bool = True, use_sogou: bool = True,
            use_serp: bool = True, use_bocha: bool = True, *args, **kwargs) -> List[Doc]:
        assert use_bing or use_jina or use_sogou or use_serp or use_bocha
        engines = []
        if use_bing:
            engines.append(self._bing_engine)
        if use_jina:
            engines.append(self._jina_engine)
        if use_sogou:
            engines.append(self._sogou_engine)
        if use_serp:
            engines.append(self._serp_engine)
        if use_bocha:
            engines.append(self._bocha_engine)
        async with asyncio.TaskGroup() as tg:
            tasks = [tg.create_task(engine.search_and_dedup(query=query, request_id=request_id)) for engine in engines]
        results = [task.result() for task in tasks]
        return [doc for docs in results for doc in docs]
class BochaSearch(SearchBase):
    """博查搜索引擎实现

    环境变量：
      BOCHA_WEB_SEARCH_URL  e.g. https://api.bochaai.com/v1/web-search
      BOCHA_API_KEY         以 Bearer 方式放入 Authorization 头
    支持参数：count（复用 SEARCH_COUNT），始终附带 summary=true 方便聚合。
    """

    def __init__(self):
        super().__init__()
        self._engine = "bocha_web_search"
        self._url = os.getenv("BOCHA_WEB_SEARCH_URL")
        raw_key = os.getenv("BOCHA_API_KEY")
        self._api_key = self._sanitize(raw_key)
        if raw_key and raw_key != self._api_key:
            logger.debug("BochaSearch API Key 含有换行已清理")
        self.headers = {
            "Content-Type": "application/json",
        }
        if self._api_key:
            self.headers["Authorization"] = f"Bearer {self._api_key}"

    def construct_body(self, query: str, request_id: str = None):
        return {
            "query": query,
            "summary": True,          # 要求带摘要，利于下游 LLM 使用
            "count": min(max(self._count, 1), 10),  # 接口限制 1-10
            # 可扩展 freshness: "noLimit" | "oneDay" | "oneWeek" | "oneMonth" | "oneYear"
        }

    async def search(self, query: str, request_id: str = None, *args, **kwargs) -> List[Doc]:
        if not self._url or not self._api_key:
            logger.warning("BochaSearch 缺少 BOCHA_WEB_SEARCH_URL 或 BOCHA_API_KEY，返回空结果。")
            return []
        body = self.construct_body(query, request_id)
        try:
            async with aiohttp.ClientSession() as session:
                async with session.post(self._url, json=body, headers=self.headers, timeout=self._timeout) as response:
                    text = await response.text()
                    if response.status != 200:
                        logger.warning(f"BochaSearch 接口非 200: status={response.status} body={text[:300]}")
                        return []
                    result = json.loads(text)
        except Exception as e:
            logger.warning(f"BochaSearch 调用异常: {e}")
            return []

        data = (result or {}).get("data", {})
        web_pages = data.get("webPages", {})
        value_list = web_pages.get("value", [])
        docs = []
        for item in value_list:
            title = item.get("name", "")
            url = item.get("url", "")
            snippet = item.get("snippet") or ""
            summary = item.get("summary") or ""
            content = summary or snippet  # 优先摘要
            docs.append(
                Doc(
                    doc_type="web_page",
                    content=content,
                    title=title,
                    link=url,
                    data={"search_engine": self._engine},
                )
            )
        logger.info(f"BochaSearch 返回 {len(docs)} 条结果 query={query}")
        return docs

