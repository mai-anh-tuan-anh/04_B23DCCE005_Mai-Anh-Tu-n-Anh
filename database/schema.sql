-- LibMan5 - đúng 20 bảng theo sơ đồ CSDL trong báo cáo và Database(1).png.
-- Dữ liệu dẫn xuất (DocumentStatistics5, ReaderStatistics5, ImportedDocumentStatistics5)
-- không có bảng riêng (đúng Bước 5 của thiết kế CSDL).
-- CHÚ Ý: Script này XÓA và tạo lại 20 bảng để chạy demo từ đầu.
CREATE DATABASE IF NOT EXISTS libman5 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE libman5;
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS tblLoanFine5;
DROP TABLE IF EXISTS tblLoan5;
DROP TABLE IF EXISTS tblReturnSlip5;
DROP TABLE IF EXISTS tblLoanSlip5;
DROP TABLE IF EXISTS tblImportBatch5;
DROP TABLE IF EXISTS tblReaderCardRegistrationInvoice5;
DROP TABLE IF EXISTS tblReaderCard5;
DROP TABLE IF EXISTS tblTitleType5;
DROP TABLE IF EXISTS tblDocumentCopy5;
DROP TABLE IF EXISTS tblDocumentType5;
DROP TABLE IF EXISTS tblDocumentTitle5;
DROP TABLE IF EXISTS tblFineRate5;
DROP TABLE IF EXISTS tblReaderCardType5;
DROP TABLE IF EXISTS tblReaderType5;
DROP TABLE IF EXISTS tblSupplier5;
DROP TABLE IF EXISTS tblReader5;
DROP TABLE IF EXISTS tblManagementStaff5;
DROP TABLE IF EXISTS tblLibraryStaff5;
DROP TABLE IF EXISTS tblStaff5;
DROP TABLE IF EXISTS tblMember5;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE tblMember5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  userName VARCHAR(50) NOT NULL,
  passWord VARCHAR(255) NOT NULL,
  fullName VARCHAR(150) NOT NULL,
  gender VARCHAR(20),
  address VARCHAR(255),
  dateOfBirth DATE,
  email VARCHAR(150),
  phoneNumber VARCHAR(20),
  `role` VARCHAR(50) NOT NULL,
  PRIMARY KEY (id), UNIQUE KEY uq_member_username (userName)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblStaff5 (
  tblMember5id INTEGER(10) NOT NULL,
  staffCode VARCHAR(50) NOT NULL,
  PRIMARY KEY (tblMember5id), UNIQUE KEY uq_staff_code (staffCode),
  CONSTRAINT fk_staff_member FOREIGN KEY (tblMember5id) REFERENCES tblMember5(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblManagementStaff5 (
  tblStaff5id INTEGER(10) NOT NULL,
  PRIMARY KEY (tblStaff5id),
  CONSTRAINT fk_management_staff FOREIGN KEY (tblStaff5id) REFERENCES tblStaff5(tblMember5id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblLibraryStaff5 (
  tblStaff5id INTEGER(10) NOT NULL,
  PRIMARY KEY (tblStaff5id),
  CONSTRAINT fk_library_staff FOREIGN KEY (tblStaff5id) REFERENCES tblStaff5(tblMember5id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblReader5 (
  tblMember5id INTEGER(10) NOT NULL,
  readerCode VARCHAR(50) NOT NULL,
  PRIMARY KEY (tblMember5id), UNIQUE KEY uq_reader_code (readerCode),
  CONSTRAINT fk_reader_member FOREIGN KEY (tblMember5id) REFERENCES tblMember5(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblSupplier5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  supplierCode VARCHAR(50) NOT NULL,
  supplierName VARCHAR(150) NOT NULL,
  address VARCHAR(255),
  email VARCHAR(150),
  phoneNumber VARCHAR(20),
  PRIMARY KEY (id), UNIQUE KEY uq_supplier_code (supplierCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblDocumentTitle5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  documentTitleCode VARCHAR(50) NOT NULL,
  documentTitleName VARCHAR(200) NOT NULL,
  author VARCHAR(150),
  publisher VARCHAR(150),
  publicationDate DATE,
  description VARCHAR(255) NULL,
  shelfLocation VARCHAR(100),
  PRIMARY KEY (id), UNIQUE KEY uq_title_code (documentTitleCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblDocumentType5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  documentTypeCode VARCHAR(50) NOT NULL,
  documentTypeName VARCHAR(100) NOT NULL,
  PRIMARY KEY (id), UNIQUE KEY uq_document_type_code (documentTypeCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblTitleType5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  assignDate DATE,
  tblDocumentTitle5id INTEGER(10) NOT NULL,
  tblDocumentType5id INTEGER(10) NOT NULL,
  PRIMARY KEY (id),
  KEY idx_tt_title (tblDocumentTitle5id), KEY idx_tt_type (tblDocumentType5id),
  CONSTRAINT fk_tt_title FOREIGN KEY (tblDocumentTitle5id) REFERENCES tblDocumentTitle5(id),
  CONSTRAINT fk_tt_type FOREIGN KEY (tblDocumentType5id) REFERENCES tblDocumentType5(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblDocumentCopy5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  documentCopyCode VARCHAR(50) NOT NULL,
  documentCopyStatus VARCHAR(50),
  documentCopyCondition VARCHAR(50),
  tblDocumentTitle5id INTEGER(10) NOT NULL,
  PRIMARY KEY (id), UNIQUE KEY uq_copy_code (documentCopyCode),
  KEY idx_copy_title (tblDocumentTitle5id),
  CONSTRAINT fk_copy_title FOREIGN KEY (tblDocumentTitle5id) REFERENCES tblDocumentTitle5(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblReaderCardType5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  readerCardTypeCode VARCHAR(50) NOT NULL,
  readerCardTypeName VARCHAR(100) NOT NULL,
  registrationFee DECIMAL(18,2) NOT NULL,
  renewFee DECIMAL(18,2) NOT NULL,
  validityPeriod INTEGER(10) NOT NULL,
  loanDuration INTEGER(10) NOT NULL,
  maxBorrowedCopies INTEGER(10) NOT NULL,
  PRIMARY KEY (id), UNIQUE KEY uq_card_type_code (readerCardTypeCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblReaderType5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  readerTypeCode VARCHAR(50) NOT NULL,
  readerTypeName VARCHAR(100) NOT NULL,
  PRIMARY KEY (id), UNIQUE KEY uq_reader_type_code (readerTypeCode)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblReaderCard5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  readerCardCode VARCHAR(50) NOT NULL,
  fullName VARCHAR(150) NOT NULL,
  gender VARCHAR(20),
  readerCardStatus VARCHAR(50),
  dateOfBirth DATE NOT NULL,
  citizenIdentificationNumber VARCHAR(12) NOT NULL,
  address VARCHAR(255),
  email VARCHAR(150),
  phoneNumber VARCHAR(20),
  issueDate DATE NOT NULL,
  expiryDate DATE NOT NULL,
  cardDeliveryMethod VARCHAR(50),
  tblReader5id INTEGER(10) NOT NULL,
  tblReaderType5id INTEGER(10) NOT NULL,
  tblReaderCardType5id INTEGER(10) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_card_code (readerCardCode),
  UNIQUE KEY uq_card_cccd (citizenIdentificationNumber),
  UNIQUE KEY uq_card_reader (tblReader5id),
  KEY idx_card_reader_type (tblReaderType5id),
  KEY idx_card_card_type (tblReaderCardType5id),
  CONSTRAINT fk_card_reader FOREIGN KEY (tblReader5id) REFERENCES tblReader5(tblMember5id),
  CONSTRAINT fk_card_reader_type FOREIGN KEY (tblReaderType5id) REFERENCES tblReaderType5(id),
  CONSTRAINT fk_card_card_type FOREIGN KEY (tblReaderCardType5id) REFERENCES tblReaderCardType5(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblReaderCardRegistrationInvoice5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  invoiceCode VARCHAR(50) NOT NULL,
  invoiceDate DATE NOT NULL,
  paidAmount DECIMAL(18,2) NOT NULL,
  tblReaderCard5id INTEGER(10) NOT NULL,
  PRIMARY KEY (id),
  UNIQUE KEY uq_invoice_code (invoiceCode),
  UNIQUE KEY uq_invoice_card (tblReaderCard5id),
  CONSTRAINT fk_invoice_card FOREIGN KEY (tblReaderCard5id) REFERENCES tblReaderCard5(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblLoanSlip5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  loanSlipCode VARCHAR(50) NOT NULL,
  loanDate DATE NOT NULL,
  dueDate DATE NOT NULL,
  loanSlipStatus VARCHAR(50) NOT NULL,
  tblLibraryStaff5id INTEGER(10) NOT NULL,
  tblReader5id INTEGER(10) NOT NULL,
  PRIMARY KEY (id), UNIQUE KEY uq_loan_slip_code (loanSlipCode),
  KEY idx_slip_date (loanDate), KEY idx_slip_reader (tblReader5id),
  CONSTRAINT fk_slip_staff FOREIGN KEY (tblLibraryStaff5id) REFERENCES tblLibraryStaff5(tblStaff5id),
  CONSTRAINT fk_slip_reader FOREIGN KEY (tblReader5id) REFERENCES tblReader5(tblMember5id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblReturnSlip5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  returnSlipCode VARCHAR(50) NOT NULL,
  returnDate DATE NOT NULL,
  totalFine DECIMAL(18,2) NOT NULL,
  tblReader5id INTEGER(10) NOT NULL,
  tblLibraryStaff5id INTEGER(10) NOT NULL,
  PRIMARY KEY (id), UNIQUE KEY uq_return_slip_code (returnSlipCode),
  CONSTRAINT fk_return_reader FOREIGN KEY (tblReader5id) REFERENCES tblReader5(tblMember5id),
  CONSTRAINT fk_return_staff FOREIGN KEY (tblLibraryStaff5id) REFERENCES tblLibraryStaff5(tblStaff5id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblLoan5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  returnDate DATE NULL,
  fine DECIMAL(18,2) NOT NULL DEFAULT 0,
  tblLoanSlip5id INTEGER(10) NOT NULL,
  tblDocumentCopy5id INTEGER(10) NOT NULL,
  tblReturnSlip5id INTEGER(10) NULL,
  PRIMARY KEY (id),
  KEY idx_loan_slip (tblLoanSlip5id), KEY idx_loan_copy (tblDocumentCopy5id),
  KEY idx_loan_return (tblReturnSlip5id),
  CONSTRAINT fk_loan_slip FOREIGN KEY (tblLoanSlip5id) REFERENCES tblLoanSlip5(id),
  CONSTRAINT fk_loan_copy FOREIGN KEY (tblDocumentCopy5id) REFERENCES tblDocumentCopy5(id),
  CONSTRAINT fk_loan_return FOREIGN KEY (tblReturnSlip5id) REFERENCES tblReturnSlip5(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblFineRate5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  fineType VARCHAR(50) NOT NULL,
  fineRate DECIMAL(18,2) NOT NULL,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblLoanFine5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  appliedFineAmount DECIMAL(18,2) NOT NULL,
  tblLoan5id INTEGER(10) NOT NULL,
  tblFineRate5id INTEGER(10) NOT NULL,
  PRIMARY KEY (id),
  KEY idx_loan_fine_loan (tblLoan5id), KEY idx_loan_fine_rate (tblFineRate5id),
  CONSTRAINT fk_loan_fine_loan FOREIGN KEY (tblLoan5id) REFERENCES tblLoan5(id),
  CONSTRAINT fk_loan_fine_rate FOREIGN KEY (tblFineRate5id) REFERENCES tblFineRate5(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE tblImportBatch5 (
  id INTEGER(10) NOT NULL AUTO_INCREMENT,
  importDate DATE NOT NULL,
  quantity INTEGER(10) NOT NULL,
  tblSupplier5id INTEGER(10) NOT NULL,
  tblDocumentTitle5id INTEGER(10) NOT NULL,
  tblLibraryStaff5id INTEGER(10) NOT NULL,
  PRIMARY KEY (id),
  KEY idx_import_supplier (tblSupplier5id),
  KEY idx_import_title (tblDocumentTitle5id),
  KEY idx_import_staff (tblLibraryStaff5id),
  CONSTRAINT fk_import_supplier FOREIGN KEY (tblSupplier5id) REFERENCES tblSupplier5(id),
  CONSTRAINT fk_import_title FOREIGN KEY (tblDocumentTitle5id) REFERENCES tblDocumentTitle5(id),
  CONSTRAINT fk_import_staff FOREIGN KEY (tblLibraryStaff5id) REFERENCES tblLibraryStaff5(tblStaff5id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
