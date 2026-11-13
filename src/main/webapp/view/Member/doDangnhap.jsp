<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
    if (!"POST".equalsIgnoreCase(request.getMethod())) {
        response.sendRedirect(request.getContextPath() + "/view/Member/gddangnhap.jsp"); return;
    }
    request.setCharacterEncoding("UTF-8");
    String username = request.getParameter("username");
    String password = request.getParameter("password");
    if (username == null || username.isBlank() || password == null || password.isBlank()) {
        session.setAttribute("loginError", "Vui lòng nhập tên đăng nhập và mật khẩu.");
        response.sendRedirect(request.getContextPath() + "/view/Member/gddangnhap.jsp"); return;
    }
    // Đăng nhập phụ trợ nằm ngoài hai module; không tạo thêm bất kỳ DAO nghiệp vụ nào.
    String sql = "SELECT m.id,m.userName,m.passWord,m.fullName,m.gender,m.address,m.dateOfBirth,"+
        "m.email,m.phoneNumber,m.`role` AS roleValue,r.readerCode,s.staffCode, mg.tblStaff5id AS managerId " +
        "FROM tblMember5 m " +
        "LEFT JOIN tblReader5 r ON r.tblMember5id=m.id " +
        "LEFT JOIN tblStaff5 s ON s.tblMember5id=m.id " +
        "LEFT JOIN tblManagementStaff5 mg ON mg.tblStaff5id=s.tblMember5id " +
        "WHERE m.userName=? AND m.passWord=? LIMIT 1";
    try (Connection connection = DatabaseContext.connection();
         PreparedStatement statement = connection.prepareStatement(sql)) {
        statement.setString(1, username.trim());
        statement.setString(2, password);
        try (ResultSet rs = statement.executeQuery()) {
            if (rs.next()) {
                String role = rs.getString("roleValue");
                String destination;
                Member5 member;
                if ("READER".equals(role) && rs.getString("readerCode") != null) {
                    Reader5 reader = new Reader5();
                    reader.setReaderCode(rs.getString("readerCode"));
                    member = reader;
                    destination = "/view/Reader/UIReader5.jsp";
                } else if ("MANAGEMENT_STAFF".equals(role) && rs.getObject("managerId")!=null) {
                    ManagementStaff5 manager = new ManagementStaff5();
                    manager.setStaffCode(rs.getString("staffCode"));
                    member = manager;
                    destination = "/view/ManagementStaff/UIManagementStaff5.jsp";
                } else {
                    session.setAttribute("loginError", "Tài khoản không thuộc hai vai trò demo đã triển khai.");
                    response.sendRedirect(request.getContextPath()+"/view/Member/gddangnhap.jsp"); return;
                }
                member.setId(rs.getInt("id"));
                member.setUserName(rs.getString("userName"));
                member.setFullName(rs.getString("fullName"));
                member.setGender(rs.getString("gender"));
                member.setAddress(rs.getString("address"));
                java.sql.Date birth = rs.getDate("dateOfBirth");
                member.setDateOfBirth(birth==null?null:birth.toLocalDate());
                member.setEmail(rs.getString("email"));
                member.setPhoneNumber(rs.getString("phoneNumber"));
                member.setRole(role);
                session.invalidate(); // Hủy session cũ, tránh lẫn trạng thái đăng nhập trước.
                javax.servlet.http.HttpSession fresh = request.getSession(true);
                fresh.setAttribute("member5",member);
                if (member instanceof Reader5) fresh.setAttribute("reader5",member);
                else fresh.setAttribute("managementStaff5",member);
                response.sendRedirect(request.getContextPath()+destination); return;
            }
        }
        session.setAttribute("loginError", "Tên đăng nhập hoặc mật khẩu không chính xác.");
    } catch (SQLException error) {
        application.log("Lỗi kết nối CSDL khi đăng nhập",error);
        session.setAttribute("loginError", "Không kết nối được cơ sở dữ liệu. Kiểm tra XAMPP và cấu hình JDBC.");
    }
    response.sendRedirect(request.getContextPath()+"/view/Member/gddangnhap.jsp");
%>
