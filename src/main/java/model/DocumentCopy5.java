package model;

public class DocumentCopy5 {
    private int id;
    private String documentCopyCode;
    private String documentCopyStatus;
    private String documentCopyCondition;
    private DocumentTitle5 documentTitle;

    public DocumentCopy5() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getDocumentCopyCode() {
        return documentCopyCode;
    }

    public void setDocumentCopyCode(String documentCopyCode) {
        this.documentCopyCode = documentCopyCode;
    }

    public String getDocumentCopyStatus() {
        return documentCopyStatus;
    }

    public void setDocumentCopyStatus(String documentCopyStatus) {
        this.documentCopyStatus = documentCopyStatus;
    }

    public String getDocumentCopyCondition() {
        return documentCopyCondition;
    }

    public void setDocumentCopyCondition(String documentCopyCondition) {
        this.documentCopyCondition = documentCopyCondition;
    }

    public DocumentTitle5 getDocumentTitle() {
        return documentTitle;
    }

    public void setDocumentTitle(DocumentTitle5 documentTitle) {
        this.documentTitle = documentTitle;
    }
}
