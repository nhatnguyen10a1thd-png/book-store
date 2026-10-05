package nguyen.vn.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import nguyen.vn.model.Book_24110288;
import nguyen.vn.model.Rating_24110288;
import nguyen.vn.model.User_24110288;
import nguyen.vn.service.BookService_24110288;
import nguyen.vn.service.IBookService_24110288;
import nguyen.vn.repository.IRatingRepository_24110288;
import nguyen.vn.repository.RatingRepository_24110288;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "BookDetailController_24110288", urlPatterns = {"/book"})
public class BookDetailController_24110288 extends HttpServlet {

    private final IBookService_24110288 bookService = new BookService_24110288();
    private final IRatingRepository_24110288 ratingRepository = new RatingRepository_24110288();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            int bookId = Integer.parseInt(idParam);
            Book_24110288 book = bookService.getBookById(bookId);
            if (book == null) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            List<Rating_24110288> reviews = ratingRepository.getRatingsByBookId(bookId);
            double averageRating = reviews.stream()
                    .mapToInt(Rating_24110288::getRating)
                    .average()
                    .orElse(0);
            
            request.setAttribute("book", book);
            request.setAttribute("reviews", reviews);
            request.setAttribute("averageRating", averageRating);
            request.getRequestDispatcher("/WEB-INF/views/book-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User_24110288 user = (User_24110288) session.getAttribute("user");
        
        String bookIdParam = request.getParameter("bookId");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/book?id=" + bookIdParam);
            return;
        }
        
        String reviewText = request.getParameter("reviewText");
        String ratingParam = request.getParameter("rating");
        
        if (bookIdParam != null && !bookIdParam.isEmpty()
                && ratingParam != null && !ratingParam.isEmpty()
                && reviewText != null && !reviewText.trim().isEmpty()) {
            try {
                int bookId = Integer.parseInt(bookIdParam);
                int ratingValue = Integer.parseInt(ratingParam);
                if (ratingValue < 1 || ratingValue > 5) {
                    response.sendRedirect(request.getContextPath() + "/book?id=" + bookId);
                    return;
                }
                Rating_24110288 rating = new Rating_24110288();
                rating.setBookId(bookId);
                rating.setUserId(user.getId());
                rating.setRating(ratingValue);
                rating.setReviewText(reviewText);
                
                ratingRepository.addRating(rating);
                
                response.sendRedirect(request.getContextPath() + "/book?id=" + bookId);
                return;
            } catch (NumberFormatException ignored) {
            }
        }
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
