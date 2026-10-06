package nguyen.vn.model;

public enum OrderStatus_24110288 {
    PENDING("Đơn hàng mới"),
    CONFIRMED("Đã xác nhận"),
    PREPARING("Chuẩn bị hàng"),
    SHIPPING("Vận chuyển"),
    DELIVERING("Giao hàng"),
    DELIVERED("Đã giao"),
    CANCELLED("Đơn hàng hủy"),
    RETURNED("Đơn hàng hoàn");

    private final String label;

    OrderStatus_24110288(String label) {
        this.label = label;
    }

    public String getCode() { return name(); }
    public String getLabel() { return label; }

    public static OrderStatus_24110288 fromFilter(String value) {
        return value == null || value.isBlank() ? null : valueOf(value);
    }
}
