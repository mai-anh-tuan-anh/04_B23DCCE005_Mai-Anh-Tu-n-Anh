# LibMan5 — University Library Management System

**Java 17 · JSP/HTML/CSS · Tomcat 9 · MariaDB (XAMPP) · Maven WAR · không JavaScript**

Ứng dụng demo gồm 2 module đúng theo báo cáo `04B23DCCE005(20261113-053957).docx`: đăng ký thẻ độc giả và thống kê lượt mượn tài liệu, kèm đăng nhập/đăng xuất đơn giản.

**HƯỚNG DẪN TỪ A ĐẾN Z:** [HUONG_DAN_CHAY_TU_A_DEN_Z.md](HUONG_DAN_CHAY_TU_A_DEN_Z.md) (18 mục, có kiểm thử và sửa lỗi).

## Chạy nhanh (sau khi đã cài JDK 17, Maven, Tomcat 9, XAMPP)

1. Bật `MySQL` trong XAMPP, bật thêm `Apache` nếu dùng phpMyAdmin.
2. Trong phpMyAdmin, import `database/schema.sql`, rồi import `database/seed.sql` vào `libman5`.
3. Mở folder project bằng VS Code. Trong Terminal chạy `mvn clean package`.
4. Chép `target/LibMan5.war` vào `<Tomcat9>/webapps/`, chạy `<Tomcat9>/bin/startup.bat`.
5. Mở **http://localhost:8080/LibMan5/**.
6. Đăng nhập `reader01 / 123456` để đăng ký thẻ, hoặc `manager / 123456` để xem thống kê.

**Cơ sở dữ liệu:** đúng 20 bảng trong sơ đồ, không có bảng thống kê dẫn xuất. **DAO:** đúng 9 phương thức nghiệp vụ của báo cáo. `DatabaseContext` chỉ quản lý JDBC và transaction, không phải DAO nghiệp vụ bổ sung.

**Lưu ý:** Seed chỉ gồm dữ liệu giả lập để demo; QR tự xác nhận sau 3 giây chứ không kết nối ngân hàng. Các mục menu ngoài phạm vi không được triển khai nghiệp vụ.
