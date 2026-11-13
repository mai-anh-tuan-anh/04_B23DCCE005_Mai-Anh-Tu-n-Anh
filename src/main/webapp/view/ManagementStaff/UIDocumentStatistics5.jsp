<%@ include file="/WEB-INF/jspf/common.jspf" %>
<%
ManagementStaff5 manager=(ManagementStaff5)session.getAttribute("managementStaff5");
if (manager == null) {
    response.sendRedirect(request.getContextPath() + "/view/Member/UILogin.jsp");
    return;
}
request.setCharacterEncoding("UTF-8");
String base=request.getContextPath();
String notification=null;
DocumentStatistics5[] data=(DocumentStatistics5[])session.getAttribute("statsList5");
LocalDate begin=(LocalDate)session.getAttribute("statsBegin5");
LocalDate finish=(LocalDate)session.getAttribute("statsEnd5");
String searchValue=(String)session.getAttribute("statsKeyword5");
if(searchValue==null)searchValue="";
Set<Integer> selectedTypes=(Set<Integer>)session.getAttribute("statsTypes5");
if(selectedTypes==null)selectedTypes=new LinkedHashSet<>();
int currentPage=session.getAttribute("statsPage5") instanceof Integer?(Integer)session.getAttribute("statsPage5"):1;
String action=request.getParameter("action");
if("POST".equalsIgnoreCase(request.getMethod())) {
    if("view".equals(action)) {
        try {
            LocalDate newBegin=LocalDate.parse(request.getParameter("startDate"));
            LocalDate newEnd=LocalDate.parse(request.getParameter("endDate"));
            if(newBegin.isAfter(newEnd))throw new IllegalArgumentException("Ngày bắt đầu không được lớn hơn ngày kết thúc.");
            data=new DocumentStatisticsDAO5().getDocumentStatistics(newBegin,newEnd);
            begin=newBegin; finish=newEnd;
            searchValue="";selectedTypes=new LinkedHashSet<>();currentPage=1;
            session.setAttribute("statsBegin5",begin);
            session.setAttribute("statsEnd5",finish);
            session.setAttribute("statsList5",data);
            session.setAttribute("statsKeyword5",searchValue);
            session.setAttribute("statsTypes5",selectedTypes);
            session.setAttribute("statsPage5",currentPage);
            // Thay đổi khoảng ngày thống kê khiến danh sách lượt mượn trước đó hết hiệu lực.
            session.removeAttribute("loanList5");
            session.removeAttribute("loanSlips5");
            session.removeAttribute("loanMap5");
            session.removeAttribute("loanTitle5");
        } catch(Exception ex) {
            notification=ex instanceof java.time.format.DateTimeParseException?
                "Vui lòng nhập đầy đủ ngày bắt đầu và ngày kết thúc hợp lệ.":
                (ex instanceof IllegalArgumentException?ex.getMessage():"Không lấy được thống kê. Kiểm tra cơ sở dữ liệu.");
            if(!(ex instanceof IllegalArgumentException))application.log("Lỗi thống kê",ex);
        }
    } else if("search".equals(action) && data!=null) {
        searchValue=request.getParameter("searchKeyword")==null?"":request.getParameter("searchKeyword").trim();
        selectedTypes=new LinkedHashSet<>();
        String[] chosen=request.getParameterValues("documentTypes");
        if(chosen!=null)for(String type:chosen){int id=intValue(type,0);if(id>0)selectedTypes.add(id);}
        currentPage=1;
        session.setAttribute("statsKeyword5",searchValue);
        session.setAttribute("statsTypes5",selectedTypes);
        session.setAttribute("statsPage5",currentPage);
    }
} else if("page".equals(action)) {
    currentPage=Math.max(1,intValue(request.getParameter("page"),1));
    session.setAttribute("statsPage5",currentPage);
}
// Danh sách loại tài liệu lấy từ DocumentTitle5.titleTypes thuộc kết quả đã truy xuất.
Map<Integer,DocumentType5> typeMap=new TreeMap<>();
if(data!=null)for(DocumentStatistics5 d:data){
    if(d.getTitleTypes()!=null)for(TitleType5 tt:d.getTitleTypes()){
        if(tt.getDocumentType()!=null)typeMap.put(tt.getDocumentType().getId(),tt.getDocumentType());
    }
}
List<DocumentStatistics5> filtered=new ArrayList<>();
if(data!=null)for(DocumentStatistics5 d:data){
    String keyword=searchValue.toLowerCase(new Locale("vi","VN"));
    if(!keyword.isEmpty() && !d.getDocumentTitleCode().toLowerCase(new Locale("vi","VN")).contains(keyword) &&
       !d.getDocumentTitleName().toLowerCase(new Locale("vi","VN")).contains(keyword))continue;
    boolean all=true;
    for(int typeId:selectedTypes){
        boolean has=false;
        if(d.getTitleTypes()!=null)for(TitleType5 tt:d.getTitleTypes())
            if(tt.getDocumentType()!=null&&tt.getDocumentType().getId()==typeId){has=true;break;}
        if(!has){all=false;break;}
    }
    if(all)filtered.add(d);
}
filtered.sort(Comparator.comparingInt(DocumentStatistics5::getLoanAmount).reversed()
    .thenComparing(DocumentStatistics5::getDocumentTitleCode));
int totalLoanAmount=0;for(DocumentStatistics5 item:filtered)totalLoanAmount+=item.getLoanAmount();
int pages=Math.max(1,(filtered.size()+14)/15);
currentPage=Math.max(1,Math.min(currentPage,pages));
session.setAttribute("statsPage5",currentPage);
session.setAttribute("statsFiltered5",filtered);
int first=(currentPage-1)*15;
int until=Math.min(filtered.size(),first+15);
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width,initial-scale=1">
        <title>THỐNG KÊ TÀI LIỆU THEO ĐẦU TÀI LIỆU</title>
        <link rel="stylesheet" href="<%=base%>/assets/css/style.css">
    </head>
    <body>
        <main class="page">
            <h1 class="page-title">THỐNG KÊ TÀI LIỆU THEO ĐẦU TÀI LIỆU</h1>
            <%if(notification!=null){%>
            <div class="notification error">
                <%=h(notification)%>
            </div>
            <%}%>
            <form method="post" action="UIDocumentStatistics5.jsp" class="stats-date-row">
                <input type="hidden" name="action" value="view">
                <div class="field">
                    <label for="startDate">Ngày bắt đầu</label>
                    <input id="startDate" name="startDate" type="date" value="<%=dateInput(begin==null?LocalDate.of(2026,7,19):begin)%>" required>
                </div>
                <div class="field">
                    <label for="endDate">Ngày kết thúc</label>
                    <input id="endDate" name="endDate" type="date" value="<%=dateInput(finish==null?LocalDate.of(2026,7,25):finish)%>" required>
                </div>
                <button id="btnView" class="btn btn-primary" type="submit">Xem thống kê</button>
            </form>
            <%if(data!=null){%>
            <form method="post" action="UIDocumentStatistics5.jsp" class="stats-filter-form">
                <input type="hidden" name="action" value="search">
                <div class="field">
                    <label for="searchKeyword">Tìm theo mã hoặc tên đầu tài liệu</label>
                    <input id="searchKeyword" name="searchKeyword" placeholder="D123456789 / Lập trình JAVA" value="<%=h(searchValue)%>">
                </div>
                <div class="field">
                    <label>Lọc theo loại tài liệu (chọn nhiều)</label>
                    <details class="multi-select">
                        <summary>
                            <%=selectedTypes.isEmpty()?"Chọn loại tài liệu":(selectedTypes.size()+" loại đã chọn")%>
                        </summary>
                        <div class="multi-options">
                            <%for(DocumentType5 type:typeMap.values()){%>
                            <label>
                                <input type="checkbox" name="documentTypes" value="<%=type.getId()%>" <%=selectedTypes.contains(type.getId())?"checked":""%>> <%=h(type.getDocumentTypeName())%>
                            </label>
                            <%}%>
                        </div>
                    </details>
                </div>
                <button id="btnSearch" class="btn" type="submit">Tìm kiếm</button>
            </form>
            <p class="total">Tổng lượt mượn: <strong>
                <%=totalLoanAmount%>
            </strong>
        </p>
        <div class="section-heading">Danh sách đầu tài liệu</div>
        <div class="table-wrap">
            <table id="tblDocumentStatistics">
                <thead>
                    <tr>
                        <th>STT</th>
                        <th>Mã đầu</th>
                        <th>Tên đầu tài liệu</th>
                        <th>Loại tài liệu</th>
                        <th>Mô tả</th>
                        <th>Lượt mượn</th>
                    </tr>
                </thead>
                <tbody>
                    <%for(int i=first;i<until;i++){DocumentStatistics5 d=filtered.get(i);%>
                    <tr>
                        <td>
                            <%=i+1%>
                        </td>
                        <td>
                            <a href="UIDocumentCopyLoanList5.jsp?titleId=<%=d.getId()%>">
                                <%=h(d.getDocumentTitleCode())%>
                            </a>
                        </td>
                        <td>
                            <%=h(d.getDocumentTitleName())%>
                        </td>
                        <td>
                            <%=h(fmtTypes(d))%>
                        </td>
                        <td>
                            <%=h(d.getDescription())%>
                        </td>
                        <td class="numeric">
                            <%=d.getLoanAmount()%>
                        </td>
                    </tr>
                    <%}%>
                    <%if(filtered.isEmpty()){%>
                    <tr>
                        <td colspan="6" class="empty-table">Không có đầu tài liệu phù hợp với điều kiện tìm kiếm và lọc.</td>
                    </tr>
                    <%}%>
                </tbody>
            </table>
        </div>
        <div class="pagination">Trang <%=currentPage%>/<%=pages%> &nbsp;
            <%if(currentPage>1){%>
            <a href="UIDocumentStatistics5.jsp?action=page&amp;page=<%=currentPage-1%>">&lt; Trước</a>
            <%}else{%>
            <span>&lt; Trước</span>
            <%}%>
            <span class="page-index">
                <%=currentPage%>
            </span>
            <%if(currentPage<pages){%>
            <a href="UIDocumentStatistics5.jsp?action=page&amp;page=<%=currentPage+1%>">Sau &gt;</a>
            <%}else{%>
            <span>Sau &gt;</span>
            <%}%>
            <span>(Tối đa 15 đầu tài liệu/trang)</span>
        </div>
        <%}%>
        <div class="actions">
            <a id="btnBack" class="btn" href="UIStatisticsType5.jsp">Quay lại</a>
        </div>
    </main>
</body>
</html>
