<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
    if (session.getAttribute("reader5") != null) {
        response.sendRedirect(request.getContextPath()+"/view/Reader/UIReader5.jsp"); return;
    }
    if (session.getAttribute("managementStaff5") != null) {
        response.sendRedirect(request.getContextPath()+"/view/ManagementStaff/UIManagementStaff5.jsp"); return;
    }
    String error = (String)session.getAttribute("loginError");
    session.removeAttribute("loginError");
%>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>ĐĂNG NHẬP</title><link rel="stylesheet" href="<%=request.getContextPath()%>/assets/css/style.css"></head>
<body><main class="page auth-page"><h1 class="page-title">ĐĂNG NHẬP</h1>
    <% if(error!=null){ %><div class="notification error"><%=h(error)%></div><% } %>
    <form class="auth-form" action="<%=request.getContextPath()%>/view/Member/doDangnhap.jsp" method="post" accept-charset="UTF-8">
      <div class="field"><label for="username">Tên đăng nhập</label><input autofocus id="username" name="username" type="text" maxlength="50" required autocomplete="username"></div>
      <div class="field"><label for="password">Mật khẩu</label><input id="password" name="password" type="password" maxlength="255" required autocomplete="current-password"></div>
      <div class="actions"><button class="btn btn-primary" type="submit">Đăng nhập</button></div>
    </form>
</main></body></html>
