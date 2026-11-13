<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
ManagementStaff5 manager=(ManagementStaff5)session.getAttribute("managementStaff5");
if (manager == null) {
    response.sendRedirect(request.getContextPath() + "/view/Member/UILogin.jsp");
    return;
}
String base=request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>GIAO DIỆN CHÍNH CỦA NHÂN VIÊN QUẢN LÝ</title>
        <link rel="stylesheet" href="<%=base%>/assets/css/style.css">
    </head>
    <body>
        <main class="page">
            <h1 class="page-title">GIAO DIỆN CHÍNH CỦA NHÂN VIÊN QUẢN LÝ</h1>
            <% if("out".equals(request.getParameter("notice"))){ %>
            <div class="notification">Chức năng này nằm ngoài phạm vi hai module của bài tập lớn.</div>
            <% } %>
            <div class="menu-stack">
                <a class="btn btn-primary" href="UIStatisticsType5.jsp">Xem thống kê</a>
                <a class="btn" href="UIManagementStaff5.jsp?notice=out">Quản lý nhân viên thư viện</a>
                <a class="btn" href="UIManagementStaff5.jsp?notice=out">Cập nhật thông tin cá nhân</a>
                <a class="btn" href="UIManagementStaff5.jsp?notice=out">Đổi mật khẩu</a>
                <a class="btn" href="<%=base%>/view/Member/UILogout.jsp">Đăng xuất</a>
            </div>
        </main>
    </body>
</html>
