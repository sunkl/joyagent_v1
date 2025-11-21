package com.jd.genie.data.jdbc.catalog.doris2;

import com.jd.genie.data.jdbc.catalog.JdbcCatalog;
import com.jd.genie.data.jdbc.catalog.JdbcCatalogFactory;
import com.jd.genie.data.jdbc.catalog.mysql.MySqlCatalog;
import com.jd.genie.data.jdbc.dialect.DialectEnum;

public class Doris2CatalogFactory implements JdbcCatalogFactory {
    @Override
    public DialectEnum jdbcDialect() {
        return DialectEnum.DORIS2;
    }

    @Override
    public JdbcCatalog createCatalog() {
        return new MySqlCatalog();
    }
}