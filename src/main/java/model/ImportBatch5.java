package model;

import java.time.LocalDate;

public class ImportBatch5 {
    private int id;
    private LocalDate importDate;
    private int quantity;
    private Supplier5 supplier;
    private LibraryStaff5 libraryStaff;
    private DocumentTitle5 documentTitle;

    public ImportBatch5() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDate getImportDate() {
        return importDate;
    }

    public void setImportDate(LocalDate importDate) {
        this.importDate = importDate;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Supplier5 getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier5 supplier) {
        this.supplier = supplier;
    }

    public LibraryStaff5 getLibraryStaff() {
        return libraryStaff;
    }

    public void setLibraryStaff(LibraryStaff5 libraryStaff) {
        this.libraryStaff = libraryStaff;
    }

    public DocumentTitle5 getDocumentTitle() {
        return documentTitle;
    }

    public void setDocumentTitle(DocumentTitle5 documentTitle) {
        this.documentTitle = documentTitle;
    }
}
