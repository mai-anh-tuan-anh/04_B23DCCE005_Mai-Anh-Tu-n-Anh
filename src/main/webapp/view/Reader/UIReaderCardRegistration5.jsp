<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
Reader5 reader=(Reader5)session.getAttribute("reader5");
if (reader == null) {
    response.sendRedirect(request.getContextPath() + "/view/Member/UILogin.jsp");
    return;
}
request.setCharacterEncoding("UTF-8");
String base=request.getContextPath();
String error=null;
ReaderCard5 pending=(ReaderCard5)session.getAttribute("pendingReaderCard5");
if("POST".equalsIgnoreCase(request.getMethod())) {
    String action=request.getParameter("action");
    if("reset".equals(action)) {
        session.removeAttribute("pendingReaderCard5");
        session.removeAttribute("pendingReaderCardType5");
        session.removeAttribute("pendingReaderType5");
        response.sendRedirect("UIReaderCardRegistration5.jsp");return;
    }
    if("register".equals(action)) {
        ReaderCard5 candidate=new ReaderCard5();
        candidate.setFullName(request.getParameter("fullName")==null?"":request.getParameter("fullName").trim());
        candidate.setGender(request.getParameter("gender"));
        candidate.setCitizenIdentificationNumber(request.getParameter("citizenIdentificationNumber")==null?"":request.getParameter("citizenIdentificationNumber").trim());
        candidate.setEmail(request.getParameter("email")==null?"":request.getParameter("email").trim());
        candidate.setPhoneNumber(request.getParameter("phoneNumber")==null?"":request.getParameter("phoneNumber").trim());
        candidate.setAddress(request.getParameter("address")==null?"":request.getParameter("address").trim());
        candidate.setCardDeliveryMethod(request.getParameter("cardDeliveryMethod"));
        try { candidate.setDateOfBirth(LocalDate.parse(request.getParameter("dateOfBirth"))); }
        catch(Exception ignored) { candidate.setDateOfBirth(null); }
        pending=candidate;
        session.setAttribute("pendingReaderCard5",candidate);
        // Chỉ kiểm tra dữ liệu thuộc biểu mẫu đã thiết kế, không thêm DAO kiểm tra mới.
        if(candidate.getFullName().isEmpty() || candidate.getGender()==null || candidate.getDateOfBirth()==null ||
           candidate.getAddress().isEmpty() || candidate.getEmail().isEmpty() || candidate.getPhoneNumber().isEmpty() ||
           candidate.getCardDeliveryMethod()==null || !candidate.getCitizenIdentificationNumber().matches("[0-9]{12}")) {
            error="Vui lòng nhập đầy đủ thông tin hợp lệ; CCCD phải có đúng 12 chữ số.";
        } else if (!candidate.getDateOfBirth().isBefore(LocalDate.now())) {
            error="Ngày sinh phải trước ngày hiện tại.";
        } else if (!candidate.getEmail().matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            error="Địa chỉ email không hợp lệ.";
        } else if (!candidate.getPhoneNumber().matches("0[0-9]{9}")) {
            error="Số điện thoại phải có 10 chữ số và bắt đầu bằng 0.";
        } else {
            try {
                ReaderCardType5[] allTypes=new ReaderCardTypeDAO5().getReaderCardTypes();
                ReaderType5[] allReaderTypes=new ReaderTypeDAO5().getReaderTypes();
                int cardTypeId=intValue(request.getParameter("readerCardType"),0);
                int readerTypeId=intValue(request.getParameter("readerType"),0);
                ReaderCardType5 chosenCardType=null;
                ReaderType5 chosenReaderType=null;
                for(ReaderCardType5 type:allTypes)if(type.getId()==cardTypeId)chosenCardType=type;
                for(ReaderType5 type:allReaderTypes)if(type.getId()==readerTypeId)chosenReaderType=type;
                if(chosenCardType==null || chosenReaderType==null) {
                    error="Vui lòng chọn loại thẻ và loại bạn đọc hợp lệ.";
                } else {
                    session.setAttribute("pendingReaderCardType5",chosenCardType);
                    session.setAttribute("pendingReaderType5",chosenReaderType);
                    String eligibility=new ReaderCardDAO5().checkReaderCardRegistration(reader,candidate.getCitizenIdentificationNumber());
                    if("READER_ALREADY_HAS_CARD".equals(eligibility))error="Độc giả đã sở hữu thẻ. Không thể đăng ký thêm thẻ.";
                    else if("CCCD_ALREADY_USED".equals(eligibility))error="CCCD này đã được sử dụng để đăng ký thẻ độc giả.";
                    else if("ELIGIBLE".equals(eligibility)){
                        session.removeAttribute("completedReaderCard5");
                        session.removeAttribute("completedInvoice5");
                        response.sendRedirect("UIReaderCardPayment5.jsp");return;
                    } else error="Không xác định được điều kiện đăng ký thẻ.";
                }
            } catch(Exception ex) {
                application.log("Lỗi kiểm tra đăng ký",ex);
                error="Không thể kiểm tra điều kiện đăng ký. Hãy kiểm tra kết nối CSDL.";
            }
        }
    }
}
ReaderCardType5[] types=new ReaderCardType5[0];
ReaderType5[] readerTypes=new ReaderType5[0];
try {
    types=new ReaderCardTypeDAO5().getReaderCardTypes();
    readerTypes=new ReaderTypeDAO5().getReaderTypes();
} catch(SQLException ex) {
    application.log("Lỗi tải loại thẻ/loại bạn đọc",ex);
    error="Không tải được danh sách loại thẻ và loại bạn đọc. Kiểm tra XAMPP và dữ liệu mẫu.";
}
ReaderCardType5 selectedCard=(ReaderCardType5)session.getAttribute("pendingReaderCardType5");
ReaderType5 selectedReader=(ReaderType5)session.getAttribute("pendingReaderType5");
int selectedCardId=intValue(request.getParameter("readerCardType"),selectedCard==null?2:selectedCard.getId());
int selectedReaderId=intValue(request.getParameter("readerType"),selectedReader==null?1:selectedReader.getId());
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>ĐĂNG KÝ THẺ ĐỘC GIẢ</title>
        <link rel="stylesheet" href="<%=base%>/assets/css/style.css">
    </head>
    <body>
        <main class="page">
            <h1 class="page-title">ĐĂNG KÝ THẺ ĐỘC GIẢ</h1>
            <% if(error!=null){ %>
            <div class="notification error">
                <%=h(error)%>
            </div>
            <% } %>
            <form action="UIReaderCardRegistration5.jsp" method="post" accept-charset="UTF-8" class="registration-form">
                <div class="section-heading">Thông tin thẻ</div>
                <div class="form-grid">
                    <div class="field">
                        <label for="readerCardType">Loại thẻ <span class="required">(*)</span>
                        </label>
                        <select id="readerCardType" name="readerCardType" required>
                            <%for(ReaderCardType5 type:types){%>
                            <option value="<%=type.getId()%>" <%=type.getId()==selectedCardId?"selected":""%>>
                                <%=h(type.getReaderCardTypeName())%> – <%=h(fmtMoney(type.getRegistrationFee()))%> – hạn mượn <%=type.getLoanDuration()%> ngày – thẻ <%=type.getValidityPeriod()%> tháng – tối đa <%=type.getMaxBorrowedCopies()%> quyển</option>
                                <%}%>
                            </select>
                        </div>
                        <div class="field">
                            <label for="readerType">Loại bạn đọc <span class="required">(*)</span>
                            </label>
                            <select id="readerType" name="readerType" required>
                                <%for(ReaderType5 t:readerTypes){%>
                                <option value="<%=t.getId()%>" <%=t.getId()==selectedReaderId?"selected":""%>>
                                    <%=h(t.getReaderTypeName())%>
                                </option>
                                <%}%>
                            </select>
                        </div>
                        <div class="field">
                            <label for="fullName">Họ tên <span class="required">(*)</span>
                            </label>
                            <input id="fullName" name="fullName" maxlength="150" placeholder="Họ và tên" required value="<%=h(pending==null?"":pending.getFullName())%>">
                        </div>
                        <div class="field">
                            <label>Giới tính <span class="required">(*)</span>
                            </label>
                            <div class="radio-row">
                                <% for(String sex:new String[]{"Nam","Nữ","Khác"}){ %>
                                <label>
                                    <input type="radio" name="gender" value="<%=sex%>" <%=pending!=null&&sex.equals(pending.getGender())?"checked":""%> required> <%=sex%>
                                </label>
                                <% } %>
                            </div>
                        </div>
                        <div class="field">
                            <label for="dateOfBirth">Ngày sinh <span class="required">(*)</span>
                            </label>
                            <input id="dateOfBirth" name="dateOfBirth" type="date" required max="<%=LocalDate.now().minusDays(1)%>" value="<%=pending==null?"":dateInput(pending.getDateOfBirth())%>">
                        </div>
                        <div class="field">
                            <label for="citizenIdentificationNumber">CCCD <span class="required">(*)</span>
                            </label>
                            <input id="citizenIdentificationNumber" name="citizenIdentificationNumber" inputmode="numeric" pattern="[0-9]{12}" maxlength="12" placeholder="12 chữ số" required value="<%=h(pending==null?"":pending.getCitizenIdentificationNumber())%>">
                        </div>
                        <div class="field">
                            <label for="email">Email <span class="required">(*)</span>
                            </label>
                            <input id="email" name="email" type="email" maxlength="150" placeholder="abc@gmail.com" required value="<%=h(pending==null?"":pending.getEmail())%>">
                        </div>
                        <div class="field">
                            <label for="phoneNumber">Số điện thoại <span class="required">(*)</span>
                            </label>
                            <input id="phoneNumber" name="phoneNumber" inputmode="numeric" pattern="0[0-9]{9}" maxlength="10" placeholder="VD: 0123456789" required value="<%=h(pending==null?"":pending.getPhoneNumber())%>">
                        </div>
                        <div class="field field-full">
                            <label for="address">Địa chỉ <span class="required">(*)</span>
                            </label>
                            <input id="address" name="address" maxlength="255" placeholder="Số nhà, đường, xã, huyện, tỉnh" required value="<%=h(pending==null?"":pending.getAddress())%>">
                        </div>
                        <div class="field field-full">
                            <label for="cardDeliveryMethod">Nơi nhận thẻ</label>
                            <select id="cardDeliveryMethod" name="cardDeliveryMethod">
                                <option value="Nhận tại thư viện" <%=pending!=null&&"Nhận tại thư viện".equals(pending.getCardDeliveryMethod())?"selected":""%>>Nhận tại thư viện</option>
                                <option value="Nhận tại nhà" <%=pending!=null&&"Nhận tại nhà".equals(pending.getCardDeliveryMethod())?"selected":""%>>Nhận tại nhà (phí vận chuyển thu riêng)</option>
                            </select>
                        </div>
                    </div>
                    <div class="actions">
                        <button class="btn" id="btnReset" name="action" value="reset" type="submit" formnovalidate>Nhập lại</button>
                        <a class="btn" id="btnBack" href="UIReader5.jsp">Quay lại</a>
                        <button class="btn btn-primary" id="btnRegister" name="action" value="register" type="submit">Đăng ký</button>
                    </div>
                </form>
            </main>
        </body>
    </html>
