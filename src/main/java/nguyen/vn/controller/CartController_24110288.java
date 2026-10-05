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
        request.getRequestDispatcher("/views/cart.jsp").forward(request, response);
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
            setFlashMessage(session, "Đã xóa toàn bộ sản phẩm khỏi giỏ hàng.", "success");
            redirect(request, response, redirectPath);
            return;
        }

        Integer bookId = parsePositiveInt(request.getParameter("bookId"));
        if (bookId == null) {
            setFlashMessage(session, "Sản phẩm không hợp lệ.", "danger");
            redirect(request, response, redirectPath);
            return;
        }

        if ("remove".equals(action)) {
            synchronized (cart) {
                cart.remove(bookId);
            }
            setFlashMessage(session, "Đã xóa sản phẩm khỏi giỏ hàng.", "success");
            redirect(request, response, redirectPath);
            return;
        }

        Book_24110288 book = bookService.getBookById(bookId);
        if (book == null) {
            synchronized (cart) {
                cart.remove(bookId);
            }
            setFlashMessage(session, "Sản phẩm không còn tồn tại.", "danger");
            redirect(request, response, redirectPath);
            return;
        }

        if (book.getQuantity() <= 0) {
            synchronized (cart) {
                cart.remove(bookId);
            }
            setFlashMessage(session, "Sản phẩm đã hết hàng.", "danger");
            redirect(request, response, redirectPath);
            return;
        }

        Integer quantity = parsePositiveInt(request.getParameter("quantity"));
        if (quantity == null) {
            setFlashMessage(session, "Số lượng phải là số nguyên từ 1 trở lên.", "danger");
            redirect(request, response, redirectPath);
            return;
        }

        synchronized (cart) {
            if ("update".equals(action)) {
                if (cart.getItem(bookId) == null) {
                    setFlashMessage(session, "Sản phẩm không có trong giỏ hàng.", "danger");
                } else {
                    cart.update(book, quantity);
                    setQuantityMessage(session, quantity, book.getQuantity(), "Đã cập nhật số lượng.");
                }
            } else if ("add".equals(action)) {
                CartItem_24110288 currentItem = cart.getItem(bookId);
                long requestedTotal = (long) quantity + (currentItem == null ? 0 : currentItem.getQuantity());
                cart.add(book, quantity);
                setQuantityMessage(session, requestedTotal, book.getQuantity(), "Đã thêm sản phẩm vào giỏ hàng.");
            } else {
                setFlashMessage(session, "Thao tác giỏ hàng không hợp lệ.", "danger");
            }
        }

        redirect(request, response, redirectPath);
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
