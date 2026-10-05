package nguyen.vn.filter;

import nguyen.vn.model.User_24110288;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebFilter(filterName = "AdminFilter_24110288", urlPatterns = {"/admin/*"})
public class AdminFilter_24110288 implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        HttpSession session = request.getSession(false);
        if (session != null) {
            User_24110288 user = (User_24110288) session.getAttribute("user");
            if (user != null && user.isAdmin()) {
                chain.doFilter(servletRequest, servletResponse);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/login");
    }

    @Override
    public void destroy() {
    }
}
