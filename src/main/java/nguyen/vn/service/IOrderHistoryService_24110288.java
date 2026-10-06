package nguyen.vn.service;

import nguyen.vn.model.Order_24110288;
import nguyen.vn.model.OrderStatus_24110288;
import java.util.List;

public interface IOrderHistoryService_24110288 {
    List<Order_24110288> getOrders(int userId, OrderStatus_24110288 status)
            throws OrderHistoryException_24110288;
}
