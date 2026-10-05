package nguyen.vn.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import nguyen.vn.model.Author_24110288;
import nguyen.vn.service.AuthorService_24110288;
import nguyen.vn.service.IAuthorService_24110288;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name = "AdminAuthorController_24110288", urlPatterns = {
    "/admin/authors", 
    "/admin/author-form", 
    "/admin/author-save", 
    "/admin/author-delete"
})
public class AdminAuthorController_24110288 extends HttpServlet {

    private final IAuthorService_24110288 authorService = new AuthorService_24110288();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();
        
        if ("/admin/author-form".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int authorId = Integer.parseInt(idParam);
                Author_24110288 author = authorService.getAuthorById(authorId);
                request.setAttribute("author", author);
            }
            request.getRequestDispatcher("/WEB-INF/views/admin/author-form.jsp").forward(request, response);
        } else if ("/admin/author-delete".equals(action)) {
            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                int authorId = Integer.parseInt(idParam);
                authorService.deleteAuthor(authorId);
            }
            response.sendRedirect(request.getContextPath() + "/admin/authors");
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

            List<Author_24110288> authors = authorService.getAuthorsByPage(page, limit);
            int totalAuthors = authorService.getTotalAuthors();
            int totalPages = (int) Math.ceil((double) totalAuthors / limit);

            request.setAttribute("authors", authors);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);

            request.getRequestDispatcher("/WEB-INF/views/admin/authors.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if ("/admin/author-save".equals(request.getServletPath())) {
            String idParam = request.getParameter("authorId");
            String authorName = request.getParameter("authorName");
            String dateStr = request.getParameter("dateOfBirth");
            
            Author_24110288 author = new Author_24110288();
            author.setAuthorName(authorName);
            
            try {
                if (dateStr != null && !dateStr.isEmpty()) {
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                    Date dob = sdf.parse(dateStr);
                    author.setDateOfBirth(dob);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            if (idParam != null && !idParam.isEmpty()) {
                author.setAuthorId(Integer.parseInt(idParam));
                authorService.updateAuthor(author);
            } else {
                authorService.addAuthor(author);
            }
            response.sendRedirect(request.getContextPath() + "/admin/authors");
        }
    }
}
