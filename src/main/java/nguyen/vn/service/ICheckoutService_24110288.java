package nguyen.vn.service;

import nguyen.vn.model.Cart_24110288;
import nguyen.vn.model.Order_24110288;

public interface ICheckoutService_24110288 {
    Order_24110288 placeCodOrder(
            int userId,
            Cart_24110288 cart,
            String recipientName,
            String recipientPhone,
            String shippingAddress,
            String note
    ) throws CheckoutException_24110288;
}
