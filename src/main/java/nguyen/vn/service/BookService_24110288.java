package nguyen.vn.service;

import nguyen.vn.repository.BookRepository_24110288;
import nguyen.vn.repository.IBookRepository_24110288;
import nguyen.vn.model.Book_24110288;

import java.util.List;

public class BookService_24110288 implements IBookService_24110288 {

    private final IBookRepository_24110288 bookRepository = new BookRepository_24110288();

    @Override
    public List<Book_24110288> getAllBooks() {
        return bookRepository.getAllBooks();
    }

    @Override
    public Book_24110288 getBookById(int bookId) {
        return bookRepository.getBookById(bookId);
    }

    @Override
    public List<Book_24110288> getBooksByPage(int page, int limit) {
        int offset = (page - 1) * limit;
        return bookRepository.getBooksByPage(offset, limit);
    }

    @Override
    public int getTotalBooks() {
        return bookRepository.getTotalBooks();
    }

    @Override
    public boolean addBook(Book_24110288 book) {
        return bookRepository.addBook(book);
    }

    @Override
    public boolean updateBook(Book_24110288 book) {
        return bookRepository.updateBook(book);
    }

    @Override
    public boolean deleteBook(int bookId) {
        return bookRepository.deleteBook(bookId);
    }
}
