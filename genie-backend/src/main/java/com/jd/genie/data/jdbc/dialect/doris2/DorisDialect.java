package com.jd.genie.data.jdbc.dialect.doris2;

import com.jd.genie.data.jdbc.dialect.DialectEnum;
import com.jd.genie.data.jdbc.dialect.JdbcDialect;

import java.util.Properties;

public class DorisDialect implements JdbcDialect {
    @Override
    public DialectEnum dialectName() {
        return DialectEnum.DORIS2;
    }

    @Override
    public String driverName() {
        return "com.mysql.jdbc.Driver";
    }

    @Override
    public Properties defaultProperties() {
        Properties properties = new Properties();
        properties.setProperty("remarks", "true");
        properties.setProperty("useInformationSchema", "true");
        return properties;
    }
}
