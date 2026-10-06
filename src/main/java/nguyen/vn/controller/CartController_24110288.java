package nguyen.vn.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import nguyen.vn.model.Book_24110288;
import nguyen.vn.model.CartItem_24110288;
import nguyen.vn.model.Cart_24110288;
import nguyen.vn.service.BookService_24110288;
import nguyen.vn.service.IBookService_24110288;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "CartController_24110288", urlPatterns = {"/cart"})
public class CartController_24110288 extends HttpServlet {

    private final IBookService_24110288 bookService = new BookService_24110288();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Cart_24110288 cart = getCart(session);

        synchronized (cart) {
            refreshCart(cart);
        }

        moveFlashMessage(session, request);
        request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession();
        Cart_24110288 cart = getCart(session);
        String action = request.getParameter("action");
        String redirectPath = "add".equals(action)
                ? getSafeReturnUrl(request.getParameter("returnUrl"))
                : "/cart";

        if ("clear".equals(action)) {
            synchronized (cart) {
                cart.clear();
            }
            respond(request, response, cart, redirectPath, "Đã xóa toàn bộ sản phẩm khỏi giỏ hàng.", "success", true);
            return;
        }

        Integer bookId = parsePositiveInt(request.getParameter("bookId"));
        if (bookId == null) {
            respond(request, response, cart, redirectPath, "Sản phẩm không hợp lệ.", "danger", false);
            return;
        }

        if ("remove".equals(action)) {
            synchronized (cart) {
                cart.remove(bookId);
            }
            respond(request, response, cart, redirectPath, "Đã xóa sản phẩm khỏi giỏ hàng.", "success", true);
            return;
        }

        Book_24110288 book = bookService.getBookById(bookId);
        if (book == null) {
            synchronized (cart) {
                cart.remove(bookId);
            }
            respond(request, response, cart, redirectPath, "Sản phẩm không còn tồn tại.", "danger", false);
            return;
        }

        if (book.getQuantity() <= 0) {
            synchronized (cart) {
                cart.remove(bookId);
            }
            respond(request, response, cart, redirectPath, "Sản phẩm đã hết hàng.", "danger", false);
            return;
        }

        Integer quantity = parsePositiveInt(request.getParameter("quantity"));
        if (quantity == null) {
            respond(request, response, cart, redirectPath, "Số lượng phải là số nguyên từ 1 trở lên.", "danger", false);
            return;
        }

        synchronized (cart) {
            if ("update".equals(action)) {
                if (cart.getItem(bookId) == null) {
                    respond(request, response, cart, redirectPath, "Sản phẩm không có trong giỏ hàng.", "danger", false);
                } else {
                    cart.update(book, quantity);
                    String[] msgInfo = resolveQuantityMessage(quantity, book.getQuantity(), "Đã cập nhật số lượng.");
                    respond(request, response, cart, redirectPath, msgInfo[0], msgInfo[1], true);
                }
            } else if ("add".equals(action)) {
                CartItem_24110288 currentItem = cart.getItem(bookId);
                long requestedTotal = (long) quantity + (currentItem == null ? 0 : currentItem.getQuantity());
                cart.add(book, quantity);
                String[] msgInfo = resolveQuantityMessage(requestedTotal, book.getQuantity(), "Đã thêm sản phẩm vào giỏ hàng.");
                respond(request, response, cart, redirectPath, msgInfo[0], msgInfo[1], true);
            } else {
                respond(request, response, cart, redirectPath, "Thao tác giỏ hàng không hợp lệ.", "danger", false);
            }
        }
    }

    private void respond(HttpServletRequest request, HttpServletResponse response, Cart_24110288 cart,
                         String redirectPath, String message, String type, boolean success) throws IOException {
        boolean isAjax = "XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))
                || (request.getHeader("Accept") != null && request.getHeader("Accept").contains("application/json"))
                || "json".equalsIgnoreCase(request.getParameter("format"));

        if (isAjax) {
            response.setContentType("application/json;charset=UTF-8");
            String safeMsg = escapeJson(message);
            String safeType = escapeJson(type);
            String totalStr = cart.getTotal() != null ? cart.getTotal().toString() : "0.00";
            String json = "{\"success\":" + success
                    + ",\"message\":\"" + safeMsg + "\""
                    + ",\"type\":\"" + safeType + "\""
                    + ",\"itemCount\":" + cart.getItemCount()
                    + ",\"total\":" + totalStr + "}";
            response.getWriter().write(json);
        } else {
            setFlashMessage(request.getSession(), message, type);
            redirect(request, response, redirectPath);
        }
    }

    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\r", "\\r")
                    .replace("\n", "\\n");
    }

    private String[] resolveQuantityMessage(long requestedQuantity, int stock, String successMessage) {
        if (requestedQuantity > stock) {
            return new String[]{"Số lượng tối đa hiện có là " + stock + ". Giỏ hàng đã được điều chỉnh.", "warning"};
        } else {
            return new String[]{successMessage, "success"};
        }
    }

    private Cart_24110288 getCart(HttpSession session) {
        Cart_24110288 cart = (Cart_24110288) session.getAttribute("cart");
        if (cart == null) {
            cart = new Cart_24110288();
            session.setAttribute("cart", cart);
        }
        return cart;
    }

    private void refreshCart(Cart_24110288 cart) {
        for (CartItem_24110288 item : new ArrayList<>(cart.getItems())) {
            Book_24110288 currentBook = bookService.getBookById(item.getBook().getBookId());
            if (currentBook == null || currentBook.getQuantity() <= 0) {
                cart.remove(item.getBook().getBookId());
            } else {
                cart.update(currentBook, item.getQuantity());
            }
        }
    }

    private Integer parsePositiveInt(String value) {
        try {
            int number = Integer.parseInt(value);
            return number > 0 ? number : null;
        } catch (NumberFormatException | NullPointerException exception) {
            return null;
        }
    }

    private void setQuantityMessage(HttpSession session, long requestedQuantity, int stock, String successMessage) {
        if (requestedQuantity > stock) {
            setFlashMessage(session, "Số lượng tối đa hiện có là " + stock + ". Giỏ hàng đã được điều chỉnh.", "warning");
        } else {
            setFlashMessage(session, successMessage, "success");
        }
    }

    private void setFlashMessage(HttpSession session, String message, String type) {
        session.setAttribute("cartMessage", message);
        session.setAttribute("cartMessageType", type);
    }

    private void moveFlashMessage(HttpSession session, HttpServletRequest request) {
        Object message = session.getAttribute("cartMessage");
        Object type = session.getAttribute("cartMessageType");
        if (message != null) {
            request.setAttribute("cartMessage", message);
            request.setAttribute("cartMessageType", type);
            session.removeAttribute("cartMessage");
            session.removeAttribute("cartMessageType");
        }
    }

    private String getSafeReturnUrl(String returnUrl) {
        if (returnUrl == null
                || !returnUrl.startsWith("/")
                || returnUrl.startsWith("//")
                || returnUrl.contains("\\")
                || returnUrl.contains("\r")
                || returnUrl.contains("\n")
                || returnUrl.contains("://")) {
            return "/products";
        }
        return returnUrl;
    }

    private void redirect(HttpServletRequest request, HttpServletResponse response, String path) throws IOException {
        response.sendRedirect(request.getContextPath() + path);
    }
}
