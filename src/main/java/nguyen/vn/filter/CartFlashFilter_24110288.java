package nguyen.vn.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter(
        filterName = "CartFlashFilter_24110288",
        urlPatterns = {"/home", "/products", "/book", "/cart"}
)
public class CartFlashFilter_24110288 implements Filter {

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;

        if ("GET".equalsIgnoreCase(request.getMethod())) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                Object message = session.getAttribute("cartMessage");
                Object type = session.getAttribute("cartMessageType");
                if (message != null) {
                    request.setAttribute("cartMessage", message);
                    request.setAttribute("cartMessageType", type);
                    session.removeAttribute("cartMessage");
                    session.removeAttribute("cartMessageType");
                }
            }
        }

        chain.doFilter(servletRequest, servletResponse);
    }
}
