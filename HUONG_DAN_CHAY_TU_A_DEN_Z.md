# LIBMAN 5 — HƯỚNG DẪN CHẠY TỪ A ĐẾN Z

**Bản nguồn:** `04B23DCCE005(20261113-053957).docx` và sơ đồ 20 bảng `Database(1).png`.

## 0. Đọc trước 1 phút — project này có gì?

Đây là web demo Java/JSP **không dùng JavaScript**, triển khai đúng **2 module**:

1. **Register Reader Card 5**: đăng nhập Reader → đăng ký thẻ → QR mô phỏng **3 giây** → lưu **thẻ và hóa đơn trong cùng transaction** → xem hóa đơn.
2. **View Documents' Statistics 5**: đăng nhập Management Staff → thống kê theo khoảng ngày → tìm mã/tên → lọc **AND** theo nhiều loại tài liệu → phân trang 15 dòng → danh sách lượt mượn → chi tiết phiếu mượn.

Đăng nhập chỉ dùng **username/password dạng thông thường** như yêu cầu demo. Đăng xuất hủy `HttpSession`. Các mục menu không thuộc hai module vẫn hiển thị như V0 nhưng không triển khai nghiệp vụ tương ứng.

**Các giới hạn đã chốt:** đúng 20 bảng; đúng 9 phương thức DAO nghiệp vụ; đúng 4 JSP Reader + 5 JSP Management Staff; không thêm bảng/cột/lớp DAO nghiệp vụ; khi Back giữ dữ liệu; không triển khai thanh toán thật hoặc các menu ngoài phạm vi.

## 1. Danh sách công cụ cần cài trên Windows

| Công cụ | Phiên bản | Dùng làm gì |
|---|---|---|
| Visual Studio Code | Bản có hỗ trợ Java | Mở và chỉnh code |
| Java JDK | **17** (có thể dùng 17.0.x) | Biên dịch/chạy Java |
| Apache Maven | **3.9.x** | Build dự án `.war` |
| Apache Tomcat | **9.0.123** (hoặc 9.0.x) | Chạy ứng dụng JSP tại port 8080 |
| XAMPP for Windows | Bản có MariaDB/MySQL | Chạy database ở port 3306 |
| Browser | Edge/Chrome | Xem và thao tác web |
| Git | Tùy chọn | Push source lên GitHub sau khi kiểm thử |

**Chú ý:** XAMPP `Apache` và **Apache Tomcat là hai chương trình khác nhau**. Tomcat chạy web Java; MySQL trong XAMPP chạy CSDL. XAMPP Apache chỉ cần khi muốn mở phpMyAdmin trên `http://localhost/phpmyadmin`.

Các extension VS Code: **Extension Pack for Java** và **Maven for Java**. Không cần cài Spring, Angular, React, Node.js hay JavaScript.

## 2. Giải nén ZIP và mở project

1. Giải nén `LibMan5_Source.zip` vào ổ tùy thích, ví dụ `D:\Projects\`.
2. Sau khi giải nén phải thấy `D:\Projects\LibMan5\pom.xml`.
3. Mở VS Code → **File → Open Folder** → chọn thư mục `LibMan5` (thư mục **chứa** `pom.xml`).
4. Kiểm tra các thư mục `src/main/java/model`, `src/main/java/dao`, `src/main/webapp/view/Reader`, `src/main/webapp/view/ManagementStaff`, `database`.
5. Chờ VS Code tải thông tin dự án Maven. Lần đầu cần internet để Maven lấy phụ thuộc.

## 3. Cài JDK 17

1. Tải **JDK 17** từ nhà cung cấp Java bạn chọn (ví dụ Eclipse Temurin 17).
2. Cài vào Windows, ví dụ `C:\Program Files\Eclipse Adoptium\jdk-17...`.
3. Trong Windows **Edit the system environment variables → Environment Variables**, đặt `JAVA_HOME` bằng thư mục JDK đã cài, **không trỏ vào `bin`**.
4. Thêm `%JAVA_HOME%\bin` vào biến `Path` nếu chưa có.
5. **Mở PowerShell mới** và kiểm tra:

```powershell
java -version
javac -version
```

Cả hai cần báo Java **17**. Nếu khác, điều chỉnh `JAVA_HOME`/`Path` rồi mở terminal mới.

## 4. Cài Maven

1. Tải Apache Maven 3.9.x (binary ZIP) và giải nén, ví dụ `C:\Tools\apache-maven-3.9.x`.
2. Thêm `C:\Tools\apache-maven-3.9.x\bin` vào biến `Path`.
3. Mở PowerShell mới:

```powershell
mvn -version
```

Nếu hiện `mvn is not recognized`, đó là vấn đề `Path`: kiểm tra thư mục Maven có `bin\mvn.cmd` hay chưa. Không chạy lệnh Maven khi chưa cài và cấu hình xong.

## 5. Cài XAMPP và chạy database

1. Cài XAMPP trên Windows, ví dụ thư mục `C:\xampp`.
2. Mở **XAMPP Control Panel**.
3. Nhấn **Start** tại **MySQL**. Màu xanh/running cho biết đã chạy.
4. Nhấn **Start** tại **Apache** nếu muốn dùng **phpMyAdmin**.
5. Mở trình duyệt: `http://localhost/phpmyadmin`.
6. Nếu XAMPP Apache lỗi port 80: Tomcat **không bị ảnh hưởng**; có thể dùng MariaDB/MySQL tiếp và thay phương thức import bằng dòng lệnh, hoặc sửa cổng Apache cho phpMyAdmin.
7. Nếu MySQL lỗi port 3306: có thể một MySQL/MariaDB khác đang chiếm cổng. Tắt dịch vụ xung đột hoặc đổi cổng trong XAMPP và đặt URL JDBC tương ứng (xem mục 10).

**Lưu ý:** XAMPP thường dùng MariaDB nhưng Control Panel gọi là MySQL. Project dùng MariaDB Connector/J, tương thích với dữ liệu này.

## 6. Tạo đúng 20 bảng bằng schema.sql

Đường dẫn file: `LibMan5/database/schema.sql`.

**Cảnh báo:** `schema.sql` có các lệnh `DROP TABLE IF EXISTS` để khởi tạo lại từ đầu, nên chỉ dùng với **database demo**, không chạy trên dữ liệu cần giữ.

Cách nhập trong phpMyAdmin:

1. Đang ở trang `http://localhost/phpmyadmin`.
2. Bấm **Import / Nhập** (nếu đang ở trang chủ phpMyAdmin, tức cấp server).
3. Chọn `database/schema.sql`.
4. Giữ Format là **SQL**, nhấn **Import / Thực hiện**.
5. Chờ thông báo thành công. Script tự tạo database `libman5` bằng `CREATE DATABASE IF NOT EXISTS ...` và `USE libman5`.
6. Ở thanh bên trái phải có `libman5`. Chọn nó, kiểm tra **đúng 20 bảng**.

Các bảng là: `tblMember5`, `tblStaff5`, `tblManagementStaff5`, `tblLibraryStaff5`, `tblReader5`, `tblSupplier5`, `tblDocumentTitle5`, `tblDocumentCopy5`, `tblDocumentType5`, `tblTitleType5`, `tblReaderCard5`, `tblReaderCardType5`, `tblReaderType5`, `tblReaderCardRegistrationInvoice5`, `tblLoanSlip5`, `tblReturnSlip5`, `tblLoan5`, `tblFineRate5`, `tblLoanFine5`, `tblImportBatch5`.

**Không có bảng** `tblDocumentStatistics5`, `tblReaderStatistics5`, `tblImportedDocumentStatistics5` vì Bước 5 thiết kế CSDL của báo cáo đã loại các bảng thống kê dẫn xuất.

## 7. Nhập dữ liệu giả lập phong phú bằng seed.sql

1. Sau khi nhập schema thành công, bấm database **`libman5`** bên trái.
2. Chọn **Import**.
3. Chọn `LibMan5/database/seed.sql`.
4. Chạy Import.
5. Chỉ nhập seed **1 lần** trên database trống. Nếu nhập lại sẽ lỗi trùng khóa chính; muốn làm lại thì nhập **schema.sql trước, seed.sql sau**.
6. Để kiểm tra dữ liệu, chọn tab **SQL** rồi chạy lần lượt các câu trong `LibMan5/database/verify.sql`.

Dữ liệu đã bao gồm **hàng nghìn lượt mượn**, nhiều đầu tài liệu có nhiều loại, mượn nhiều lần cùng một quyển ở các thời điểm khác nhau, phiếu trả, tiền phạt, hóa đơn và các loại thẻ. Đặc biệt có số liệu trong tuần **19/07/2026 – 25/07/2026** đúng khoảng ngày minh họa ở V0.

Tài khoản đều là **dữ liệu demo**, không phải tài khoản thật. Phí 60.000 VNĐ của thẻ thường lấy theo hình V0; phí của hai loại thẻ còn lại trong seed là **giá trị demo có thể thay đổi** qua SQL theo yêu cầu của báo cáo.

## 8. Kiểm tra cấu hình JDBC

Mặc định project kết nối:

```text
JDBC URL: jdbc:mariadb://localhost:3306/libman5
Database username: root
Database password: (trống)
```

Đó là cấu hình XAMPP demo thường gặp; nó **không** tự động tương ứng mọi máy.

Nếu XAMPP của bạn sử dụng cấu hình mặc định thì **không cần chỉnh code**. Nếu có mật khẩu hoặc cổng khác, đặt biến môi trường trong **cùng terminal sẽ chạy Tomcat**:

```powershell
$env:LIBMAN_DB_URL="jdbc:mariadb://localhost:3306/libman5"
$env:LIBMAN_DB_USER="root"
$env:LIBMAN_DB_PASSWORD="MAT_KHAU_CUA_BAN"
```

Các biến môi trường được `dao.DatabaseContext` đọc khi mở JDBC connection. Mật khẩu không phải là thông tin lưu trong mã nguồn. **Không thêm DAO mới** để xử lý cấu hình.

## 9. Build file LibMan5.war bằng Maven

Trong terminal PowerShell ở VS Code:

```powershell
cd D:\Projects\LibMan5
mvn clean package
```

Thay đường dẫn bằng nơi bạn đã giải nén.

Khi build thành công sẽ có:

```text
LibMan5/target/LibMan5.war
BUILD SUCCESS
```

Maven tải tự động:

- **MariaDB Connector/J 3.5.6**, tự đóng gói vào `WEB-INF/lib` trong WAR.
- **Servlet API 4.0.1**, chỉ dùng để biên dịch (`scope=provided`); **Tomcat 9** cung cấp lúc chạy.

**Không cần tải/copy JDBC JAR thủ công** và không chép `servlet-api.jar`, `jsp-api.jar` từ ngoài vào ứng dụng. Những thư viện JSP/Servlet/EL/Jasper nằm sẵn trong Tomcat 9.

> Lưu ý: Nếu Maven chưa từng được dùng trên máy, lần build đầu cần kết nối internet để tải các plugin/phụ thuộc.

## 10. Cài Tomcat 9 và deploy WAR

1. Tải **Apache Tomcat 9.0.123** bản **Core ZIP** cho Windows.
2. Giải nén, ví dụ `C:\Tools\apache-tomcat-9.0.123`.
3. Mở terminal mới và xác nhận `JAVA_HOME` đang là JDK 17.
4. Nếu chưa chạy Tomcat, copy WAR:

```powershell
Copy-Item "D:\Projects\LibMan5\target\LibMan5.war" "C:\Tools\apache-tomcat-9.0.123\webapps\LibMan5.war" -Force
```

5. **Chạy Tomcat**:

```powershell
& "C:\Tools\apache-tomcat-9.0.123\bin\startup.bat"
```

6. Tomcat sẽ tự giải nén WAR thành `webapps\LibMan5` và deploy context `/LibMan5`.
7. Kiểm tra `http://localhost:8080/` trước, sau đó truy cập **`http://localhost:8080/LibMan5/`**.
8. Lần đầu mở JSP, Tomcat sẽ biên dịch JSP; chờ trang trả về, nếu có HTTP 500 xem mục 16.

Để **thay đổi source** và chạy bản mới, chạy lại:

```powershell
mvn clean package
& "C:\Tools\apache-tomcat-9.0.123\bin\shutdown.bat"
Remove-Item "C:\Tools\apache-tomcat-9.0.123\webapps\LibMan5" -Recurse -Force -ErrorAction SilentlyContinue
Copy-Item ".\target\LibMan5.war" "C:\Tools\apache-tomcat-9.0.123\webapps\LibMan5.war" -Force
& "C:\Tools\apache-tomcat-9.0.123\bin\startup.bat"
```

Chỉ thực hiện các câu trên khi terminal đang ở thư mục có `pom.xml`. Nếu Windows có quy định khóa file, tắt Tomcat rồi đợi nó kết thúc hẳn trước khi xóa thư mục đã giải nén.

### Cấu hình environment variables nếu Tomcat không kết nối được database

Để đảm bảo Tomcat nhận các biến `LIBMAN_DB_*`, thay cách mở bằng `startup.bat` bằng chạy **trong chính PowerShell đã đặt biến**:

```powershell
$env:LIBMAN_DB_URL="jdbc:mariadb://localhost:3306/libman5"
$env:LIBMAN_DB_USER="root"
$env:LIBMAN_DB_PASSWORD=""
& "C:\Tools\apache-tomcat-9.0.123\bin\catalina.bat" run
```

Cửa sổ terminal sẽ hiển thị log trực tiếp. Dừng bằng **Ctrl+C**; khi Tomcat dừng, tiến trình ứng dụng cũng dừng. Không chạy hai Tomcat trên cùng port 8080.

## 11. Test ĐĂNG NHẬP và ĐĂNG XUẤT

Mở `http://localhost:8080/LibMan5/`. Trang mặc định chuyển đến:

`/LibMan5/view/Member/gddangnhap.jsp`

Nhập tài khoản:

| Tài khoản | Mật khẩu | Vai trò | Kết quả |
|---|---|---|---|
| `reader01` | `123456` | Reader, **chưa có thẻ** | Có thể đăng ký thẻ mới |
| `reader02` | `123456` | Reader, **đã có thẻ** | Kiểm tra trùng thẻ |
| `manager` | `123456` | Management Staff | Xem thống kê |
| `librarian` | `123456` | Library Staff | Chỉ là dữ liệu hỗ trợ, không có module UI trong phạm vi này |

Đăng nhập sai phải thông báo lỗi ngay trên trang đăng nhập. Đăng xuất phải hủy session. Sau đăng xuất, gõ trực tiếp URL Reader/Management phải bị chuyển lại trang đăng nhập.

## 12. Test module ĐĂNG KÝ THẺ

1. Đăng nhập bằng `reader01 / 123456`.
2. Giao diện chính đúng tiêu đề `GIAO DIỆN CHÍNH CỦA ĐỘC GIẢ`.
3. Nhấn **Đăng ký thẻ độc giả**.
4. Giao diện `UIReaderCardRegistration5.jsp` hiển thị loại thẻ, loại bạn đọc, họ tên, giới tính, ngày sinh, CCCD, email, SĐT, địa chỉ, nơi nhận thẻ.
5. Nhập thông tin mới. Ví dụ **CCCD 12 chữ số chưa tồn tại:** `079123456789` (dữ liệu demo, không dùng CCCD thật). Ngày sinh phải trước ngày hiện tại, email và số điện thoại đúng định dạng.
6. Nhấn **Đăng ký**. Nếu đủ điều kiện, hệ thống chuyển đến `UIReaderCardPayment5.jsp`.
7. Trang QR **tự chuyển sau 3 giây** đến bước xác nhận mô phỏng. Không cần JavaScript. Không cần chuyển khoản thực tế.
8. Chỉ khi thanh toán mô phỏng thành công, `createReaderCard()` và `createReaderCardRegistrationInvoice()` cùng chạy trong **một transaction**. Nếu có lỗi, rollback cả hai.
9. Giao diện `UIReaderCardInvoice5.jsp` hiển thị mã hóa đơn, ngày lập, mã thẻ, loại thẻ, thông tin người đăng ký, số tiền.
10. Nhấn **Về giao diện chính**. Thử vào lại Đăng ký → hệ thống phát hiện Reader đã có thẻ và không cho đăng ký thêm.
11. Đăng xuất, đăng nhập `reader02 / 123456`, thử đăng ký: phải báo **đã có thẻ**.
12. Thử trùng CCCD với một thẻ khác khi dùng Reader chưa có thẻ (ví dụ `reader131` nếu seed chưa cấp thẻ): phải báo **CCCD đã được sử dụng**, không chuyển sang thanh toán.
13. Thử nút **Quay lại** từ trang thanh toán trước khi đủ 3 giây; dữ liệu đã nhập phải giữ nguyên. Thử **Nhập lại** để xóa giá trị.

**Cách kiểm tra bằng SQL:**

```sql
USE libman5;
SELECT id, readerCardCode, citizenIdentificationNumber, tblReader5id
FROM tblReaderCard5 WHERE tblReader5id = 3;

SELECT inv.invoiceCode, inv.invoiceDate, inv.paidAmount, c.readerCardCode
FROM tblReaderCardRegistrationInvoice5 inv
JOIN tblReaderCard5 c ON inv.tblReaderCard5id = c.id
WHERE c.tblReader5id = 3;
```

Một lần đăng ký thành công chỉ có một dòng ở mỗi truy vấn.

## 13. Test module THỐNG KÊ TÀI LIỆU

1. Đăng xuất Reader. Đăng nhập bằng `manager / 123456`.
2. Tại `UIManagementStaff5.jsp`, chọn **Xem thống kê**.
3. Tại `UIStatisticsType5.jsp`, chọn **Thống kê theo đầu tài liệu**.
4. Tại `UIDocumentStatistics5.jsp`, chọn ngày bắt đầu `19/07/2026`, ngày kết thúc `25/07/2026`, nhấn **Xem thống kê**.
5. Hệ thống hiển thị danh sách đầu tài liệu, các loại, lượt mượn. Mặc định sắp theo **lượt mượn giảm dần, mã đầu tăng dần**.
6. Nhập từ khóa theo **mã hoặc tên đầu tài liệu**, nhấn **Tìm kiếm**. Hệ thống lọc toàn bộ danh sách rồi **phân trang tối đa 15 dòng**.
7. Mở **Lọc theo loại tài liệu (chọn nhiều)**, đánh dấu **Giáo trình** và **Công nghệ phần mềm**, nhấn **Tìm kiếm**. Chỉ đầu tài liệu có **cả hai loại (AND)** mới được giữ lại.
8. Thay đổi tìm kiếm/bộ lọc → quay về trang 1. Tổng lượt mượn tính trên **toàn bộ kết quả phù hợp**, không chỉ trang hiện tại.
9. Bấm **mã đầu tài liệu** để sang `UIDocumentCopyLoanList5.jsp`. Trang này hiển thị thông tin đầu tài liệu, tất cả lượt mượn trong khoảng ngày; tìm kiếm theo **mã quyển hoặc tên độc giả**, sắp **ngày mượn tăng dần, mã quyển tăng dần**, phân trang 15 dòng.
10. Bấm **mã quyển của một lượt mượn** để đến `UILoanSlipDetail5.jsp`. Hệ thống truyền đúng `Loan5.id`, không nhầm giữa các lần mượn của cùng mã quyển.
11. Trang chi tiết phải hiện cả **những quyển khác** thuộc cùng phiếu mượn (nếu có), không chỉ quyển/đầu tài liệu đang thống kê.
12. Nhấn **Quay lại** ở chi tiết → danh sách lượt mượn, trang hiện tại và từ khóa còn nguyên; Quay lại lần nữa → thống kê giữ nguyên khoảng ngày và bộ lọc AND.
13. Thử nhập ngày bắt đầu lớn hơn ngày kết thúc → thông báo lỗi và không truy vấn sai.

Không có DAO lấy loại tài liệu riêng: danh sách loại lấy từ `DocumentStatistics5` → `DocumentTitle5.titleTypes[]` → `TitleType5.documentType`. `LoanSlipDAO5.getLoanSlipsByLoans()` lấy phiếu theo danh sách `Loan5[]` để bảng lượt mượn có ngày mượn, hạn trả và tên độc giả.

## 14. Đúng các tên JSP và URL đã chốt

Với context `/LibMan5`:

```text
/LibMan5/view/Member/gddangnhap.jsp
/LibMan5/view/Member/doDangnhap.jsp
/LibMan5/view/Member/doDangxuat.jsp

/LibMan5/view/Reader/UIReader5.jsp
/LibMan5/view/Reader/UIReaderCardRegistration5.jsp
/LibMan5/view/Reader/UIReaderCardPayment5.jsp
/LibMan5/view/Reader/UIReaderCardInvoice5.jsp

/LibMan5/view/ManagementStaff/UIManagementStaff5.jsp
/LibMan5/view/ManagementStaff/UIStatisticsType5.jsp
/LibMan5/view/ManagementStaff/UIDocumentStatistics5.jsp
/LibMan5/view/ManagementStaff/UIDocumentCopyLoanList5.jsp
/LibMan5/view/ManagementStaff/UILoanSlipDetail5.jsp
```

Tên tab trình duyệt `<title>` khớp tiêu đề giao diện tương ứng trong hình V0. CSS chỉ thay cách dùng khoảng trắng, chia cột khi màn hình rộng để hạn chế cuộn; **không xóa trường, nhãn hoặc nút có trong V0**.

## 15. Cấu trúc source code dùng để chụp ảnh Project Explorer

```text
LibMan5/
├── pom.xml
├── database/
│   ├── schema.sql
│   ├── seed.sql
│   └── verify.sql
├── src/main/java/
│   ├── model/                 (23 lớp thực thể, gồm 3 lớp thống kê dẫn xuất)
│   └── dao/
│       ├── DAO.java
│       ├── DatabaseContext.java  (hạ tầng JDBC/transaction; KHÔNG phải DAO nghiệp vụ)
│       ├── ReaderCardTypeDAO5.java
│       ├── ReaderTypeDAO5.java
│       ├── ReaderCardDAO5.java
│       ├── ReaderCardRegistrationInvoiceDAO5.java
│       ├── DocumentStatisticsDAO5.java
│       ├── LoanDAO5.java
│       └── LoanSlipDAO5.java
├── src/main/webapp/
│   ├── index.jsp
│   ├── assets/css/style.css
│   ├── assets/images/payment-qr.png
│   ├── view/Member/        (3 trang đăng nhập/đăng xuất)
│   ├── view/Reader/        (4 JSP đúng tên thiết kế)
│   ├── view/ManagementStaff/ (5 JSP đúng tên thiết kế)
│   └── WEB-INF/
│       ├── web.xml
│       └── jspf/common.jspf  (hàm định dạng HTML, không truy vấn CSDL)
└── target/                 (sinh tự động sau build)
```

**Vì dùng Maven:** project không có thư mục `WebContent` của Eclipse. Thành phần tương đương là `src/main/webapp`. Khi chụp ảnh trong VS Code, mở Explorer và bung các thư mục `dao`, `model`, `view` và `database`. Chụp cả `pom.xml` và `target/LibMan5.war` sau khi build.

## 16. Các lỗi thường gặp và cách khắc phục

| Hiện tượng | Nguyên nhân thường gặp | Cách xử lý |
|---|---|---|
| `mvn is not recognized` | Chưa cài Maven/chưa thêm `Path` | Kiểm tra Maven `bin`, mở PowerShell mới |
| `java` là phiên bản 8/21 | JAVA_HOME sai | Đặt JDK 17, kiểm tra `java -version` |
| `BUILD FAILURE` không tải được phụ thuộc | Mạng/Maven Central | Kiểm tra internet, `mvn -U clean package` |
| Tomcat không chạy được | `JAVA_HOME` sai, port 8080 bị dùng | Xem `logs/catalina...`, chạy `catalina.bat run` |
| `404 /LibMan5/` | WAR chưa copy hoặc chưa deploy | Kiểm tra `webapps/LibMan5.war`, `webapps/LibMan5` |
| `500` khi vào JSP | Lỗi lúc biên dịch hoặc chạy JSP | Xem log chi tiết của Tomcat ở `logs/` |
| `Không kết nối được CSDL` | MySQL XAMPP chưa Start, sai user/password/port | Start MySQL, kiểm tra env `LIBMAN_DB_*` |
| `Access denied for user 'root'` | XAMPP root đã có mật khẩu | Set `LIBMAN_DB_PASSWORD` đúng, khởi động lại Tomcat |
| `Unknown database libman5` | Chưa import schema.sql | Nhập schema.sql trước seed.sql |
| `Table doesn't exist` | Import schema lỗi | Kiểm tra 20 bảng trong phpMyAdmin |
| Duplicate entry lúc nhập seed | Đã nhập seed trước đó | Chạy lại schema.sql (xóa dữ liệu demo) rồi seed.sql |
| Login sai dù nhập đúng | Chưa seed, DB đang khác | Kiểm tra `SELECT userName,role FROM tblMember5` |
| Thanh toán ở QR không tự chuyển | Meta refresh bị trình duyệt chặn | Bật automatic refresh trong trình duyệt; kiểm tra URL và console/log server |
| Giao diện mất dấu tiếng Việt | MySQL charset/file encoding sai | UTF-8 ở VS Code, `utf8mb4` trong schema, cấu hình JSP UTF-8 |
| Khác tiêu đề/tab | Sai URL trang JSP | Truy cập đúng các URL ở mục 14 |

Cách tốt nhất để xem lỗi Java/JSP thực tế là chạy Tomcat ở chế độ terminal:

```powershell
& "C:\Tools\apache-tomcat-9.0.123\bin\catalina.bat" run
```

Dòng lỗi đầu tiên có `Caused by:` thường chỉ ra nguyên nhân cụ thể.

## 17. Cách chụp bằng chứng cho báo cáo phần D. Lập trình

**Chỉ chụp màn hình web đã chạy thực tế trên máy bạn**, không chụp lại hình V0 từ tài liệu để nói là kết quả code.

Ảnh gợi ý: (1) đăng nhập, (2) trang Reader, (3) form đăng ký, (4) QR, (5) hóa đơn, (6) trang Management Staff, (7) chọn loại thống kê, (8) danh sách thống kê và lọc AND, (9) danh sách lượt mượn, (10) chi tiết phiếu mượn, (11) thư mục source trong VS Code và (12) các bảng/dữ liệu trong phpMyAdmin nếu cần.

Giữ tên file ảnh dễ hiểu khi chèn Word. Sau khi code chạy, đẩy source lên GitHub và chèn **đường dẫn repository thật**, không tự tạo link giả.

## 18. Đưa lên GitHub khi đã kiểm thử

1. Tạo repository GitHub trống bằng tài khoản của bạn, ví dụ `LibMan5`.
2. Trong terminal VS Code (đang đứng thư mục project):

```powershell
git init
git add .
git commit -m "LibMan5 JSP two-module demo"
git branch -M main
git remote add origin https://github.com/TEN_TAI_KHOAN/LibMan5.git
git push -u origin main
```

**Thay `TEN_TAI_KHOAN` bằng tài khoản thực và tạo repository trước.** Project có `.gitignore` bỏ qua `target`, file build và cấu hình IDE; chỉ đẩy source/SQL/hướng dẫn. Đừng tự đẩy mật khẩu MySQL cá nhân lên GitHub; project nhận mật khẩu từ biến môi trường.

## 19. Ghi chú kỹ thuật để giữ đúng báo cáo

- Có **9 phương thức DAO nghiệp vụ**, không có `DocumentTypeDAO5`, DAO phân trang hay DAO tìm kiếm.
- `DatabaseContext` chỉ là lớp **hạ tầng kết nối và quản lý transaction**, không có nghiệp vụ hay bảng mới.
- Đăng nhập đơn giản truy vấn `tblMember5` trực tiếp trong trang xử lý login, **không tạo MemberDAO5** vì nằm ngoài 2 module thiết kế.
- `DocumentStatistics5` kế thừa `DocumentTitle5`, truy cập loại qua `titleTypes: TitleType5[]`, không thêm `documentTypes` trực tiếp vào nó.
- `LoanSlip5` chứa `loans: Loan5[]`; `Loan5` **không chứa LoanSlip5**, giữ đúng hình thoi trên sơ đồ.
- `getLoanSlipsByLoans()` đọc theo **một danh sách** để tránh 1 lần gọi SQL cho mỗi dòng.
- Dữ liệu ngày mượn và hạn trả đến từ `LoanSlip5`, không tự lưu vào `Loan5`.
- Bộ lọc AND chỉ mở khi có dữ liệu thống kê; tổng được tính trên toàn bộ kết quả đã lọc.
- Khi `Back`, dữ liệu form/danh sách/từ khóa/trang được lưu trong `HttpSession`, không tự thêm DAO khôi phục.
- Các phần chưa triển khai ngoài phạm vi (gia hạn, tra cứu tài liệu, đổi mật khẩu, quản lý nhân viên...) hiển thị đủ menu nhưng chỉ trả thông báo ngoài phạm vi, không giả làm chức năng đã hoàn thành.
- QR trong ảnh là **mã QR demo tĩnh**, không kết nối ngân hàng. Sau 3 giây HTML `meta refresh` kích hoạt bước xác nhận thành công phía server.
- Tất cả tên và mã số trong seed là **dữ liệu giả lập**; không coi chúng là thông số nghiệp vụ được giáo trình ấn định.

**Kiểm chứng đã thực hiện trong môi trường xây dựng:** Java model/DAO đã compile bằng JDK 17; code scriptlet của 13 JSP đã được type-check bằng `javac` với Servlet API 4.0. **Chưa chạy được XAMPP/Tomcat hoặc Maven trên máy Windows thực tế trong môi trường hiện tại**, do đó chỉ có thể khẳng định đã kiểm tra tĩnh, chưa xác nhận thực thi end-to-end. Bạn nên chạy toàn bộ các ca kiểm thử ở mục 11–13 trước khi chụp ảnh và nộp bài.
