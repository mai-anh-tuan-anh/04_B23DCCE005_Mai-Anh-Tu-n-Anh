package model;

import java.math.BigDecimal;

public class ReaderCardType5 {
    private int id;
    private String readerCardTypeCode;
    private String readerCardTypeName;
    private BigDecimal registrationFee;
    private BigDecimal renewFee;
    private int validityPeriod;
    private int loanDuration;
    private int maxBorrowedCopies;

    public ReaderCardType5() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getReaderCardTypeCode() {
        return readerCardTypeCode;
    }

    public void setReaderCardTypeCode(String readerCardTypeCode) {
        this.readerCardTypeCode = readerCardTypeCode;
    }

    public String getReaderCardTypeName() {
        return readerCardTypeName;
    }

    public void setReaderCardTypeName(String readerCardTypeName) {
        this.readerCardTypeName = readerCardTypeName;
    }

    public BigDecimal getRegistrationFee() {
        return registrationFee;
    }

    public void setRegistrationFee(BigDecimal registrationFee) {
        this.registrationFee = registrationFee;
    }

    public BigDecimal getRenewFee() {
        return renewFee;
    }

    public void setRenewFee(BigDecimal renewFee) {
        this.renewFee = renewFee;
    }

    public int getValidityPeriod() {
        return validityPeriod;
    }

    public void setValidityPeriod(int validityPeriod) {
        this.validityPeriod = validityPeriod;
    }

    public int getLoanDuration() {
        return loanDuration;
    }

    public void setLoanDuration(int loanDuration) {
        this.loanDuration = loanDuration;
    }

    public int getMaxBorrowedCopies() {
        return maxBorrowedCopies;
    }

    public void setMaxBorrowedCopies(int maxBorrowedCopies) {
        this.maxBorrowedCopies = maxBorrowedCopies;
    }
}
