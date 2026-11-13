package dao;

import java.sql.*;
import java.util.*;
import model.ReaderCardType5;

public class ReaderCardTypeDAO5 extends DAO {
    public ReaderCardTypeDAO5() { super(); }

    public ReaderCardType5[] getReaderCardTypes() throws SQLException {
        List<ReaderCardType5> result = new ArrayList<>();
        con = DatabaseContext.connection();
        try (PreparedStatement ps = con.prepareStatement("SELECT * FROM tblReaderCardType5 ORDER BY id");
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ReaderCardType5 item = new ReaderCardType5();
                item.setId(rs.getInt("id"));
                item.setReaderCardTypeCode(rs.getString("readerCardTypeCode"));
                item.setReaderCardTypeName(rs.getString("readerCardTypeName"));
                item.setRegistrationFee(rs.getBigDecimal("registrationFee"));
                item.setRenewFee(rs.getBigDecimal("renewFee"));
                item.setValidityPeriod(rs.getInt("validityPeriod"));
                item.setLoanDuration(rs.getInt("loanDuration"));
                item.setMaxBorrowedCopies(rs.getInt("maxBorrowedCopies"));
                result.add(item);
            }
        } finally { DatabaseContext.release(con); }
        return result.toArray(new ReaderCardType5[0]);
    }
}
