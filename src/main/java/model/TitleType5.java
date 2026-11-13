package model;

import java.time.LocalDate;

public class TitleType5 {
    private int id;
    private LocalDate assignDate;
    private DocumentType5 documentType;

    public TitleType5() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDate getAssignDate() {
        return assignDate;
    }

    public void setAssignDate(LocalDate assignDate) {
        this.assignDate = assignDate;
    }

    public DocumentType5 getDocumentType() {
        return documentType;
    }

    public void setDocumentType(DocumentType5 documentType) {
        this.documentType = documentType;
    }
}
