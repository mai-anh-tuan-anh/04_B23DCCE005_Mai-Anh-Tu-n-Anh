package dao;

import java.sql.*;
import java.util.*;
import model.*;

public class LoanSlipDAO5 extends DAO {
    public LoanSlipDAO5() throws SQLException {
        super();
    }

    /** Một truy vấn theo danh sách lượt mượn; mỗi phiếu trả về chứa đầy đủ các lượt mượn. */
    public LoanSlip5[] getLoanSlipsByLoans(Loan5[] loans) throws SQLException {
        if (loans == null || loans.length == 0) {
            closeConnection();
            return new LoanSlip5[0];
        }
        LinkedHashSet<Integer> ids = new LinkedHashSet<>();
        for (Loan5 loan : loans) if (loan != null && loan.getId() > 0) ids.add(loan.getId());
        if (ids.isEmpty()) {
            closeConnection();
            return new LoanSlip5[0];
        }
        Map<Integer, LoanSlip5> result = new LinkedHashMap<>();
                try {
            StringJoiner marks = new StringJoiner(",");
            for (int ignored : ids) marks.add("?");
            String sql = "SELECT DISTINCT slip.id AS slipId,slip.loanSlipCode,slip.loanDate," +
                "slip.dueDate,slip.loanSlipStatus," +
                "reader.tblMember5id AS readerId,reader.readerCode,rm.userName AS readerUserName," +
                "rm.fullName AS readerFullName,rm.gender AS readerGender,rm.address AS readerAddress," +
                "rm.email AS readerEmail,rm.phoneNumber AS readerPhoneNumber," +
                "staff.tblStaff5id AS staffId,st.staffCode,sm.fullName AS staffFullName " +
                "FROM tblLoan5 loan " +
                "JOIN tblLoanSlip5 slip ON slip.id=loan.tblLoanSlip5id " +
                "JOIN tblReader5 reader ON reader.tblMember5id=slip.tblReader5id " +
                "JOIN tblMember5 rm ON rm.id=reader.tblMember5id " +
                "JOIN tblLibraryStaff5 staff ON staff.tblStaff5id=slip.tblLibraryStaff5id " +
                "JOIN tblStaff5 st ON st.tblMember5id=staff.tblStaff5id " +
                "JOIN tblMember5 sm ON sm.id=staff.tblStaff5id " +
                "WHERE loan.id IN (" + marks + ") ORDER BY slip.id";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                int i = 1;
                for (int id : ids) ps.setInt(i++, id);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        LoanSlip5 slip = new LoanSlip5();
                        slip.setId(rs.getInt("slipId"));
                        slip.setLoanSlipCode(rs.getString("loanSlipCode"));
                        java.sql.Date loanDate = rs.getDate("loanDate");
                        java.sql.Date dueDate = rs.getDate("dueDate");
                        slip.setLoanDate(loanDate == null ? null : loanDate.toLocalDate());
                        slip.setDueDate(dueDate == null ? null : dueDate.toLocalDate());
                        slip.setLoanSlipStatus(rs.getString("loanSlipStatus"));
                        Reader5 reader = new Reader5();
                        reader.setId(rs.getInt("readerId"));
                        reader.setReaderCode(rs.getString("readerCode"));
                        reader.setUserName(rs.getString("readerUserName"));
                        reader.setFullName(rs.getString("readerFullName"));
                        reader.setGender(rs.getString("readerGender"));
                        reader.setAddress(rs.getString("readerAddress"));
                        reader.setEmail(rs.getString("readerEmail"));
                        reader.setPhoneNumber(rs.getString("readerPhoneNumber"));
                        slip.setReader(reader);
                        LibraryStaff5 staff = new LibraryStaff5();
                        staff.setId(rs.getInt("staffId"));
                        staff.setStaffCode(rs.getString("staffCode"));
                        staff.setFullName(rs.getString("staffFullName"));
                        slip.setLibraryStaff(staff);
                        result.put(slip.getId(), slip);
                    }
                }
            }
            if (!result.isEmpty()) {
                StringJoiner slipMarks = new StringJoiner(",");
                for (int ignored : result.keySet()) slipMarks.add("?");
                String loanSql = "SELECT loan.tblLoanSlip5id,loan.id AS loanId,loan.returnDate,loan.fine," +
                    "copy.id AS copyId,copy.documentCopyCode,copy.documentCopyStatus,copy.documentCopyCondition," +
                    "title.id AS titleId,title.documentTitleCode,title.documentTitleName," +
                    "title.author,title.publisher,title.publicationDate,title.description,title.shelfLocation " +
                    "FROM tblLoan5 loan " +
                    "JOIN tblDocumentCopy5 copy ON copy.id=loan.tblDocumentCopy5id " +
                    "JOIN tblDocumentTitle5 title ON title.id=copy.tblDocumentTitle5id " +
                    "WHERE loan.tblLoanSlip5id IN (" + slipMarks + ") " +
                    "ORDER BY copy.documentCopyCode, loan.id";
                Map<Integer,List<Loan5>> bySlip = new HashMap<>();
                try (PreparedStatement ps = con.prepareStatement(loanSql)) {
                    int i = 1;
                    for (int id : result.keySet()) ps.setInt(i++, id);
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
                            java.sql.Date published = rs.getDate("publicationDate");
                            title.setPublicationDate(published == null ? null : published.toLocalDate());
                            title.setDescription(rs.getString("description"));
                            title.setShelfLocation(rs.getString("shelfLocation"));
                            DocumentCopy5 copy = new DocumentCopy5();
                            copy.setId(rs.getInt("copyId"));
                            copy.setDocumentCopyCode(rs.getString("documentCopyCode"));
                            copy.setDocumentCopyStatus(rs.getString("documentCopyStatus"));
                            copy.setDocumentCopyCondition(rs.getString("documentCopyCondition"));
                            copy.setDocumentTitle(title);
                            loan.setDocumentCopy(copy);
                            bySlip.computeIfAbsent(rs.getInt("tblLoanSlip5id"), k -> new ArrayList<>()).add(loan);
                        }
                    }
                }
                for (LoanSlip5 slip : result.values())
                    slip.setLoans(bySlip.getOrDefault(slip.getId(), Collections.emptyList()).toArray(new Loan5[0]));
            }
        } finally { closeConnection(); }
        return result.values().toArray(new LoanSlip5[0]);
    }

    public LoanSlip5 getLoanSlipByLoan(Loan5 l) throws SQLException {
        if (l == null || l.getId() <= 0) {
            closeConnection();
            return null;
        }
        LoanSlip5[] slips = getLoanSlipsByLoans(new Loan5[]{l});
        return slips.length == 0 ? null : slips[0];
    }
}
