package com.jd.genie.data.jdbc.catalog.hive3;

import com.jd.genie.data.SimpleTable;
import com.jd.genie.data.TableColumn;
import com.jd.genie.data.exception.CatalogException;
import com.jd.genie.data.jdbc.catalog.AbstractJdbcCatalog;
import com.jd.genie.data.model.StandardColumnType;
import org.apache.commons.lang3.StringUtils;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class Hive3Catalog extends AbstractJdbcCatalog {
    @Override
    public List<SimpleTable> listTables(Connection connection, String schema) throws CatalogException {
        String sql = "select concat(d.db,t.tbl_name) as tbl_path from (select `name` as db ,db_id from sys.dbs where  `name` = '" + schema + "'" + ") as d join sys.tbls as t on t.db_id = d.db_id";
        try (Statement prepared = connection.createStatement();
             ResultSet rs = prepared.executeQuery(sql)) {
            List<SimpleTable> tables = new ArrayList<>();
            while (rs.next()) {
                SimpleTable st = new SimpleTable();
                st.setTableSchema(schema);
                st.setTableName(rs.getString("tbl_path"));
                tables.add(st);
            }
            return tables;

        } catch (Exception e) {
            throw new CatalogException(
                    String.format("获取数据库表失败 %s ", schema), e);
        }
    }

    public String getColumnType(String columnType) {
        return switch (StandardColumnType.of(columnType)) {
            case DECIMAL -> "Decimal64(4)";
            case DATE -> "DateTime";
            default -> "String";
        };
    }


    public BigDecimal parseDecimal(String value, String fieldName) {
        BigDecimal decimal = null;
        if (StringUtils.isNotBlank(value)) {
            try {
                decimal = new BigDecimal(value);
            } catch (Exception e) {
                throw new CatalogException("字段" + fieldName + "值\"" + value + "\"转换成数值失败", e);
            }
        }
        return decimal;
    }
}
