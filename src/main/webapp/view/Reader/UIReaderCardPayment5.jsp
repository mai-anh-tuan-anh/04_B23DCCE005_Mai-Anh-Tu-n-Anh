<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
Reader5 reader=(Reader5)session.getAttribute("reader5");
if(reader==null){response.sendRedirect(request.getContextPath()+"/view/Member/gddangnhap.jsp");return;}
ReaderCard5 pending=(ReaderCard5)session.getAttribute("pendingReaderCard5");
ReaderCardType5 cardType=(ReaderCardType5)session.getAttribute("pendingReaderCardType5");
ReaderType5 readerType=(ReaderType5)session.getAttribute("pendingReaderType5");
String error=null;
if("1".equals(request.getParameter("complete"))) {
    synchronized(session) {
        // Không tạo thẻ hai lần khi người dùng tải lại trang hoặc hai yêu cầu đồng thời đến.
        if(session.getAttribute("completedInvoice5")!=null) {
            response.sendRedirect("UIReaderCardInvoice5.jsp"); return;
        }
        if(pending!=null && cardType!=null && readerType!=null) {
            try {
                final ReaderCard5 card=pending;
                final ReaderCardType5 selectedCardType=cardType;
                final ReaderType5 selectedReaderType=readerType;
                ReaderCardRegistrationInvoice5 invoice=DatabaseContext.inTransaction(() -> {
                    ReaderCard5 saved=new ReaderCardDAO5().createReaderCard(
                        reader,card,selectedCardType,selectedReaderType);
                    return new ReaderCardRegistrationInvoiceDAO5()
                        .createReaderCardRegistrationInvoice(saved,selectedCardType.getRegistrationFee());
                });
                reader.setReaderCard(card);
                session.setAttribute("completedReaderCard5",card);
                session.setAttribute("completedInvoice5",invoice);
                session.removeAttribute("pendingReaderCard5");
                session.removeAttribute("pendingReaderCardType5");
                session.removeAttribute("pendingReaderType5");
                response.sendRedirect("UIReaderCardInvoice5.jsp");return;
            } catch(Exception ex) {
                application.log("Không lưu được thẻ + hóa đơn trong transaction",ex);
                error="Không thể hoàn tất đăng ký, chưa lưu thẻ và hóa đơn. Vui lòng quay lại kiểm tra thông tin.";
            }
        }
    }
}
if(pending==null || cardType==null || readerType==null) {
    if(session.getAttribute("completedInvoice5")!=null)response.sendRedirect("UIReaderCardInvoice5.jsp");
    else response.sendRedirect("UIReaderCardRegistration5.jsp");
    return;
}
String base=request.getContextPath();
%>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>THANH TOÁN PHÍ ĐĂNG KÝ THẺ</title>
<%if(error==null){%><meta http-equiv="refresh" content="3;url=UIReaderCardPayment5.jsp?complete=1"><%}%>
<link rel="stylesheet" href="<%=base%>/assets/css/style.css"></head><body>
<main class="page"><h1 class="page-title">THANH TOÁN PHÍ ĐĂNG KÝ THẺ</h1>
<%if(error!=null){%><div class="notification error"><%=h(error)%></div><%}%>
<section class="payment-box">
<p class="payment-lead">Quét mã QR để thanh toán phí đăng ký thẻ</p>
<img id="QR" class="qr-image" src="<%=base%>/assets/images/payment-qr.png" alt="Mã QR mô phỏng thanh toán đăng ký thẻ độc giả">
<p id="paymentFee" class="payment-amount">Số tiền cần thanh toán: <strong><%=h(fmtMoney(cardType.getRegistrationFee()))%></strong></p>
<p>Phí vận chuyển (nếu có) được thu riêng</p>
<div class="actions"><a id="btnBack" class="btn" href="UIReaderCardRegistration5.jsp">Quay lại</a></div>
</section></main></body></html>
