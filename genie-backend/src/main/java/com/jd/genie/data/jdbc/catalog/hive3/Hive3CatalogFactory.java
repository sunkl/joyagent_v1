package com.jd.genie.data.jdbc.catalog.hive3;

import com.google.auto.service.AutoService;
import com.jd.genie.data.jdbc.catalog.JdbcCatalog;
import com.jd.genie.data.jdbc.catalog.JdbcCatalogFactory;
import com.jd.genie.data.jdbc.catalog.clickhouse.ClickhouseCatalog;
import com.jd.genie.data.jdbc.dialect.DialectEnum;

@AutoService(JdbcCatalogFactory.class)
public class Hive3CatalogFactory implements JdbcCatalogFactory {
    @Override
    public DialectEnum jdbcDialect() {
        return DialectEnum.HIVE3;
    }

    @Override
    public JdbcCatalog createCatalog() {
        return new ClickhouseCatalog();
    }
}
