package nguyen.vn.repository;

import nguyen.vn.model.Book_24110288;
import java.util.List;

public interface IBookRepository_24110288 {
    List<Book_24110288> getAllBooks();
    Book_24110288 getBookById(int bookId);
    List<Book_24110288> getBooksByPage(int offset, int limit);
    int getTotalBooks();
    boolean addBook(Book_24110288 book);
    boolean updateBook(Book_24110288 book);
    boolean deleteBook(int bookId);
}
