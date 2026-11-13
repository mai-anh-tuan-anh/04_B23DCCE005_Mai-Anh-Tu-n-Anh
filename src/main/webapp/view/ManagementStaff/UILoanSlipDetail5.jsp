<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
ManagementStaff5 manager=(ManagementStaff5)session.getAttribute("managementStaff5");
if (manager == null) {
    response.sendRedirect(request.getContextPath() + "/view/Member/UILogin.jsp");
    return;
}
String base=request.getContextPath();
Loan5[] list=(Loan5[])session.getAttribute("loanList5");
if(list==null){response.sendRedirect("UIDocumentStatistics5.jsp");return;}
int loanId=intValue(request.getParameter("loanId"),0);
Loan5 selected=null;
for(Loan5 loan:list)if(loan.getId()==loanId){selected=loan;break;}
if(selected==null){response.sendRedirect("UIDocumentCopyLoanList5.jsp");return;}
LoanSlip5 slip=null;
String error=null;
try {slip=new LoanSlipDAO5().getLoanSlipByLoan(selected);}
catch(Exception ex){application.log("Lỗi truy xuất chi tiết phiếu mượn",ex);error="Không tải được chi tiết phiếu mượn.";}
if(slip==null&&error==null)error="Không tìm thấy phiếu mượn tương ứng.";
List<Loan5> details=new ArrayList<>();
if(slip!=null&&slip.getLoans()!=null)details.addAll(Arrays.asList(slip.getLoans()));
details.sort(Comparator.comparing((Loan5 l)->l.getDocumentCopy().getDocumentCopyCode()).thenComparingInt(Loan5::getId));
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>CHI TIẾT PHIẾU MƯỢN</title>
        <link rel="stylesheet" href="<%=base%>/assets/css/style.css">
    </head>
    <body>
        <main class="page">
            <h1 class="page-title">CHI TIẾT PHIẾU MƯỢN</h1>
            <%if(error!=null){%>
            <div class="notification error">
                <%=h(error)%>
            </div>
            <%}%>
            <%if(slip!=null){%>
            <div class="detail-grid">
                <div class="display-field">
                    <span>Mã phiếu mượn</span>
                    <strong>
                        <%=h(slip.getLoanSlipCode())%>
                    </strong>
                </div>
                <div class="display-field">
                    <span>Mã độc giả / Họ tên</span>
                    <strong>
                        <%=h(slip.getReader().getReaderCode())%> – <%=h(slip.getReader().getFullName())%>
                    </strong>
                </div>
                <div class="display-field">
                    <span>Mã NV thư viện / Họ tên</span>
                    <strong>
                        <%=h(slip.getLibraryStaff().getStaffCode())%> – <%=h(slip.getLibraryStaff().getFullName())%>
                    </strong>
                </div>
                <div class="display-field">
                    <span>Trạng thái phiếu mượn</span>
                    <strong>
                        <%=h(slip.getLoanSlipStatus())%>
                    </strong>
                </div>
            </div>
            <div class="section-heading">Danh sách quyển tài liệu thuộc phiếu mượn</div>
            <div class="table-wrap">
                <table id="tblLoanDetails">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Mã quyển</th>
                            <th>Tên đầu tài liệu</th>
                            <th>Ngày mượn</th>
                            <th>Hạn trả</th>
                            <th>Ngày trả</th>
                            <th>Phí phạt (VNĐ)</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%for(int i=0;i<details.size();i++){Loan5 loan=details.get(i);%>
                        <tr>
                            <td>
                                <%=i+1%>
                            </td>
                            <td>
                                <%=h(loan.getDocumentCopy().getDocumentCopyCode())%>
                            </td>
                            <td>
                                <%=h(loan.getDocumentCopy().getDocumentTitle().getDocumentTitleName())%>
                            </td>
                            <td>
                                <%=fmtDate(slip.getLoanDate())%>
                            </td>
                            <td>
                                <%=fmtDate(slip.getDueDate())%>
                            </td>
                            <td>
                                <%=fmtDate(loan.getReturnDate())%>
                            </td>
                            <td class="numeric">
                                <%=loan.getReturnDate()==null?"—":(loan.getFine()==null?"0":String.format(new Locale("vi","VN"),"%,.0f",loan.getFine()))%>
                            </td>
                        </tr>
                        <%}%>
                    </tbody>
                </table>
            </div>
            <%}%>
            <div class="actions">
                <a id="btnBack" class="btn" href="UIDocumentCopyLoanList5.jsp">Quay lại</a>
                <a id="btnHome" class="btn btn-primary" href="UIManagementStaff5.jsp">Về giao diện chính</a>
            </div>
        </main>
    </body>
</html>
