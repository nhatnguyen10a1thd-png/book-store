package nguyen.vn.service;

import nguyen.vn.model.Cart_24110288;
import nguyen.vn.model.Order_24110288;
import nguyen.vn.repository.IOrderRepository_24110288;
import nguyen.vn.repository.OrderRepository_24110288;

public class CheckoutService_24110288 implements ICheckoutService_24110288 {
    private static final String PHONE_PATTERN = "^[0-9+][0-9 .-]{8,19}$";

    private final IOrderRepository_24110288 orderRepository = new OrderRepository_24110288();

    @Override
    public Order_24110288 placeCodOrder(
            int userId,
            Cart_24110288 cart,
            String recipientName,
            String recipientPhone,
            String shippingAddress,
            String note
    ) throws CheckoutException_24110288 {
        String normalizedName = normalize(recipientName);
        String normalizedPhone = normalize(recipientPhone);
        String normalizedAddress = normalize(shippingAddress);
        String normalizedNote = normalize(note);

        if (cart == null || cart.isEmpty()) {
            throw new CheckoutException_24110288("Giỏ hàng đang trống.");
        }
        if (normalizedName.length() < 2 || normalizedName.length() > 100) {
            throw new CheckoutException_24110288("Họ tên người nhận phải từ 2 đến 100 ký tự.");
        }
        if (!normalizedPhone.matches(PHONE_PATTERN)) {
            throw new CheckoutException_24110288("Số điện thoại nhận hàng không hợp lệ.");
        }
        if (normalizedAddress.length() < 10 || normalizedAddress.length() > 500) {
            throw new CheckoutException_24110288("Địa chỉ nhận hàng phải từ 10 đến 500 ký tự.");
        }
        if (normalizedNote.length() > 500) {
            throw new CheckoutException_24110288("Ghi chú không được vượt quá 500 ký tự.");
        }

        Order_24110288 order = new Order_24110288();
        order.setUserId(userId);
        order.setRecipientName(normalizedName);
        order.setRecipientPhone(normalizedPhone);
        order.setShippingAddress(normalizedAddress);
        order.setNote(normalizedNote);
        return orderRepository.createCodOrder(order, cart);
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }
}
