package nguyen.vn.repository;

import nguyen.vn.model.CartItem_24110288;
import nguyen.vn.model.Cart_24110288;
import nguyen.vn.model.OrderItem_24110288;
import nguyen.vn.model.Order_24110288;
import nguyen.vn.service.CheckoutException_24110288;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class OrderRepository_24110288 implements IOrderRepository_24110288 {

    @Override
    public Order_24110288 createCodOrder(Order_24110288 order, Cart_24110288 cart)
            throws CheckoutException_24110288 {
        Connection connection = null;
        try {
            connection = DBContext_24110288.getConnection();
            connection.setAutoCommit(false);
            connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);

            List<OrderItem_24110288> orderItems = loadAndLockBooks(connection, cart);
            BigDecimal totalAmount = orderItems.stream()
                    .map(OrderItem_24110288::getSubtotal)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            order.setTotalAmount(totalAmount);
            int orderId = insertOrder(connection, order);
            updateInventory(connection, orderItems);
            insertOrderItems(connection, orderId, orderItems);

            connection.commit();

            order.setOrderId(orderId);
            order.setItems(orderItems);
            order.setPaymentMethod("COD");
            order.setPaymentStatus("UNPAID");
            order.setOrderStatus("PENDING");
            order.setCreatedAt(new Date());
            return order;
        } catch (CheckoutException_24110288 exception) {
            rollback(connection);
            throw exception;
        } catch (Exception exception) {
            rollback(connection);
            throw new CheckoutException_24110288(
                    "Không thể tạo đơn hàng COD. Vui lòng thử lại sau.", exception);
        } finally {
            close(connection);
        }
    }

    private List<OrderItem_24110288> loadAndLockBooks(Connection connection, Cart_24110288 cart)
            throws SQLException, CheckoutException_24110288 {
        String sql = "SELECT title, price, quantity FROM books "
                + "WITH (UPDLOCK, HOLDLOCK, ROWLOCK) WHERE bookid = ?";
        List<OrderItem_24110288> orderItems = new ArrayList<>();

        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            for (CartItem_24110288 cartItem : cart.getItems()) {
                int bookId = cartItem.getBook().getBookId();
                statement.setInt(1, bookId);
                try (ResultSet resultSet = statement.executeQuery()) {
                    if (!resultSet.next()) {
                        throw new CheckoutException_24110288(
                                "Sản phẩm “" + cartItem.getBook().getTitle() + "” không còn tồn tại.");
                    }

                    int stock = resultSet.getInt("quantity");
                    if (stock < cartItem.getQuantity()) {
                        throw new CheckoutException_24110288(
                                "Sản phẩm “" + cartItem.getBook().getTitle()
                                        + "” chỉ còn " + stock + " cuốn. Vui lòng cập nhật giỏ hàng.");
                    }

                    BigDecimal unitPrice = resultSet.getBigDecimal("price");
                    if (unitPrice == null) {
                        throw new CheckoutException_24110288(
                                "Sản phẩm “" + cartItem.getBook().getTitle() + "” chưa có giá bán.");
                    }

                    String title = resultSet.getString("title");
                    OrderItem_24110288 orderItem = new OrderItem_24110288();
                    orderItem.setBookId(bookId);
                    orderItem.setBookTitle(title == null || title.isBlank() ? "Sách #" + bookId : title);
                    orderItem.setUnitPrice(unitPrice);
                    orderItem.setQuantity(cartItem.getQuantity());
                    orderItem.setSubtotal(unitPrice.multiply(BigDecimal.valueOf(cartItem.getQuantity())));
                    orderItems.add(orderItem);
                }
            }
        }

        if (orderItems.isEmpty()) {
            throw new CheckoutException_24110288("Giỏ hàng đang trống.");
        }
        return orderItems;
    }

    private int insertOrder(Connection connection, Order_24110288 order)
            throws SQLException, CheckoutException_24110288 {
        String sql = "INSERT INTO orders "
                + "(user_id, recipient_name, recipient_phone, shipping_address, note, total_amount, "
                + "payment_method, payment_status, order_status) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'COD', 'UNPAID', 'PENDING')";

        try (PreparedStatement statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            statement.setInt(1, order.getUserId());
            statement.setString(2, order.getRecipientName());
            statement.setString(3, order.getRecipientPhone());
            statement.setString(4, order.getShippingAddress());
            if (order.getNote() == null || order.getNote().isBlank()) {
                statement.setNull(5, java.sql.Types.NVARCHAR);
            } else {
                statement.setString(5, order.getNote());
            }
            statement.setBigDecimal(6, order.getTotalAmount());

            if (statement.executeUpdate() == 0) {
                throw new CheckoutException_24110288("Không thể tạo đơn hàng.");
            }

            try (ResultSet generatedKeys = statement.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        }
        throw new CheckoutException_24110288("Không lấy được mã đơn hàng.");
    }

    private void updateInventory(Connection connection, List<OrderItem_24110288> orderItems)
            throws SQLException, CheckoutException_24110288 {
        String sql = "UPDATE books SET quantity = quantity - ? WHERE bookid = ? AND quantity >= ?";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            for (OrderItem_24110288 item : orderItems) {
                statement.setInt(1, item.getQuantity());
                statement.setInt(2, item.getBookId());
                statement.setInt(3, item.getQuantity());
                if (statement.executeUpdate() != 1) {
                    throw new CheckoutException_24110288(
                            "Tồn kho của “" + item.getBookTitle() + "” vừa thay đổi. Vui lòng thử lại.");
                }
            }
        }
    }

    private void insertOrderItems(Connection connection, int orderId, List<OrderItem_24110288> orderItems)
            throws SQLException {
        String sql = "INSERT INTO order_items "
                + "(order_id, book_id, book_title, unit_price, quantity, subtotal) VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            for (OrderItem_24110288 item : orderItems) {
                statement.setInt(1, orderId);
                statement.setInt(2, item.getBookId());
                statement.setString(3, item.getBookTitle());
                statement.setBigDecimal(4, item.getUnitPrice());
                statement.setInt(5, item.getQuantity());
                statement.setBigDecimal(6, item.getSubtotal());
                statement.addBatch();
            }
            statement.executeBatch();
        }
    }

    private void rollback(Connection connection) {
        if (connection != null) {
            try {
                connection.rollback();
            } catch (SQLException ignored) {
            }
        }
    }

    private void close(Connection connection) {
        if (connection != null) {
            try {
                connection.close();
            } catch (SQLException ignored) {
            }
        }
    }
}
