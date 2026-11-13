package model;

import java.time.LocalDate;

public class ReaderCard5 {
    private int id;
    private String readerCardCode;
    private String fullName;
    private String gender;
    private LocalDate dateOfBirth;
    private String citizenIdentificationNumber;
    private String address;
    private String email;
    private String phoneNumber;
    private LocalDate issueDate;
    private LocalDate expiryDate;
    private String readerCardStatus;
    private String cardDeliveryMethod;
    private ReaderCardType5 readerCardType;
    private ReaderType5 readerType;
    private ReaderCardRegistrationInvoice5 registrationInvoice;

    public ReaderCard5() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getReaderCardCode() {
        return readerCardCode;
    }

    public void setReaderCardCode(String readerCardCode) {
        this.readerCardCode = readerCardCode;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public LocalDate getDateOfBirth() {
        return dateOfBirth;
    }

    public void setDateOfBirth(LocalDate dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }

    public String getCitizenIdentificationNumber() {
        return citizenIdentificationNumber;
    }

    public void setCitizenIdentificationNumber(String citizenIdentificationNumber) {
        this.citizenIdentificationNumber = citizenIdentificationNumber;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public LocalDate getIssueDate() {
        return issueDate;
    }

    public void setIssueDate(LocalDate issueDate) {
        this.issueDate = issueDate;
    }

    public LocalDate getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDate expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getReaderCardStatus() {
        return readerCardStatus;
    }

    public void setReaderCardStatus(String readerCardStatus) {
        this.readerCardStatus = readerCardStatus;
    }

    public String getCardDeliveryMethod() {
        return cardDeliveryMethod;
    }

    public void setCardDeliveryMethod(String cardDeliveryMethod) {
        this.cardDeliveryMethod = cardDeliveryMethod;
    }

    public ReaderCardType5 getReaderCardType() {
        return readerCardType;
    }

    public void setReaderCardType(ReaderCardType5 readerCardType) {
        this.readerCardType = readerCardType;
    }

    public ReaderType5 getReaderType() {
        return readerType;
    }

    public void setReaderType(ReaderType5 readerType) {
        this.readerType = readerType;
    }

    public ReaderCardRegistrationInvoice5 getRegistrationInvoice() {
        return registrationInvoice;
    }

    public void setRegistrationInvoice(ReaderCardRegistrationInvoice5 registrationInvoice) {
        this.registrationInvoice = registrationInvoice;
    }
}
