package nguyen.vn.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import nguyen.vn.model.Book_24110288;
import nguyen.vn.model.Author_24110288;
import nguyen.vn.service.BookService_24110288;
import nguyen.vn.service.IBookService_24110288;
import nguyen.vn.service.AuthorService_24110288;
import nguyen.vn.service.IAuthorService_24110288;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "AdminBookController_24110288", urlPatterns = {
    "/admin/books", 
    "/admin/book-form", 
    "/admin/book-save", 
    "/admin/book-delete"
})
public class AdminBookController_24110288 extends HttpServlet {

    private final IBookService_24110288 bookService = new BookService_24110288();
    private final IAuthorService_24110288 authorService = new AuthorService_24110288();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        
        if ("/admin/book-form".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int bookId = Integer.parseInt(idParam);
                Book_24110288 book = bookService.getBookById(bookId);
                request.setAttribute("book", book);
            }
            
            // load authors for selection
            List<Author_24110288> allAuthors = authorService.getAllAuthors();
            request.setAttribute("authors", allAuthors);
            
            request.getRequestDispatcher("/WEB-INF/views/admin/book-form.jsp").forward(request, response);
        } else if ("/admin/book-delete".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int bookId = Integer.parseInt(idParam);
                bookService.deleteBook(bookId);
            }
            response.sendRedirect(request.getContextPath() + "/admin/books");
        } else {
            // list
            int page = 1;
            int limit = 6;
            String pageParam = request.getParameter("page");
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }

            List<Book_24110288> books = bookService.getBooksByPage(page, limit);
            int totalBooks = bookService.getTotalBooks();
            int totalPages = (int) Math.ceil((double) totalBooks / limit);

            request.setAttribute("books", books);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/WEB-INF/views/admin/books.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if ("/admin/book-save".equals(request.getServletPath())) {
            String idParam = request.getParameter("bookId");
            
            Book_24110288 book = new Book_24110288();
            book.setIsbn(request.getParameter("isbn"));
            book.setTitle(request.getParameter("title"));
            book.setPublisher(request.getParameter("publisher"));
            
            try {
                book.setPrice(new BigDecimal(request.getParameter("price")));
                book.setQuantity(Integer.parseInt(request.getParameter("quantity")));
            } catch (Exception e) {}

            book.setDescription(request.getParameter("description"));
            book.setCoverImage(request.getParameter("coverImage"));
            
            String dateStr = request.getParameter("publishDate");
            try {
                if (dateStr != null && !dateStr.isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date pubDate = sdf.parse(dateStr);
                    book.setPublishDate(pubDate);
                }
            } catch (Exception e) {}
            
            String[] authorIdParams = request.getParameterValues("authorIds");
            if (authorIdParams != null) {
                int[] authorIds = new int[authorIdParams.length];
                for (int i = 0; i < authorIdParams.length; i++) {
                    authorIds[i] = Integer.parseInt(authorIdParams[i]);
                }
                book.setAuthorIds(authorIds);
            }

            if (idParam != null && !idParam.isEmpty()) {
                book.setBookId(Integer.parseInt(idParam));
                bookService.updateBook(book);
            } else {
                bookService.addBook(book);
            }
            
            response.sendRedirect(request.getContextPath() + "/admin/books");
        }
    }
}
