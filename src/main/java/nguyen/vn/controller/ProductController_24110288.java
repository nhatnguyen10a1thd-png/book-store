package nguyen.vn.controller;

import nguyen.vn.service.BookService_24110288;
import nguyen.vn.service.IBookService_24110288;
import nguyen.vn.model.Book_24110288;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ProductController_24110288", urlPatterns = {"/products"})
public class ProductController_24110288 extends HttpServlet {

    private final IBookService_24110288 bookService = new BookService_24110288();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Book_24110288> books = bookService.getAllBooks();
        request.setAttribute("books", books);
        request.getRequestDispatcher("/views/products.jsp").forward(request, response);
    }
}
