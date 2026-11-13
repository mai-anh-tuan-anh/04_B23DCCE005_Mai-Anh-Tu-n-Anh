package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.UUID;
import model.*;

public class ReaderCardDAO5 extends DAO {
    public ReaderCardDAO5() { super(); }

    /** ELIGIBLE, READER_ALREADY_HAS_CARD, CCCD_ALREADY_USED. */
    public String checkReaderCardRegistration(Reader5 r, String citizenIdentificationNumber) throws SQLException {
        if (r == null || r.getId() <= 0 || citizenIdentificationNumber == null)
            throw new IllegalArgumentException("Thiếu dữ liệu độc giả hoặc CCCD");
        con = DatabaseContext.connection();
        try {
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT id FROM tblReaderCard5 WHERE tblReader5id = ? LIMIT 1")) {
                ps.setInt(1, r.getId());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return "READER_ALREADY_HAS_CARD";
                }
            }
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT id FROM tblReaderCard5 WHERE citizenIdentificationNumber = ? LIMIT 1")) {
                ps.setString(1, citizenIdentificationNumber);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return "CCCD_ALREADY_USED";
                }
            }
            return "ELIGIBLE";
        } finally { DatabaseContext.release(con); }
    }

    public ReaderCard5 createReaderCard(Reader5 r, ReaderCard5 rc,
                                       ReaderCardType5 rct, ReaderType5 rt) throws SQLException {
        if (r == null || rc == null || rct == null || rt == null)
            throw new IllegalArgumentException("Thiếu thông tin đăng ký");
        con = DatabaseContext.connection();
        try {
            // Phòng đăng ký lặp; khóa UNIQUE của CSDL là tuyến phòng vệ cuối cùng.
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT id FROM tblReaderCard5 WHERE tblReader5id=? OR citizenIdentificationNumber=? LIMIT 1")) {
                ps.setInt(1, r.getId());
                ps.setString(2, rc.getCitizenIdentificationNumber());
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) throw new SQLException("Độc giả đã có thẻ hoặc CCCD đã được sử dụng");
                }
            }
            String sql = "INSERT INTO tblReaderCard5 " +
                "(readerCardCode,fullName,gender,readerCardStatus,dateOfBirth,citizenIdentificationNumber," +
                "address,email,phoneNumber,issueDate,expiryDate,cardDeliveryMethod," +
                "tblReader5id,tblReaderType5id,tblReaderCardType5id) " +
                "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
            LocalDate issued = LocalDate.now();
            String code = "RC" + UUID.randomUUID().toString().replace("-", "").substring(0, 14).toUpperCase();
            try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, code);
                ps.setString(2, rc.getFullName());
                ps.setString(3, rc.getGender());
                ps.setString(4, "Đang hoạt động");
                ps.setDate(5, Date.valueOf(rc.getDateOfBirth()));
                ps.setString(6, rc.getCitizenIdentificationNumber());
                ps.setString(7, rc.getAddress());
                ps.setString(8, rc.getEmail());
                ps.setString(9, rc.getPhoneNumber());
                ps.setDate(10, Date.valueOf(issued));
                ps.setDate(11, Date.valueOf(issued.plusMonths(rct.getValidityPeriod())));
                ps.setString(12, rc.getCardDeliveryMethod());
                ps.setInt(13, r.getId());
                ps.setInt(14, rt.getId());
                ps.setInt(15, rct.getId());
                if (ps.executeUpdate() != 1) throw new SQLException("Không tạo được thẻ");
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (!keys.next()) throw new SQLException("Không lấy được mã ID thẻ");
                    rc.setId(keys.getInt(1));
                }
            }
            rc.setReaderCardCode(code);
            rc.setIssueDate(issued);
            rc.setExpiryDate(issued.plusMonths(rct.getValidityPeriod()));
            rc.setReaderCardStatus("Đang hoạt động");
            rc.setReaderCardType(rct);
            rc.setReaderType(rt);
            return rc;
        } finally { DatabaseContext.release(con); }
    }
}
