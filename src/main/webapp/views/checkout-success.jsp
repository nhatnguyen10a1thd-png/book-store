<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>Đặt Hàng Thành Công</title>
</head>
<body>
    <div class="order-success panel">
        <div class="order-success-icon">✓</div>
        <p class="order-success-label">ĐẶT HÀNG THÀNH CÔNG</p>
        <h1>Cảm ơn bạn đã đặt hàng!</h1>
        <p>Đơn hàng COD của bạn đã được tiếp nhận và đang chờ xác nhận.</p>

        <div class="order-code">
            <span>Mã đơn hàng</span>
            <strong>#${order.orderId}</strong>
        </div>

        <div class="order-success-details">
            <div>
                <span>Người nhận</span>
                <strong><c:out value="${order.recipientName}"/></strong>
            </div>
            <div>
                <span>Số điện thoại</span>
                <strong><c:out value="${order.recipientPhone}"/></strong>
            </div>
            <div>
                <span>Thanh toán</span>
                <strong>COD - Khi nhận hàng</strong>
            </div>
            <div>
                <span>Tổng tiền</span>
                <strong>$<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2" maxFractionDigits="2"/></strong>
            </div>
        </div>

        <div class="order-address">
            <span>Giao đến</span>
            <strong><c:out value="${order.shippingAddress}"/></strong>
        </div>

        <div class="order-success-actions">
            <a href="${pageContext.request.contextPath}/products" class="btn-primary">Tiếp tục mua sắm</a>
            <a href="${pageContext.request.contextPath}/home" class="btn-outline">Về trang chủ</a>
        </div>
    </div>
</body>
</html>
