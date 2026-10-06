package nguyen.vn.service;

import nguyen.vn.model.Order_24110288;
import nguyen.vn.model.OrderStatus_24110288;
import nguyen.vn.repository.IOrderRepository_24110288;
import nguyen.vn.repository.OrderRepository_24110288;
import java.util.List;

public class OrderHistoryService_24110288 implements IOrderHistoryService_24110288 {
    private final IOrderRepository_24110288 orderRepository = new OrderRepository_24110288();

    @Override
    public List<Order_24110288> getOrders(int userId, OrderStatus_24110288 status)
            throws OrderHistoryException_24110288 {
        return orderRepository.findByUserIdAndStatus(userId, status);
    }
}
