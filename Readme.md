# LIBMAN5 — LỆNH CHẠY, CẬP NHẬT VÀ DEMO (WINDOWS)

## 1. Đường dẫn và địa chỉ quan trọng

| Mục                   | Giá trị của máy bạn                                       |
| --------------------- | --------------------------------------------------------- |
| Thư mục project       | `C:\Users\ADMIN\Downloads\Httt\Code\LibMan5`              |
| Tomcat 9              | `C:\Tools\apache-tomcat-9.0.123`                          |
| JDK                   | `C:\Program Files\Eclipse Adoptium\jdk-17.0.21.9-hotspot` |
| Maven                 | `C:\Tools\apache-maven-3.10.0`                            |
| File WAR sau build    | `target\LibMan5.war`                                      |
| WAR triển khai        | `C:\Tools\apache-tomcat-9.0.123\webapps\LibMan5.war`      |
| **Trang web LibMan5** | **http://localhost:8081/LibMan5/**                        |
| Trang đăng nhập       | http://localhost:8081/LibMan5/view/Member/UILogin.jsp     |
| phpMyAdmin (XAMPP)    | http://localhost:8082/phpmyadmin/                         |
| MariaDB / MySQL XAMPP | `localhost:3306`, database `libman5`                      |

**Tài khoản demo:** `reader01`–`reader20` / `123456` (chưa có thẻ lúc mới import seed); `reader21` / `123456` (đã có thẻ); `manager` / `123456` (nhân viên quản lý). Nếu đã đăng ký bằng một tài khoản, trạng thái của tài khoản đó sẽ thay đổi.

## 2. Mỗi lần muốn chạy web

**Bước A — Bật CSDL:** Mở **XAMPP Control Panel**, nhấn **Start** cho **MySQL**. Chỉ cần bật **Apache** của XAMPP khi cần vào phpMyAdmin (`8082`). Tomcat chạy độc lập, không cần Apache XAMPP để phục vụ trang JSP.

**Bước B — Mở VS Code tại thư mục project:**

```powershell
cd "C:\Users\ADMIN\Downloads\Httt\Code\LibMan5"
```

**Bước C — Chạy Tomcat:** Mở **một terminal PowerShell riêng** và để terminal này chạy trong khi demo.

```powershell
$env:CATALINA_HOME = "C:\Tools\apache-tomcat-9.0.123"
& "$env:CATALINA_HOME\bin\catalina.bat" run
```

**Bước D — Mở trình duyệt:**

- **Ứng dụng:** http://localhost:8081/LibMan5/
- **Đăng nhập trực tiếp:** http://localhost:8081/LibMan5/view/Member/UILogin.jsp
- **CSDL:** http://localhost:8082/phpmyadmin/

**Dừng Tomcat:** Nhấn **Ctrl+C** trong terminal đang chạy `catalina.bat run`. Đừng đóng terminal đó giữa lúc demo.

## 3. Sửa NHIỀU trang JSP / CSS / ảnh — cập nhật nhanh KHÔNG build lại

Áp dụng khi bạn sửa file trong:

- `src\main\webapp\view\...` (JSP)
- `src\main\webapp\assets\...` (CSS/ảnh)
- `src\main\webapp\WEB-INF\jspf\...` (JSP dùng chung)

**Giữ Tomcat đang chạy**, lưu toàn bộ file trong VS Code (`Ctrl+K`, rồi `S`; hoặc File → Save All). Mở **terminal PowerShell khác** tại thư mục project và chạy:

```powershell
cd "C:\Users\ADMIN\Downloads\Httt\Code\LibMan5"
robocopy ".\src\main\webapp" "C:\Tools\apache-tomcat-9.0.123\webapps\LibMan5" /E
```

"C:\Tools\apache-tomcat-9.0.123\webapps\LibMan5"` nếu cần.

## 4. Sửa code Java (Model/DAO), `pom.xml` hoặc muốn tạo WAR hoàn chỉnh

Khi sửa Java trong `src\main\java\...`, hoặc thư viện Maven, hãy **biên dịch và triển khai lại WAR**. Thực hiện theo thứ tự này để không bị lưu file cũ:

**Bước 1 — Dừng Tomcat:** Nhấn `Ctrl+C` ở terminal đang chạy Tomcat.

**Bước 2 — Build lại** trong terminal VS Code tại thư mục project:

```powershell
cd "C:\Users\ADMIN\Downloads\Httt\Code\LibMan5"
mvn clean package
```

Chỉ tiếp tục khi thấy **`[INFO] BUILD SUCCESS`**. Kiểm tra file:

```powershell
Get-Item ".\target\LibMan5.war"
```

**Bước 3 — Xóa CHỈ bản ứng dụng đã bung và cache JSP trong Tomcat** (không đụng vào source/database):

```powershell
Remove-Item "C:\Tools\apache-tomcat-9.0.123\webapps\LibMan5" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "C:\Tools\apache-tomcat-9.0.123\work\Catalina\localhost\LibMan5" -Recurse -Force -ErrorAction SilentlyContinue
```

**Bước 4 — Chép WAR mới vào Tomcat:**

```powershell
Copy-Item ".\target\LibMan5.war" "C:\Tools\apache-tomcat-9.0.123\webapps\LibMan5.war" -Force
```

**Bước 5 — Chạy Tomcat lại** trong terminal riêng:

```powershell
$env:CATALINA_HOME = "C:\Tools\apache-tomcat-9.0.123"
& "$env:CATALINA_HOME\bin\catalina.bat" run
```

**Bước 6 — Kiểm tra:** http://localhost:8081/LibMan5/ và nhấn `Ctrl+Shift+R`.

## 5. Lệnh kiểm tra nhanh và xử lý lỗi

Chạy trong PowerShell (terminal **khác** terminal Tomcat):

```powershell
# Java và Maven
java -version
javac -version
mvn -version

# Xem 8081 có tiến trình lắng nghe không
Get-NetTCPConnection -LocalPort 8081 -State Listen -ErrorAction SilentlyContinue

# Xem WAR đã tạo và WAR đã triển khai chưa
Get-Item ".\target\LibMan5.war"
Get-Item "C:\Tools\apache-tomcat-9.0.123\webapps\LibMan5.war"

# Xem phiên bản Java đang dùng
$env:JAVA_HOME

# Xem đường dẫn Tomcat hiện tại
$env:CATALINA_HOME
```

| Dấu hiệu                                  | Cách xử lý trước tiên                                                                               |
| ----------------------------------------- | --------------------------------------------------------------------------------------------------- |
| `BUILD FAILURE`                           | Đọc dòng `[ERROR]` đầu tiên của `mvn clean package`                                                 |
| `CATALINA_HOME ... not defined correctly` | Đặt `$env:CATALINA_HOME = "C:\Tools\apache-tomcat-9.0.123"` và chạy lại                             |
| `Address already in use`                  | Kiểm tra cổng `8081` có chương trình khác sử dụng                                                   |
| `HTTP 404`                                | Kiểm tra `LibMan5.war`, ngữ cảnh `/LibMan5/` và log Tomcat                                          |
| `HTTP 500`                                | Xem `Exception`/`Caused by` trong terminal Tomcat; JSP có thể chỉ biên dịch khi truy cập            |
| Tiếng Việt bị lỗi                         | Bảo đảm file JSP lưu UTF-8 và có `<%@ page pageEncoding="UTF-8" %>`, cập nhật JSP/cache rồi tải lại |
| Không kết nối CSDL                        | Kiểm tra MySQL trong XAMPP đang chạy, port `3306`, cấu hình trong `DAO.java`                        |
| Giao diện vẫn cũ                          | Lưu file gốc → `robocopy` → `Ctrl+Shift+R`; nếu vẫn cũ, triển khai WAR mới theo mục 4               |

Log Tomcat trên máy bạn: `C:\Tools\apache-tomcat-9.0.123\logs\`. Lỗi JSP/Java có thể xuất hiện trực tiếp trong terminal đang chạy `catalina.bat run`.
