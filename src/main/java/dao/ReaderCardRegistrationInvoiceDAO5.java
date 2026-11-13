package dao;

import java.math.BigDecimal;
import java.sql.*;
import java.time.LocalDate;
import java.util.UUID;
import model.*;

public class ReaderCardRegistrationInvoiceDAO5 extends DAO {
    public ReaderCardRegistrationInvoiceDAO5() { super(); }

    public ReaderCardRegistrationInvoice5 createReaderCardRegistrationInvoice(
            ReaderCard5 rc, BigDecimal paidAmount) throws SQLException {
        if (rc == null || rc.getId() <= 0 || paidAmount == null)
            throw new IllegalArgumentException("Thẻ phải được tạo trước hóa đơn");
        con = DatabaseContext.connection();
        try {
            ReaderCardRegistrationInvoice5 invoice = new ReaderCardRegistrationInvoice5();
            invoice.setInvoiceCode("INV" + UUID.randomUUID().toString().replace("-", "")
                .substring(0, 14).toUpperCase());
            invoice.setInvoiceDate(LocalDate.now());
            invoice.setPaidAmount(paidAmount);
            try (PreparedStatement ps = con.prepareStatement(
                    "INSERT INTO tblReaderCardRegistrationInvoice5 " +
                    "(invoiceCode,invoiceDate,paidAmount,tblReaderCard5id) VALUES (?,?,?,?)",
                    Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, invoice.getInvoiceCode());
                ps.setDate(2, Date.valueOf(invoice.getInvoiceDate()));
                ps.setBigDecimal(3, invoice.getPaidAmount());
                ps.setInt(4, rc.getId());
                if (ps.executeUpdate() != 1) throw new SQLException("Không lưu được hóa đơn");
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) throw new SQLException("Không lấy được ID hóa đơn");
                    invoice.setId(keys.getInt(1));
                }
            }
            rc.setRegistrationInvoice(invoice);
            return invoice;
        } finally { DatabaseContext.release(con); }
    }
}
