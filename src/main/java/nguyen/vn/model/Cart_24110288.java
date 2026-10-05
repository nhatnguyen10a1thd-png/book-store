package nguyen.vn.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

public class Cart_24110288 {
    private final Map<Integer, CartItem_24110288> itemMap = new LinkedHashMap<>();

    public void add(Book_24110288 book, int quantity) {
        CartItem_24110288 currentItem = itemMap.get(book.getBookId());
        int currentQuantity = currentItem == null ? 0 : currentItem.getQuantity();
        long requestedQuantity = (long) currentQuantity + quantity;
        int newQuantity = (int) Math.min(requestedQuantity, book.getQuantity());

        if (currentItem == null) {
            itemMap.put(book.getBookId(), new CartItem_24110288(book, newQuantity));
        } else {
            currentItem.setBook(book);
            currentItem.setQuantity(newQuantity);
        }
    }

    public void update(Book_24110288 book, int quantity) {
        CartItem_24110288 item = itemMap.get(book.getBookId());
        if (item != null) {
            item.setBook(book);
            item.setQuantity(Math.min(quantity, book.getQuantity()));
        }
    }

    public void remove(int bookId) {
        itemMap.remove(bookId);
    }

    public void clear() {
        itemMap.clear();
    }

    public CartItem_24110288 getItem(int bookId) {
        return itemMap.get(bookId);
    }

    public Collection<CartItem_24110288> getItems() {
        return new ArrayList<>(itemMap.values());
    }

    public long getItemCount() {
        return itemMap.values().stream()
                .mapToLong(CartItem_24110288::getQuantity)
                .sum();
    }

    public BigDecimal getTotal() {
        return itemMap.values().stream()
                .map(CartItem_24110288::getSubtotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
    }

    public boolean isEmpty() {
        return itemMap.isEmpty();
    }
}
