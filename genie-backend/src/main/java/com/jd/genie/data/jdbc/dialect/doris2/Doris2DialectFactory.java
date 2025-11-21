package com.jd.genie.data.jdbc.dialect.doris2;

import com.jd.genie.data.jdbc.dialect.DialectEnum;
import com.jd.genie.data.jdbc.dialect.JdbcDialect;
import com.jd.genie.data.jdbc.dialect.JdbcDialectFactory;
import com.jd.genie.data.jdbc.dialect.mysql.MysqlDialect;

public class Doris2DialectFactory  implements JdbcDialectFactory {
    @Override
    public boolean acceptsURL(String url) {
        return url.startsWith(DialectEnum.DORIS2.getUrlPrefix());
    }

    @Override
    public JdbcDialect create() {
        return new MysqlDialect();
    }
}
