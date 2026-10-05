package nguyen.vn.filter;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;

public class EncodingFilter_24110288 implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpServletRequest req = (HttpServletRequest) request;
        String path = req.getRequestURI();
        if (!path.contains("/assets/")) {
            response.setContentType("text/html; charset=UTF-8");
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
