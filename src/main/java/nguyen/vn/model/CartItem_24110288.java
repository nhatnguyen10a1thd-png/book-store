package nguyen.vn.model;

import java.math.BigDecimal;

public class CartItem_24110288 {
    private Book_24110288 book;
    private int quantity;

    public CartItem_24110288(Book_24110288 book, int quantity) {
        this.book = book;
        this.quantity = quantity;
    }

    public Book_24110288 getBook() {
        return book;
    }

    public void setBook(Book_24110288 book) {
        this.book = book;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getSubtotal() {
        if (book.getPrice() == null) {
            return BigDecimal.ZERO;
        }
        return book.getPrice().multiply(BigDecimal.valueOf(quantity));
    }
}
