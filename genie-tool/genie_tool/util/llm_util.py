# -*- coding: utf-8 -*-
# =====================
# 
# 
# Author: liumin.423
# Date:   2025/7/8
# =====================
import json
import os
from typing import List, Any, Optional, Dict

from litellm import acompletion
from genie_tool.util.log_util import timer, AsyncTimer
from genie_tool.util.sensitive_detection import SensitiveWordsReplace


def _as_float(v, name: str) -> Optional[float]:
    if v is None:
        return None
    try:
        f = float(v)
        return f
    except Exception:
    # 非法就丢弃，不传给下游
    return None


def _valid_01(v: Optional[float], zero_open: bool = True) -> Optional[float]:
    if v is None:
        return None
    if zero_open:
        return v if (0.0 < v <= 1.0) else None
    else:
        return v if (0.0 <= v <= 1.0) else None


def _prune_sampling_params(model: str, temperature, top_p) -> Dict[str, Any]:
    """
    - 仅在取到合法值时才返回 sampling 参数
    - 对 DeepSeek 做一次保守兼容（若值非法/可疑则不传）
    """
    out: Dict[str, Any] = {}

    # 统一成 float 并校验
    t = _as_float(temperature, "temperature")
    p = _as_float(top_p, "top_p")

    # temperature（一般允许 [0,2]，宽松点，只在合法时传）
    if t is not None and 0.0 <= t <= 2.0:
        out["temperature"] = t

    # top_p（DeepSeek 报“(0,1.0]”，严格点）
    p = _valid_01(p, zero_open=True)
    if p is not None:
        # 对 deepseek 做个白名单才传，减少奇怪 400
        if model.startswith("deepseek/") or "deepseek" in model:
            # 如果你想更保守，直接不传 top_p：
            # pass
            out["top_p"] = p
        else:
            out["top_p"] = p

    return out


@Timer(key="enter")
async def ask_llm(
        messages: str | List[Any],
        model: str,
        temperature: float = None,
        top_p: float = None,  # 恢复为 None，除非显式传入
        stream: bool = False,
        # 自定义
        only_content: bool = False,
        extra_headers: Optional[dict] = None,
        **kwargs,
    ):
    # 1) 规范化 messages
    if isinstance(messages, str):
        messages = [{"role": "user", "content": messages}]
    # 2) 敏感词替换
    if os.getenv("SENSITIVE_WORD_REPLACE", "false").lower() == "true":
        for message in messages:
            content = message.get("content")
            if isinstance(content, str):
                message["content"] = SensitiveWordsReplace.replace(content)
            else:
                message["content"] = json.loads(
                    SensitiveWordsReplace.replace(json.dumps(content, ensure_ascii=False))
                )
    # 3) 裁剪采样参数（只在合法时传）
    sampling_params = _prune_sampling_params(model, temperature, top_p)
    # 4) 构造请求（不要无脑把 top_p/temperature 传进去）
    req_kwargs = dict(
        messages=messages,
        model=model,
        stream=stream,
        extra_headers=extra_headers,
        **kwargs,
    )
    req_kwargs.update(sampling_params)
    response = await acompletion(**req_kwargs)
    async with AsyncTimer(key=f"exec ask_llm"):
        if stream:
            async for chunk in response:
                if only_content:
                    if (chunk.choices and chunk.choices[0]
                            and getattr(chunk.choices[0], "delta", None)
                            and getattr(chunk.choices[0].delta, "content", None)):
                        yield chunk.choices[0].delta.content
                else:
                    yield chunk
        else:
            yield response.choices[0].message.content if only_content else response


if name == "main":
    pass
