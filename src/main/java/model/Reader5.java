package model;

public class Reader5 extends Member5 {
    private String readerCode;
    private ReaderCard5 readerCard;

    public Reader5() {}

    public String getReaderCode() {
        return readerCode;
    }

    public void setReaderCode(String readerCode) {
        this.readerCode = readerCode;
    }

    public ReaderCard5 getReaderCard() {
        return readerCard;
    }

    public void setReaderCard(ReaderCard5 readerCard) {
        this.readerCard = readerCard;
    }
}
