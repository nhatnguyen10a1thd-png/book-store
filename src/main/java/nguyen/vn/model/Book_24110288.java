package nguyen.vn.model;

import java.math.BigDecimal;
import java.util.Date;

public class Book_24110288 {
    private int bookId;
    private String isbn;
    private String title;
    private String publisher;
    private BigDecimal price;
    private String description;
    private Date publishDate;
    private String coverImage;
    private int quantity;
    private String authorNames;
    private int reviewCount;
    private int[] authorIds;

    public Book_24110288() {
    }

    public Book_24110288(int bookId, String isbn, String title, String publisher, BigDecimal price, String description, Date publishDate, String coverImage, int quantity) {
        this.bookId = bookId;
        this.isbn = isbn;
        this.title = title;
        this.publisher = publisher;
        this.price = price;
        this.description = description;
        this.publishDate = publishDate;
        this.coverImage = coverImage;
        this.quantity = quantity;
    }

    public Book_24110288(int bookId, String isbn, String title, String publisher, BigDecimal price, String description, Date publishDate, String coverImage, int quantity, String authorNames, int reviewCount) {
        this.bookId = bookId;
        this.isbn = isbn;
        this.title = title;
        this.publisher = publisher;
        this.price = price;
        this.description = description;
        this.publishDate = publishDate;
        this.coverImage = coverImage;
        this.quantity = quantity;
        this.authorNames = authorNames;
        this.reviewCount = reviewCount;
    }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getPublisher() { return publisher; }
    public void setPublisher(String publisher) { this.publisher = publisher; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Date getPublishDate() { return publishDate; }
    public void setPublishDate(Date publishDate) { this.publishDate = publishDate; }

    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getAuthorNames() { return authorNames; }
    public void setAuthorNames(String authorNames) { this.authorNames = authorNames; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    public int[] getAuthorIds() { return authorIds; }
    public void setAuthorIds(int[] authorIds) { this.authorIds = authorIds; }
}
