<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<html>
<head>
    <title>Thanh Toán COD</title>
</head>
<body>
    <div class="page-header checkout-heading">
        <div>
            <h1>Thanh Toán Đơn Hàng</h1>
            <p>Kiểm tra thông tin nhận hàng và xác nhận thanh toán khi nhận hàng.</p>
        </div>
        <a href="${pageContext.request.contextPath}/cart" class="btn-outline">Quay lại giỏ hàng</a>
    </div>

    <c:if test="${not empty checkoutError}">
        <div class="alert-danger"><c:out value="${checkoutError}"/></div>
    </c:if>

    <div class="checkout-layout">
        <form id="codCheckoutForm" action="${pageContext.request.contextPath}/checkout" method="post" class="checkout-form panel">
            <h2 class="checkout-section-title">Thông tin nhận hàng</h2>

            <div class="checkout-form-grid">
                <div class="form-group">
                    <label for="recipientName">Họ và tên người nhận</label>
                    <input type="text" id="recipientName" name="recipientName" class="form-control"
                           value="${fn:escapeXml(recipientName)}" minlength="2" maxlength="100" required>
                </div>
                <div class="form-group">
                    <label for="recipientPhone">Số điện thoại</label>
                    <input type="tel" id="recipientPhone" name="recipientPhone" class="form-control"
                           value="${fn:escapeXml(recipientPhone)}" minlength="9" maxlength="20" required>
                </div>
            </div>

            <div class="form-group">
                <label for="email">Email tài khoản</label>
                <input type="email" id="email" class="form-control" value="${fn:escapeXml(sessionScope.user.email)}" readonly>
            </div>

            <div class="form-group">
                <label for="shippingAddress">Địa chỉ giao hàng</label>
                <textarea id="shippingAddress" name="shippingAddress" class="form-control checkout-address"
                          minlength="10" maxlength="500" required>${fn:escapeXml(shippingAddress)}</textarea>
            </div>

            <div class="form-group">
                <label for="note">Ghi chú cho đơn hàng (không bắt buộc)</label>
                <textarea id="note" name="note" class="form-control" rows="3"
                          maxlength="500">${fn:escapeXml(note)}</textarea>
            </div>

            <h2 class="checkout-section-title">Phương thức thanh toán</h2>
            <label class="cod-option">
                <input type="radio" name="paymentMethod" value="COD" checked>
                <span class="cod-option-icon">💵</span>
                <span>
                    <strong>Thanh toán khi nhận hàng (COD)</strong>
                    <small>Bạn chỉ thanh toán sau khi đơn hàng được giao đến.</small>
                </span>
            </label>
        </form>

        <aside class="checkout-summary panel">
            <h2 class="checkout-section-title">Đơn hàng của bạn</h2>
            <div class="checkout-items">
                <c:forEach var="item" items="${sessionScope.cart.items}">
                    <div class="checkout-item">
                        <div>
                            <strong><c:out value="${item.book.title}"/></strong>
                            <small>Số lượng: ${item.quantity}</small>
                        </div>
                        <span>$<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
                    </div>
                </c:forEach>
            </div>
            <div class="checkout-total-row">
                <span>Tổng số lượng</span>
                <strong>${sessionScope.cart.itemCount} cuốn</strong>
            </div>
            <div class="checkout-total-row checkout-grand-total">
                <span>Tổng thanh toán</span>
                <strong>$<fmt:formatNumber value="${sessionScope.cart.total}" minFractionDigits="2" maxFractionDigits="2"/></strong>
            </div>
            <button type="submit" form="codCheckoutForm" class="btn-primary btn-block checkout-submit">
                Xác nhận đặt hàng COD
            </button>
            <p class="checkout-policy">Bằng việc đặt hàng, bạn xác nhận thông tin giao hàng là chính xác.</p>
        </aside>
    </div>

</body>
</html>
