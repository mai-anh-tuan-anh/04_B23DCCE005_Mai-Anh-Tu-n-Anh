package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.*;
import model.*;

public class LoanDAO5 extends DAO {
    public LoanDAO5() { super(); }

    public Loan5[] getLoansByDocumentTitle(DocumentStatistics5 ds,
                                           LocalDate startDate, LocalDate endDate) throws SQLException {
        if (ds == null || ds.getId() <= 0 || startDate == null || endDate == null)
            throw new IllegalArgumentException("Thiếu đầu tài liệu hoặc khoảng thời gian");
        List<Loan5> result = new ArrayList<>();
        con = DatabaseContext.connection();
        String sql = "SELECT loan.id AS loanId,loan.returnDate,loan.fine," +
            "copy.id AS copyId,copy.documentCopyCode,copy.documentCopyStatus,copy.documentCopyCondition," +
            "title.id AS titleId,title.documentTitleCode,title.documentTitleName," +
            "title.author,title.publisher,title.publicationDate,title.description,title.shelfLocation " +
            "FROM tblLoan5 loan " +
            "JOIN tblLoanSlip5 slip ON slip.id=loan.tblLoanSlip5id " +
            "JOIN tblDocumentCopy5 copy ON copy.id=loan.tblDocumentCopy5id " +
            "JOIN tblDocumentTitle5 title ON title.id=copy.tblDocumentTitle5id " +
            "WHERE title.id=? AND slip.loanDate BETWEEN ? AND ? ORDER BY loan.id";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, ds.getId());
            ps.setDate(2, java.sql.Date.valueOf(startDate));
            ps.setDate(3, java.sql.Date.valueOf(endDate));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Loan5 loan = new Loan5();
                    loan.setId(rs.getInt("loanId"));
                    java.sql.Date returned = rs.getDate("returnDate");
                    loan.setReturnDate(returned == null ? null : returned.toLocalDate());
                    loan.setFine(rs.getBigDecimal("fine"));
                    DocumentTitle5 title = new DocumentTitle5();
                    title.setId(rs.getInt("titleId"));
                    title.setDocumentTitleCode(rs.getString("documentTitleCode"));
                    title.setDocumentTitleName(rs.getString("documentTitleName"));
                    title.setAuthor(rs.getString("author"));
                    title.setPublisher(rs.getString("publisher"));
                    java.sql.Date pub = rs.getDate("publicationDate");
                    title.setPublicationDate(pub == null ? null : pub.toLocalDate());
                    title.setDescription(rs.getString("description"));
                    title.setShelfLocation(rs.getString("shelfLocation"));
                    DocumentCopy5 copy = new DocumentCopy5();
                    copy.setId(rs.getInt("copyId"));
                    copy.setDocumentCopyCode(rs.getString("documentCopyCode"));
                    copy.setDocumentCopyStatus(rs.getString("documentCopyStatus"));
                    copy.setDocumentCopyCondition(rs.getString("documentCopyCondition"));
                    copy.setDocumentTitle(title);
                    loan.setDocumentCopy(copy);
                    result.add(loan);
                }
            }
        } finally { DatabaseContext.release(con); }
        return result.toArray(new Loan5[0]);
    }
}
