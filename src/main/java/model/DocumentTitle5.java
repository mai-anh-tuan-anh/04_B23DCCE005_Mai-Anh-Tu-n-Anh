package model;

import java.time.LocalDate;

public class DocumentTitle5 {
    private int id;
    private String documentTitleCode;
    private String documentTitleName;
    private String author;
    private String publisher;
    private LocalDate publicationDate;
    private String description;
    private String shelfLocation;
    private TitleType5[] titleTypes;

    public DocumentTitle5() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDocumentTitleCode() {
        return documentTitleCode;
    }

    public void setDocumentTitleCode(String documentTitleCode) {
        this.documentTitleCode = documentTitleCode;
    }

    public String getDocumentTitleName() {
        return documentTitleName;
    }

    public void setDocumentTitleName(String documentTitleName) {
        this.documentTitleName = documentTitleName;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPublisher() {
        return publisher;
    }

    public void setPublisher(String publisher) {
        this.publisher = publisher;
    }

    public LocalDate getPublicationDate() {
        return publicationDate;
    }

    public void setPublicationDate(LocalDate publicationDate) {
        this.publicationDate = publicationDate;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getShelfLocation() {
        return shelfLocation;
    }

    public void setShelfLocation(String shelfLocation) {
        this.shelfLocation = shelfLocation;
    }

    public TitleType5[] getTitleTypes() {
        return titleTypes;
    }

    public void setTitleTypes(TitleType5[] titleTypes) {
        this.titleTypes = titleTypes;
    }
}
