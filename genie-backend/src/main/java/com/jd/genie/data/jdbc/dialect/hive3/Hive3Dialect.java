package com.jd.genie.data.jdbc.dialect.hive3;

import com.jd.genie.data.jdbc.dialect.DialectEnum;
import com.jd.genie.data.jdbc.dialect.JdbcDialect;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Hive3Dialect  implements JdbcDialect {
    @Override
    public DialectEnum dialectName() {
        return DialectEnum.HIVE3;
    }

    @Override
    public String driverName() {
        return "org.apache.hive.jdbc.HiveDriver";
    }

    @Override
    public Statement createStreamStatement(Connection connection, Integer fetchSize) throws SQLException {
        Statement statement = connection.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
        statement.setFetchSize(DEFAULT_EXPORT_FETCH_SIZE);
        statement.setMaxRows(EXPORT_MAX_SIZE);
        return statement;
    }
}
