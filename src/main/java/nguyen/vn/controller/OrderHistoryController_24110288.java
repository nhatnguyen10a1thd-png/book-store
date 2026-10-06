package nguyen.vn.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import nguyen.vn.model.OrderStatus_24110288;
import nguyen.vn.model.User_24110288;
import nguyen.vn.service.IOrderHistoryService_24110288;
import nguyen.vn.service.OrderHistoryService_24110288;
import nguyen.vn.service.OrderHistoryException_24110288;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "OrderHistoryController_24110288", urlPatterns = "/orders")
public class OrderHistoryController_24110288 extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(OrderHistoryController_24110288.class.getName());
    private final IOrderHistoryService_24110288 orderHistoryService;

    public OrderHistoryController_24110288() {
        this(new OrderHistoryService_24110288());
    }

    OrderHistoryController_24110288(IOrderHistoryService_24110288 orderHistoryService) {
        this.orderHistoryService = orderHistoryService;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setHeader("Cache-Control", "no-store");
        HttpSession session = request.getSession(false);
        User_24110288 user = session == null ? null : (User_24110288) session.getAttribute("user");
        if (user == null) {
            String redirect = "/orders";
            try {
                OrderStatus_24110288 status = OrderStatus_24110288.fromFilter(request.getParameter("status"));
                if (status != null) {
                    redirect += "?status=" + status.getCode();
                }
            } catch (IllegalArgumentException ignored) {
                // Only preserve known filters across login.
            }
            response.sendRedirect(request.getContextPath() + "/login?redirect="
                    + URLEncoder.encode(redirect, StandardCharsets.UTF_8));
            return;
        }

        OrderStatus_24110288 status;
        try {
            status = OrderStatus_24110288.fromFilter(request.getParameter("status"));
        } catch (IllegalArgumentException exception) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Trạng thái đơn hàng không hợp lệ.");
            return;
        }
        request.setAttribute("statuses", OrderStatus_24110288.values());
        request.setAttribute("selectedStatus", status == null ? "" : status.getCode());
        request.setAttribute("selectedStatusLabel", status == null ? "Tất cả" : status.getLabel());
        try {
            request.setAttribute("orders", orderHistoryService.getOrders(user.getId(), status));
        } catch (OrderHistoryException_24110288 exception) {
            LOGGER.log(Level.SEVERE, "Unable to load order history", exception);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            request.setAttribute("historyError", "Không thể tải lịch sử đặt hàng. Vui lòng thử lại sau.");
        }
        request.getRequestDispatcher("/WEB-INF/views/orders.jsp").forward(request, response);
    }
}
