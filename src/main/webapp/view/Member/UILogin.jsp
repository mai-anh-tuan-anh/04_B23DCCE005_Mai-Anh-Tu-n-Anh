<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
    request.setCharacterEncoding("UTF-8");

    // Nếu đã đăng nhập, chuyển đến giao diện của đúng vai trò.
    if (session.getAttribute("reader5") != null) {
        response.sendRedirect(request.getContextPath() + "/view/Reader/UIReader5.jsp");
        return;
    }
    if (session.getAttribute("managementStaff5") != null) {
        response.sendRedirect(request.getContextPath() + "/view/ManagementStaff/UIManagementStaff5.jsp");
        return;
    }

    String loginError = null;
    String username = request.getParameter("username");

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String password = request.getParameter("password");

        if (username == null || username.isBlank() || password == null || password.isBlank()) {
            loginError = "Vui lòng nhập tên đăng nhập và mật khẩu.";
        } else {
            String sql = "SELECT member.id, member.userName, member.fullName, member.gender, "
                + "member.address, member.dateOfBirth, member.email, member.phoneNumber, "
                + "member.`role` AS roleValue, reader.readerCode, staff.staffCode, manager.tblStaff5id AS managerId "
                + "FROM tblMember5 member "
                + "LEFT JOIN tblReader5 reader ON reader.tblMember5id = member.id "
                + "LEFT JOIN tblStaff5 staff ON staff.tblMember5id = member.id "
                + "LEFT JOIN tblManagementStaff5 manager ON manager.tblStaff5id = staff.tblMember5id "
                + "WHERE member.userName = ? AND member.passWord = ? LIMIT 1";

            try (Connection con = DAO.openConnection();
                 PreparedStatement statement = con.prepareStatement(sql)) {

                statement.setString(1, username.trim());
                statement.setString(2, password);

                try (ResultSet result = statement.executeQuery()) {
                    if (!result.next()) {
                        loginError = "Tên đăng nhập hoặc mật khẩu không chính xác.";
                    } else {
                        String role = result.getString("roleValue");
                        Member5 member = null;
                        String destination = null;

                        if ("READER".equals(role) && result.getString("readerCode") != null) {
                            Reader5 reader = new Reader5();
                            reader.setReaderCode(result.getString("readerCode"));
                            member = reader;
                            destination = "/view/Reader/UIReader5.jsp";
                        } else if ("MANAGEMENT_STAFF".equals(role)
                                   && result.getObject("managerId") != null) {
                            ManagementStaff5 manager = new ManagementStaff5();
                            manager.setStaffCode(result.getString("staffCode"));
                            member = manager;
                            destination = "/view/ManagementStaff/UIManagementStaff5.jsp";
                        } else {
                            loginError = "Tài khoản không thuộc hai vai trò demo đã triển khai.";
                        }

                        if (member != null) {
                            member.setId(result.getInt("id"));
                            member.setUserName(result.getString("userName"));
                            member.setFullName(result.getString("fullName"));
                            member.setGender(result.getString("gender"));
                            member.setAddress(result.getString("address"));
                            java.sql.Date dateOfBirth = result.getDate("dateOfBirth");
                            member.setDateOfBirth(dateOfBirth == null ? null : dateOfBirth.toLocalDate());
                            member.setEmail(result.getString("email"));
                            member.setPhoneNumber(result.getString("phoneNumber"));
                            member.setRole(role);

                            session.invalidate();
                            javax.servlet.http.HttpSession newSession = request.getSession(true);
                            newSession.setAttribute("member5", member);
                            if (member instanceof Reader5) {
                                newSession.setAttribute("reader5", member);
                            } else {
                                newSession.setAttribute("managementStaff5", member);
                            }
                            response.sendRedirect(request.getContextPath() + destination);
                            return;
                        }
                    }
                }
            } catch (SQLException error) {
                application.log("Không thể đăng nhập vào LibMan5", error);
                loginError = "Không kết nối được cơ sở dữ liệu. Vui lòng kiểm tra XAMPP.";
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>UILogin.jsp</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css">
</head>
<body>
    <main class="page auth-page">
        <h1 class="page-title">ĐĂNG NHẬP</h1>

        <% if (loginError != null) { %>
            <div class="notification error"><%=h(loginError)%></div>
        <% } %>

        <form class="auth-form" action="UILogin.jsp" method="post" accept-charset="UTF-8">
            <div class="field">
                <label for="username">Tên đăng nhập</label>
                <input id="username" name="username" type="text" maxlength="50"
                       value="<%=h(username)%>" required autocomplete="username" autofocus>
            </div>

            <div class="field">
                <label for="password">Mật khẩu</label>
                <input id="password" name="password" type="password" maxlength="255"
                       required autocomplete="current-password">
            </div>

            <div class="actions">
                <button class="btn btn-primary" type="submit">Đăng nhập</button>
            </div>
        </form>
    </main>
</body>
</html>
