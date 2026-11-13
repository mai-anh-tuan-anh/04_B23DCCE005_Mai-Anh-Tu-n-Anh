package dao;

import java.sql.*;
import java.time.LocalDate;
import java.util.*;
import model.*;

public class DocumentStatisticsDAO5 extends DAO {
    public DocumentStatisticsDAO5() { super(); }

    public DocumentStatistics5[] getDocumentStatistics(LocalDate startDate, LocalDate endDate) throws SQLException {
        if (startDate == null || endDate == null || startDate.isAfter(endDate))
            throw new IllegalArgumentException("Khoảng thời gian thống kê không hợp lệ");
        Map<Integer, DocumentStatistics5> result = new LinkedHashMap<>();
        con = DatabaseContext.connection();
        try {
            String sql = "SELECT dt.id, dt.documentTitleCode, dt.documentTitleName, " +
                "dt.author,dt.publisher,dt.publicationDate,dt.description,dt.shelfLocation, " +
                "COUNT(DISTINCT loan.id) AS loanAmount " +
                "FROM tblDocumentTitle5 dt " +
                "JOIN tblDocumentCopy5 copy ON copy.tblDocumentTitle5id=dt.id " +
                "JOIN tblLoan5 loan ON loan.tblDocumentCopy5id=copy.id " +
                "JOIN tblLoanSlip5 slip ON loan.tblLoanSlip5id=slip.id " +
                "WHERE slip.loanDate BETWEEN ? AND ? " +
                "GROUP BY dt.id,dt.documentTitleCode,dt.documentTitleName, " +
                "dt.author,dt.publisher,dt.publicationDate,dt.description,dt.shelfLocation " +
                "ORDER BY loanAmount DESC, dt.documentTitleCode ASC";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setDate(1, java.sql.Date.valueOf(startDate));
                ps.setDate(2, java.sql.Date.valueOf(endDate));
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        DocumentStatistics5 d = new DocumentStatistics5();
                        d.setId(rs.getInt("id"));
                        d.setDocumentTitleCode(rs.getString("documentTitleCode"));
                        d.setDocumentTitleName(rs.getString("documentTitleName"));
                        d.setAuthor(rs.getString("author"));
                        d.setPublisher(rs.getString("publisher"));
                        java.sql.Date pub = rs.getDate("publicationDate");
                        d.setPublicationDate(pub == null ? null : pub.toLocalDate());
                        d.setDescription(rs.getString("description"));
                        d.setShelfLocation(rs.getString("shelfLocation"));
                        d.setLoanAmount(rs.getInt("loanAmount"));
                        result.put(d.getId(), d);
                    }
                }
            }
            if (!result.isEmpty()) {
                StringJoiner q = new StringJoiner(",");
                for (int ignored : result.keySet()) q.add("?");
                String typeSql = "SELECT tt.id AS titleTypeId,tt.tblDocumentTitle5id,tt.assignDate," +
                    "ty.id AS typeId,ty.documentTypeCode,ty.documentTypeName " +
                    "FROM tblTitleType5 tt " +
                    "JOIN tblDocumentType5 ty ON ty.id=tt.tblDocumentType5id " +
                    "WHERE tt.tblDocumentTitle5id IN (" + q + ") ORDER BY ty.documentTypeName";
                Map<Integer,List<TitleType5>> byTitle = new HashMap<>();
                try (PreparedStatement ps = con.prepareStatement(typeSql)) {
                    int i = 1;
                    for (int id : result.keySet()) ps.setInt(i++, id);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            DocumentType5 type = new DocumentType5();
                            type.setId(rs.getInt("typeId"));
                            type.setDocumentTypeCode(rs.getString("documentTypeCode"));
                            type.setDocumentTypeName(rs.getString("documentTypeName"));
                            TitleType5 tt = new TitleType5();
                            tt.setId(rs.getInt("titleTypeId"));
                            java.sql.Date date = rs.getDate("assignDate");
                            tt.setAssignDate(date == null ? null : date.toLocalDate());
                            tt.setDocumentType(type);
                            byTitle.computeIfAbsent(rs.getInt("tblDocumentTitle5id"), k -> new ArrayList<>()).add(tt);
                        }
                    }
                }
                for (DocumentStatistics5 d : result.values())
                    d.setTitleTypes(byTitle.getOrDefault(d.getId(), Collections.emptyList()).toArray(new TitleType5[0]));
            }
        } finally { DatabaseContext.release(con); }
        return result.values().toArray(new DocumentStatistics5[0]);
    }
}
