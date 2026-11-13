<%@ page pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
Reader5 reader=(Reader5)session.getAttribute("reader5");
if (reader == null) {
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
        <title>UIReader5.jsp</title>
        <link rel="stylesheet" href="<%=base%>/assets/css/style.css">
    </head>
    <body>
        <main class="page">
            <h1 class="page-title">GIAO DIỆN CHÍNH CỦA ĐỘC GIẢ</h1>
            <% if("out".equals(request.getParameter("notice"))){ %>
            <div class="notification">Chức năng này nằm ngoài phạm vi hai module của bài tập lớn.</div>
            <% } %>
            <div class="menu-stack">
                <a class="btn btn-primary" href="<%=base%>/view/Reader/UIReaderCardRegistration5.jsp">Đăng ký thẻ độc giả</a>
                <a class="btn" href="UIReader5.jsp?notice=out">Gia hạn thẻ độc giả</a>
                <a class="btn" href="UIReader5.jsp?notice=out">Tìm kiếm thông tin tài liệu</a>
                <a class="btn" href="UIReader5.jsp?notice=out">Cập nhật thông tin cá nhân</a>
                <a class="btn" href="UIReader5.jsp?notice=out">Đổi mật khẩu</a>
                <a class="btn" href="<%=base%>/view/Member/UILogout.jsp">Đăng xuất</a>
            </div>
        </main>
    </body>
</html>
