<%@ page pageEncoding="UTF-8" %> <%@ page pageEncoding="UTF-8" %> <% // Kết thúc
phiên làm việc và trở về trang đăng nhập. session.invalidate();
response.sendRedirect(request.getContextPath() + "/view/Member/UILogin.jsp"); %>
