<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
ManagementStaff5 manager=(ManagementStaff5)session.getAttribute("managementStaff5");
if (manager == null) {
    response.sendRedirect(request.getContextPath() + "/view/Member/UILogin.jsp");
    return;
}
request.setCharacterEncoding("UTF-8");
String base=request.getContextPath();
DocumentStatistics5[] stats=(DocumentStatistics5[])session.getAttribute("statsList5");
LocalDate begin=(LocalDate)session.getAttribute("statsBegin5");
LocalDate end=(LocalDate)session.getAttribute("statsEnd5");
if(stats==null||begin==null||end==null){response.sendRedirect("UIDocumentStatistics5.jsp");return;}
DocumentStatistics5 title=(DocumentStatistics5)session.getAttribute("loanTitle5");
String notice=null;
int openTitleId=intValue(request.getParameter("titleId"),0);
if(openTitleId>0&&(title==null||title.getId()!=openTitleId||session.getAttribute("loanList5")==null)){
    title=null;
    for(DocumentStatistics5 d:stats)if(d.getId()==openTitleId){title=d;break;}
    if(title==null){response.sendRedirect("UIDocumentStatistics5.jsp");return;}
    try {
        Loan5[] loans=new LoanDAO5().getLoansByDocumentTitle(title,begin,end);
        LoanSlip5[] slips=new LoanSlipDAO5().getLoanSlipsByLoans(loans);
        Map<Integer,LoanSlip5> slipByLoan=new HashMap<>();
        for(LoanSlip5 slip:slips)if(slip.getLoans()!=null)
            for(Loan5 row:slip.getLoans())slipByLoan.put(row.getId(),slip);
        session.setAttribute("loanTitle5",title);
        session.setAttribute("loanList5",loans);
        session.setAttribute("loanSlips5",slips);
        session.setAttribute("loanMap5",slipByLoan);
        session.setAttribute("loanKeyword5","");
        session.setAttribute("loanPage5",1);
    } catch(Exception ex) {
        application.log("Lỗi truy xuất danh sách lượt mượn",ex);
        notice="Không lấy được danh sách lượt mượn. Kiểm tra CSDL.";
    }
}
if(title==null){response.sendRedirect("UIDocumentStatistics5.jsp");return;}
Loan5[] loans=(Loan5[])session.getAttribute("loanList5");
Map<Integer,LoanSlip5> slipByLoan=(Map<Integer,LoanSlip5>)session.getAttribute("loanMap5");
if(loans==null||slipByLoan==null){response.sendRedirect("UIDocumentStatistics5.jsp");return;}
String keyword=(String)session.getAttribute("loanKeyword5");if(keyword==null)keyword="";
int pageNum=session.getAttribute("loanPage5") instanceof Integer?(Integer)session.getAttribute("loanPage5"):1;
String action=request.getParameter("action");
if("POST".equalsIgnoreCase(request.getMethod())&&"search".equals(action)){
    keyword=request.getParameter("searchKeyword")==null?"":request.getParameter("searchKeyword").trim();
    pageNum=1;
    session.setAttribute("loanKeyword5",keyword);
    session.setAttribute("loanPage5",pageNum);
}else if("page".equals(action)){
    pageNum=Math.max(1,intValue(request.getParameter("page"),1));
}
List<Loan5> filtered=new ArrayList<>();
String needle=keyword.toLowerCase(new Locale("vi","VN"));
for(Loan5 loan:loans){
    LoanSlip5 slip=slipByLoan.get(loan.getId());
    if(slip==null)continue;
    String copyCode=loan.getDocumentCopy().getDocumentCopyCode();
    String readerName=slip.getReader().getFullName();
    if(needle.isEmpty()||copyCode.toLowerCase().contains(needle)||
       (readerName!=null&&readerName.toLowerCase(new Locale("vi","VN")).contains(needle)))filtered.add(loan);
}
filtered.sort(Comparator.comparing((Loan5 l)->slipByLoan.get(l.getId()).getLoanDate())
    .thenComparing(l->l.getDocumentCopy().getDocumentCopyCode()).thenComparingInt(Loan5::getId));
int pages=Math.max(1,(filtered.size()+14)/15);
pageNum=Math.max(1,Math.min(pages,pageNum));
session.setAttribute("loanPage5",pageNum);
session.setAttribute("loanFiltered5",filtered);
int first=(pageNum-1)*15;
int until=Math.min(filtered.size(),first+15);
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>DANH SÁCH LƯỢT MƯỢN CỦA ĐẦU TÀI LIỆU</title>
        <link rel="stylesheet" href="<%=base%>/assets/css/style.css">
    </head>
    <body>
        <main class="page">
            <h1 class="page-title">DANH SÁCH LƯỢT MƯỢN CỦA ĐẦU TÀI LIỆU</h1>
            <%if(notice!=null){%>
            <div class="notification error">
                <%=h(notice)%>
            </div>
            <%}%>
            <div class="meta-grid">
                <div>
                    <strong>Mã đầu tài liệu:</strong> <%=h(title.getDocumentTitleCode())%>
                </div>
                <div>
                    <strong>Tên đầu tài liệu:</strong> <%=h(title.getDocumentTitleName())%>
                </div>
                <div>
                    <strong>Loại tài liệu:</strong> <%=h(fmtTypes(title))%>
                </div>
                <div>
                    <strong>Vị trí kệ:</strong> <%=h(title.getShelfLocation())%>
                </div>
            </div>
            <p class="total">Tổng lượt mượn trong khoảng thời gian: <strong>
                <%=title.getLoanAmount()%>
            </strong> &nbsp; (<%=fmtDate(begin)%> – <%=fmtDate(end)%>)</p>
            <form method="post" action="UIDocumentCopyLoanList5.jsp" class="search-row">
                <input type="hidden" name="action" value="search">
                <label for="searchKeyword">Tìm mã quyển hoặc tên độc giả</label>
                <input id="searchKeyword" name="searchKeyword" placeholder="B123456789 / Nguyễn Văn A" value="<%=h(keyword)%>">
                <button type="submit" id="btnSearch" class="btn">Tìm kiếm</button>
            </form>
            <div class="section-heading">Danh sách lượt mượn</div>
            <div class="table-wrap">
                <table id="tblLoans">
                    <thead>
                        <tr>
                            <th>STT</th>
                            <th>Mã quyển</th>
                            <th>Ngày mượn</th>
                            <th>Hạn trả</th>
                            <th>Ngày trả</th>
                            <th>Tên độc giả - Mã độc giả</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%for(int i=first;i<until;i++){Loan5 loan=filtered.get(i);LoanSlip5 slip=slipByLoan.get(loan.getId());%>
                        <tr>
                            <td>
                                <%=i+1%>
                            </td>
                            <td>
                                <a href="UILoanSlipDetail5.jsp?loanId=<%=loan.getId()%>">
                                    <%=h(loan.getDocumentCopy().getDocumentCopyCode())%>
                                </a>
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
                            <td>
                                <%=h(slip.getReader().getFullName())%> - <%=h(slip.getReader().getReaderCode())%>
                            </td>
                        </tr>
                        <%}%>
                        <%if(filtered.isEmpty()){%>
                        <tr>
                            <td colspan="6" class="empty-table">Không tìm thấy lượt mượn phù hợp.</td>
                        </tr>
                        <%}%>
                    </tbody>
                </table>
            </div>
            <div class="pagination">Trang <%=pageNum%>/<%=pages%> &nbsp;
                <%if(pageNum>1){%>
                <a href="UIDocumentCopyLoanList5.jsp?action=page&amp;page=<%=pageNum-1%>">&lt; Trước</a>
                <%}else{%>
                <span>&lt; Trước</span>
                <%}%>
                <span class="page-index">
                    <%=pageNum%>
                </span>
                <%if(pageNum<pages){%>
                <a href="UIDocumentCopyLoanList5.jsp?action=page&amp;page=<%=pageNum+1%>">Sau &gt;</a>
                <%}else{%>
                <span>Sau &gt;</span>
                <%}%>
                <span>(Tối đa 15 lượt mượn/trang)</span>
            </div>
            <div class="actions">
                <a id="btnBack" class="btn" href="UIDocumentStatistics5.jsp">Quay lại</a>
                <a id="btnHome" class="btn btn-primary" href="UIManagementStaff5.jsp">Về giao diện chính</a>
            </div>
        </main>
    </body>
</html>
