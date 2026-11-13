package model;

import java.math.BigDecimal;

public class LoanFine5 {
    private int id;
    private BigDecimal appliedFineAmount;
    private Loan5 loan;
    private FineRate5 fineRate;

    public LoanFine5() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public BigDecimal getAppliedFineAmount() {
        return appliedFineAmount;
    }

    public void setAppliedFineAmount(BigDecimal appliedFineAmount) {
        this.appliedFineAmount = appliedFineAmount;
    }

    public Loan5 getLoan() {
        return loan;
    }

    public void setLoan(Loan5 loan) {
        this.loan = loan;
    }

    public FineRate5 getFineRate() {
        return fineRate;
    }

    public void setFineRate(FineRate5 fineRate) {
        this.fineRate = fineRate;
    }
}
