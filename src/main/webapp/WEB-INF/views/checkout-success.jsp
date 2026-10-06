<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>Đơn Hàng Ghi Nhận — BookStore Tri Thức</title>
</head>
<body>
    <div class="success-receipt-card">
        <div class="success-seal-icon" aria-hidden="true">✓</div>

        <div class="success-header-text">
            <span class="eyebrow">Xác Nhận Thành Công</span>
            <h1>Đơn Hàng Đã Được Ghi Nhận</h1>
            <p>Cảm ơn quý độc giả. Đơn hàng thanh toán khi nhận hàng (COD) đã được ghi nhận trong hệ thống.</p>
        </div>

        <div class="success-order-token">
            <span>Mã Tra Cứu Đơn Sách</span>
            <strong>#${order.orderId}</strong>
        </div>

        <div class="success-details-grid">
            <div class="success-detail-row">
                <span>Người nhận sách</span>
                <strong><c:out value="${order.recipientName}"/></strong>
            </div>
            <div class="success-detail-row">
                <span>Điện thoại liên hệ</span>
                <strong><c:out value="${order.recipientPhone}"/></strong>
            </div>
            <div class="success-detail-row">
                <span>Hình thức thanh toán</span>
                <strong>COD • Thanh toán khi nhận hàng</strong>
            </div>
            <div class="success-detail-row">
                <span>Tổng giá trị đơn</span>
                <strong style="color: var(--burgundy); font-family: var(--font-serif); font-size: 1.15rem;">
                    $<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2" maxFractionDigits="2"/>
                </strong>
            </div>
        </div>

        <div class="success-address-row">
            <span>Địa chỉ giao nhận ấn phẩm:</span>
            <strong><c:out value="${order.shippingAddress}"/></strong>
        </div>

        <div class="success-actions-row">
            <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline">
                Xem Lịch Sử Đặt Hàng
            </a>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                Tiếp Tục Khám Phá Sách
            </a>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline">
                Quay Lại Trang Chủ
            </a>
        </div>
    </div>
</body>
</html>
