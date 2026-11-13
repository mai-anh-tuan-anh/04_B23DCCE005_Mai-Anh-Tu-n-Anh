-- Câu lệnh kiểm tra sau khi nhập schema.sql và seed.sql
USE libman5;
-- Đúng 20 bảng:
SELECT COUNT(*) AS total_tables FROM information_schema.tables
WHERE table_schema='libman5' AND table_type='BASE TABLE';
-- Dữ liệu phong phú, đặc biệt các lượt mượn:
SELECT COUNT(*) AS readers FROM tblReader5;
SELECT COUNT(*) AS document_titles FROM tblDocumentTitle5;
SELECT COUNT(*) AS document_copies FROM tblDocumentCopy5;
SELECT COUNT(*) AS loan_slips FROM tblLoanSlip5;
SELECT COUNT(*) AS loans FROM tblLoan5;
SELECT COUNT(*) AS return_slips FROM tblReturnSlip5;
-- Độc giả reader01 ID=3 chưa có thẻ, dùng để thử đăng ký mới:
SELECT COUNT(*) AS cards_of_reader01 FROM tblReaderCard5 WHERE tblReader5id=3;
-- Kiểm tra dữ liệu lọc AND trên hai loại tài liệu:
SELECT dt.documentTitleCode,dt.documentTitleName,COUNT(DISTINCT tt.tblDocumentType5id) AS types_matched
FROM tblDocumentTitle5 dt JOIN tblTitleType5 tt ON tt.tblDocumentTitle5id=dt.id
WHERE tt.tblDocumentType5id IN (1,3)
GROUP BY dt.id,dt.documentTitleCode,dt.documentTitleName
HAVING COUNT(DISTINCT tt.tblDocumentType5id)=2 LIMIT 20;
-- Kiểm tra lượt mượn trong 19/07/2026 - 25/07/2026:
SELECT COUNT(*) AS loans_in_demo_week
FROM tblLoan5 l JOIN tblLoanSlip5 s ON s.id=l.tblLoanSlip5id
WHERE s.loanDate BETWEEN '2026-07-19' AND '2026-07-25';
-- Kiểm tra không có kết quả thống kê đếm trùng trong JOIN loại:
SELECT d.documentTitleCode,COUNT(DISTINCT l.id) AS loanAmount
FROM tblDocumentTitle5 d
JOIN tblDocumentCopy5 c ON c.tblDocumentTitle5id=d.id
JOIN tblLoan5 l ON l.tblDocumentCopy5id=c.id
JOIN tblLoanSlip5 s ON s.id=l.tblLoanSlip5id
WHERE s.loanDate BETWEEN '2026-07-19' AND '2026-07-25'
GROUP BY d.id,d.documentTitleCode ORDER BY loanAmount DESC LIMIT 15;
