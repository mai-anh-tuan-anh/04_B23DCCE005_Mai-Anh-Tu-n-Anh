<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%

    // 1. Lấy thông tin người dùng và đăng ký đang chờ thanh toán.
    Reader5 reader = (Reader5) session.getAttribute("reader5");
    if (reader == null) {
        response.sendRedirect(request.getContextPath() + "/view/Member/UILogin.jsp");
        return;
    }

    ReaderCard5 pending = (ReaderCard5) session.getAttribute("pendingReaderCard5");
    ReaderCardType5 cardType = (ReaderCardType5) session.getAttribute("pendingReaderCardType5");
    ReaderType5 readerType = (ReaderType5) session.getAttribute("pendingReaderType5");
    String error = null;

    // 2. Trình duyệt tự gửi yêu cầu hoàn tất sau ba giây.
    if ("1".equals(request.getParameter("complete"))) {
        synchronized (session) {
            if (session.getAttribute("completedInvoice5") != null) {
                response.sendRedirect("UIReaderCardInvoice5.jsp");
                return;
            }

            if (pending != null && cardType != null && readerType != null) {
                try {
                    ReaderCardRegistrationInvoice5 invoice = DAO.inTransaction(() -> {
                        ReaderCard5 savedCard = new ReaderCardDAO5().createReaderCard(
                            reader, pending, cardType, readerType
                        );
                        return new ReaderCardRegistrationInvoiceDAO5()
                            .createReaderCardRegistrationInvoice(savedCard, cardType.getRegistrationFee());
                    });

                    reader.setReaderCard(pending);
                    session.setAttribute("completedReaderCard5", pending);
                    session.setAttribute("completedInvoice5", invoice);
                    session.removeAttribute("pendingReaderCard5");
                    session.removeAttribute("pendingReaderCardType5");
                    session.removeAttribute("pendingReaderType5");

                    response.sendRedirect("UIReaderCardInvoice5.jsp");
                    return;
                } catch (Exception exception) {
                    application.log("Không thể lưu thẻ và hóa đơn", exception);
                    error = "Không thể hoàn tất đăng ký, chưa lưu thẻ và hóa đơn. "
                          + "Vui lòng quay lại kiểm tra thông tin.";
                }
            }
        }
    }

    // 3. Không cho mở thanh toán khi chưa có hồ sơ đăng ký.
    if (pending == null || cardType == null || readerType == null) {
        String destination = session.getAttribute("completedInvoice5") != null
            ? "UIReaderCardInvoice5.jsp"
            : "UIReaderCardRegistration5.jsp";
        response.sendRedirect(destination);
        return;
    }

    String base = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>THANH TOÁN PHÍ ĐĂNG KÝ THẺ</title>
        <%if(error==null){%>
        <meta http-equiv="refresh" content="3;url=UIReaderCardPayment5.jsp?complete=1">
        <%}%>
        <link rel="stylesheet" href="<%=base%>/assets/css/style.css">
    </head>
    <body>
        <main class="page">
            <h1 class="page-title">THANH TOÁN PHÍ ĐĂNG KÝ THẺ</h1>
            <%if(error!=null){%>
            <div class="notification error">
                <%=h(error)%>
            </div>
            <%}%>
            <section class="payment-box">
                <p class="payment-lead">Quét mã QR để thanh toán phí đăng ký thẻ</p>
                <img id="QR" class="qr-image" src="<%=base%>/assets/images/payment-qr.png" alt="Mã QR mô phỏng thanh toán đăng ký thẻ độc giả">
                <p id="paymentFee" class="payment-amount">Số tiền cần thanh toán: <strong>
                    <%=h(fmtMoney(cardType.getRegistrationFee()))%>
                </strong>
            </p>
            <p>Phí vận chuyển (nếu có) được thu riêng</p>
            <div class="actions">
                <a id="btnBack" class="btn" href="UIReaderCardRegistration5.jsp">Quay lại</a>
            </div>
        </section>
    </main>
</body>
</html>
