package nguyen.vn.repository;

import nguyen.vn.model.Cart_24110288;
import nguyen.vn.model.Order_24110288;
import nguyen.vn.service.CheckoutException_24110288;

public interface IOrderRepository_24110288 {
    Order_24110288 createCodOrder(Order_24110288 order, Cart_24110288 cart)
            throws CheckoutException_24110288;
}
