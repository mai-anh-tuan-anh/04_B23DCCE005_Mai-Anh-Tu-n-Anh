<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
Reader5 reader=(Reader5)session.getAttribute("reader5");
if(reader==null){response.sendRedirect(request.getContextPath()+"/view/Member/gddangnhap.jsp");return;}
ReaderCard5 card=(ReaderCard5)session.getAttribute("completedReaderCard5");
ReaderCardRegistrationInvoice5 invoice=(ReaderCardRegistrationInvoice5)session.getAttribute("completedInvoice5");
if(card==null||invoice==null){response.sendRedirect("UIReaderCardRegistration5.jsp");return;}
String base=request.getContextPath();
%>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>CHI TIẾT HÓA ĐƠN ĐĂNG KÝ THẺ</title><link rel="stylesheet" href="<%=base%>/assets/css/style.css"></head><body>
<main class="page"><h1 class="page-title">CHI TIẾT HÓA ĐƠN ĐĂNG KÝ THẺ</h1>
<div class="invoice-head"><div>Mã hóa đơn: <strong><%=h(invoice.getInvoiceCode())%></strong></div><div>Ngày lập hóa đơn: <strong><%=fmtDate(invoice.getInvoiceDate())%></strong></div></div>
<div class="section-heading">Thông tin thẻ</div>
<div class="display-grid">
<div class="display-field"><span>Mã thẻ</span><strong><%=h(card.getReaderCardCode())%></strong></div>
<div class="display-field"><span>Loại thẻ</span><strong><%=h(card.getReaderCardType().getReaderCardTypeName())%></strong></div>
<div class="display-field"><span>Loại bạn đọc</span><strong><%=h(card.getReaderType().getReaderTypeName())%></strong></div>
<div class="display-field"><span>Ngày cấp thẻ</span><strong><%=fmtDate(card.getIssueDate())%></strong></div>
<div class="display-field"><span>Ngày hết hạn</span><strong><%=fmtDate(card.getExpiryDate())%></strong></div>
</div>
<div class="section-heading">Thông tin bạn đọc</div>
<div class="display-grid">
<div class="display-field"><span>Họ tên</span><strong><%=h(card.getFullName())%></strong></div>
<div class="display-field"><span>Giới tính</span><strong><%=h(card.getGender())%></strong></div>
<div class="display-field"><span>Ngày sinh</span><strong><%=fmtDate(card.getDateOfBirth())%></strong></div>
<div class="display-field"><span>CCCD</span><strong><%=h(card.getCitizenIdentificationNumber())%></strong></div>
<div class="display-field"><span>Email</span><strong><%=h(card.getEmail())%></strong></div>
<div class="display-field"><span>Số điện thoại</span><strong><%=h(card.getPhoneNumber())%></strong></div>
<div class="display-field field-full"><span>Địa chỉ</span><strong><%=h(card.getAddress())%></strong></div>
</div>
<div class="section-heading">Thông tin thanh toán</div>
<div class="display-grid">
<div class="display-field"><span>Nơi nhận thẻ</span><strong><%=h(card.getCardDeliveryMethod())%></strong></div>
<div class="display-field"><span>Số tiền đã thanh toán</span><strong><%=fmtMoney(invoice.getPaidAmount())%></strong></div>
</div>
<div class="actions"><a id="btnHome" class="btn btn-primary" href="UIReader5.jsp">Về giao diện chính</a></div>
</main></body></html>
