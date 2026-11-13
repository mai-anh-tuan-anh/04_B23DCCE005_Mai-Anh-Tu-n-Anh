package dao;

import java.sql.*;
import java.util.*;
import model.ReaderType5;

public class ReaderTypeDAO5 extends DAO {
    public ReaderTypeDAO5() { super(); }

    public ReaderType5[] getReaderTypes() throws SQLException {
        List<ReaderType5> result = new ArrayList<>();
        con = DatabaseContext.connection();
        try (PreparedStatement ps = con.prepareStatement("SELECT * FROM tblReaderType5 ORDER BY id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ReaderType5 item = new ReaderType5();
                item.setId(rs.getInt("id"));
                item.setReaderTypeCode(rs.getString("readerTypeCode"));
                item.setReaderTypeName(rs.getString("readerTypeName"));
                result.add(item);
            }
        } finally { DatabaseContext.release(con); }
        return result.toArray(new ReaderType5[0]);
    }
}
