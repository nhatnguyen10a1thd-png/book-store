package nguyen.vn.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "HomeController_24110288", urlPatterns = {"/home", ""})
public class HomeController_24110288 extends HttpServlet {

    private nguyen.vn.service.IBookService_24110288 bookService = new nguyen.vn.service.BookService_24110288();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
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
        
        java.util.List<nguyen.vn.model.Book_24110288> books = bookService.getBooksByPage(page, limit);
        int totalBooks = bookService.getTotalBooks();
        int totalPages = (int) Math.ceil((double) totalBooks / limit);
        
        request.setAttribute("books", books);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }
}
