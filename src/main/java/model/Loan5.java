package model;

import java.time.LocalDate;
import java.math.BigDecimal;

public class Loan5 {
    private int id;
    private LocalDate returnDate;
    private BigDecimal fine;
    private DocumentCopy5 documentCopy;

    public Loan5() {}

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDate getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(LocalDate returnDate) {
        this.returnDate = returnDate;
    }

    public BigDecimal getFine() {
        return fine;
    }

    public void setFine(BigDecimal fine) {
        this.fine = fine;
    }

    public DocumentCopy5 getDocumentCopy() {
        return documentCopy;
    }

    public void setDocumentCopy(DocumentCopy5 documentCopy) {
        this.documentCopy = documentCopy;
    }
}
