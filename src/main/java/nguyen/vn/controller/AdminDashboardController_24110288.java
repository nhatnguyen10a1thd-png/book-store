package nguyen.vn.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import nguyen.vn.model.Book_24110288;
import nguyen.vn.service.AuthorService_24110288;
import nguyen.vn.service.BookService_24110288;
import nguyen.vn.service.IAuthorService_24110288;
import nguyen.vn.service.IBookService_24110288;

import java.io.IOException;
import java.util.Collections;
import java.util.List;

@WebServlet(name = "AdminDashboardController_24110288", urlPatterns = {"/admin/dashboard"})
public class AdminDashboardController_24110288 extends HttpServlet {

    private final IBookService_24110288 bookService = new BookService_24110288();
    private final IAuthorService_24110288 authorService = new AuthorService_24110288();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Book_24110288> allBooks = bookService.getAllBooks();
        if (allBooks == null) {
            allBooks = Collections.emptyList();
        }

        int totalBooks = allBooks.size();
        int totalAuthors = authorService.getTotalAuthors();
        long totalInventory = allBooks.stream().mapToLong(Book_24110288::getQuantity).sum();
        long outOfStockCount = allBooks.stream().filter(b -> b.getQuantity() <= 0).count();
        List<Book_24110288> lowStockBooks = allBooks.stream()
                .filter(b -> b.getQuantity() <= 5)
                .toList();

        double averagePrice = allBooks.stream()
                .filter(b -> b.getPrice() != null)
                .mapToDouble(b -> b.getPrice().doubleValue())
                .average()
                .orElse(0.0);

        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("totalAuthors", totalAuthors);
        request.setAttribute("totalInventory", totalInventory);
        request.setAttribute("outOfStockCount", outOfStockCount);
        request.setAttribute("lowStockBooks", lowStockBooks);
        request.setAttribute("averagePrice", averagePrice);

        request.getRequestDispatcher("/WEB-INF/views/admin/dashboard.jsp").forward(request, response);
    }
}

