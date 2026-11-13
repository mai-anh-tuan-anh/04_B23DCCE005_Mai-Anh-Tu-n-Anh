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
        <title>CHỌN LOẠI THỐNG KÊ</title>
        <link rel="stylesheet" href="<%=base%>/assets/css/style.css">
    </head>
    <body>
        <main class="page">
            <h1 class="page-title">CHỌN LOẠI THỐNG KÊ</h1>
            <% if("out".equals(request.getParameter("notice"))){ %>
            <div class="notification">Chức năng này nằm ngoài phạm vi module thống kê theo đầu tài liệu.</div>
            <% } %>
            <div class="menu-stack statistics-menu">
                <a class="btn btn-primary" href="UIDocumentStatistics5.jsp">Thống kê theo đầu tài liệu</a>
                <a class="btn" href="UIStatisticsType5.jsp?notice=out">Thống kê theo độc giả</a>
                <a class="btn" href="UIStatisticsType5.jsp?notice=out">Thống kê theo tài liệu được nhập</a>
            </div>
            <div class="actions">
                <a class="btn" href="UIManagementStaff5.jsp">Quay lại</a>
            </div>
        </main>
    </body>
</html>
