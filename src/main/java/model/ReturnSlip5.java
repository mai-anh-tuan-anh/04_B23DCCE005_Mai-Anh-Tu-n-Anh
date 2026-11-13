package model;

import java.time.LocalDate;
import java.math.BigDecimal;

public class ReturnSlip5 {
    private int id;
    private String returnSlipCode;
    private LocalDate returnDate;
    private BigDecimal totalFine;
    private Reader5 reader;
    private LibraryStaff5 libraryStaff;
    private Loan5[] loans;

    public ReturnSlip5() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getReturnSlipCode() {
        return returnSlipCode;
    }

    public void setReturnSlipCode(String returnSlipCode) {
        this.returnSlipCode = returnSlipCode;
    }

    public LocalDate getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(LocalDate returnDate) {
        this.returnDate = returnDate;
    }

    public BigDecimal getTotalFine() {
        return totalFine;
    }

    public void setTotalFine(BigDecimal totalFine) {
        this.totalFine = totalFine;
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
