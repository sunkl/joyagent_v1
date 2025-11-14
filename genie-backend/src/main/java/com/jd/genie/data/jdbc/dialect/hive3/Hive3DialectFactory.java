package com.jd.genie.data.jdbc.dialect.hive3;

import com.google.auto.service.AutoService;
import com.jd.genie.data.jdbc.dialect.JdbcDialect;
import com.jd.genie.data.jdbc.dialect.JdbcDialectFactory;
import com.jd.genie.data.jdbc.dialect.clickhouse.ClickhouseDialect;

@AutoService(JdbcDialectFactory.class)
public class Hive3DialectFactory implements JdbcDialectFactory{
    @Override
    public boolean acceptsURL(String url) {
        return  url.startsWith("jdbc:hive2:");
    }

    @Override
    public JdbcDialect create() {
        return new ClickhouseDialect();
    }
}
