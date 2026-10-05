package nguyen.vn.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import nguyen.vn.model.Cart_24110288;
import nguyen.vn.model.Order_24110288;
import nguyen.vn.model.User_24110288;
import nguyen.vn.service.CheckoutException_24110288;
import nguyen.vn.service.CheckoutService_24110288;
import nguyen.vn.service.ICheckoutService_24110288;

import java.io.IOException;

@WebServlet(
        name = "CheckoutController_24110288",
        urlPatterns = {"/checkout", "/checkout-success"}
)
public class CheckoutController_24110288 extends HttpServlet {
    private final ICheckoutService_24110288 checkoutService = new CheckoutService_24110288();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User_24110288 user = getCurrentUser(request, response);
        if (user == null) {
            return;
        }

        if ("/checkout-success".equals(request.getServletPath())) {
            showSuccess(request, response);
            return;
        }

        Cart_24110288 cart = (Cart_24110288) request.getSession().getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            request.getSession().setAttribute("cartMessage", "Giỏ hàng đang trống.");
            request.getSession().setAttribute("cartMessageType", "warning");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        request.setAttribute("recipientName", user.getFullname());
        request.setAttribute("recipientPhone", user.getPhone());
        request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User_24110288 user = getCurrentUser(request, response);
        if (user == null) {
            return;
        }

        HttpSession session = request.getSession();
        Cart_24110288 cart = (Cart_24110288) session.getAttribute("cart");
        String recipientName = request.getParameter("recipientName");
        String recipientPhone = request.getParameter("recipientPhone");
        String shippingAddress = request.getParameter("shippingAddress");
        String note = request.getParameter("note");

        if (cart == null || cart.isEmpty()) {
            session.setAttribute("cartMessage", "Giỏ hàng đang trống.");
            session.setAttribute("cartMessageType", "warning");
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        try {
            Order_24110288 order;
            synchronized (cart) {
                order = checkoutService.placeCodOrder(
                        user.getId(), cart, recipientName, recipientPhone, shippingAddress, note);
                cart.clear();
            }
            session.setAttribute("lastOrder", order);
            response.sendRedirect(request.getContextPath() + "/checkout-success");
        } catch (CheckoutException_24110288 exception) {
            request.setAttribute("checkoutError", exception.getMessage());
            request.setAttribute("recipientName", recipientName);
            request.setAttribute("recipientPhone", recipientPhone);
            request.setAttribute("shippingAddress", shippingAddress);
            request.setAttribute("note", note);
            request.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(request, response);
        }
    }

    private User_24110288 getCurrentUser(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        User_24110288 user = session == null ? null : (User_24110288) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login?redirect=/checkout");
        }
        return user;
    }

    private void showSuccess(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Order_24110288 order = (Order_24110288) request.getSession().getAttribute("lastOrder");
        if (order == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        request.setAttribute("order", order);
        request.getRequestDispatcher("/WEB-INF/views/checkout-success.jsp").forward(request, response);
    }
}
