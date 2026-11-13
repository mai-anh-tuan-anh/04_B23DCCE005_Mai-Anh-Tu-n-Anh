package model;

import java.time.LocalDate;

public class LoanSlip5 {
    private int id;
    private String loanSlipCode;
    private LocalDate loanDate;
    private LocalDate dueDate;
    private String loanSlipStatus;
    private Reader5 reader;
    private LibraryStaff5 libraryStaff;
    private Loan5[] loans;

    public LoanSlip5() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getLoanSlipCode() {
        return loanSlipCode;
    }

    public void setLoanSlipCode(String loanSlipCode) {
        this.loanSlipCode = loanSlipCode;
    }

    public LocalDate getLoanDate() {
        return loanDate;
    }

    public void setLoanDate(LocalDate loanDate) {
        this.loanDate = loanDate;
    }

    public LocalDate getDueDate() {
        return dueDate;
    }

    public void setDueDate(LocalDate dueDate) {
        this.dueDate = dueDate;
    }

    public String getLoanSlipStatus() {
        return loanSlipStatus;
    }

    public void setLoanSlipStatus(String loanSlipStatus) {
        this.loanSlipStatus = loanSlipStatus;
    }

    public Reader5 getReader() {
        return reader;
    }

    public void setReader(Reader5 reader) {
        this.reader = reader;
    }

    public LibraryStaff5 getLibraryStaff() {
        return libraryStaff;
    }

    public void setLibraryStaff(LibraryStaff5 libraryStaff) {
        this.libraryStaff = libraryStaff;
    }

    public Loan5[] getLoans() {
        return loans;
    }

    public void setLoans(Loan5[] loans) {
        this.loans = loans;
    }
}
