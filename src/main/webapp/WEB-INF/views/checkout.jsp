<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<html>
<head>
    <title>Xác Nhận Đơn Hàng COD — BookStore Tri Thức</title>
</head>
<body>
    <div class="page-header" style="margin-bottom: 32px; display: flex; justify-content: space-between; align-items: flex-end;">
        <div>
            <span class="eyebrow">Thủ Tục Đặt Sách</span>
            <h1>Xác Nhận Thông Tin &amp; Giao Hàng</h1>
            <p style="margin: 0; color: var(--muted);">Thanh toán trực tiếp bằng tiền mặt khi nhận sách tận nơi (COD).</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/cart" class="btn btn-outline btn-small">
                &larr; Quay lại giỏ hàng
            </a>
        </div>
    </div>

    <c:if test="${not empty checkoutError}">
        <div class="alert-danger" role="alert" style="margin-bottom: 24px;">
            <strong>Lưu ý:</strong> <c:out value="${checkoutError}"/>
        </div>
    </c:if>

    <div class="checkout-grid-layout">
        <form id="codCheckoutForm" action="${pageContext.request.contextPath}/checkout" method="post" class="checkout-form-panel">
            <h2>1. Thông Tin Người Nhận</h2>

            <div class="checkout-form-row">
                <div class="form-group">
                    <label for="recipientName">Họ và tên người nhận *</label>
                    <input type="text" id="recipientName" name="recipientName" class="form-control"
                           value="${fn:escapeXml(recipientName)}" minlength="2" maxlength="100" required>
                </div>
                <div class="form-group">
                    <label for="recipientPhone">Số điện thoại liên lạc *</label>
                    <input type="tel" id="recipientPhone" name="recipientPhone" class="form-control"
                           value="${fn:escapeXml(recipientPhone)}" minlength="9" maxlength="20" required>
                </div>
            </div>

            <div class="form-group">
                <label for="email">Tài khoản đặt mua</label>
                <input type="email" id="email" class="form-control" value="${fn:escapeXml(sessionScope.user.email)}" readonly
                       style="background: var(--paper-dark); color: var(--muted);">
            </div>

            <div class="form-group">
                <label for="shippingAddress">Địa chỉ nhận sách chi tiết *</label>
                <textarea id="shippingAddress" name="shippingAddress" class="form-control" rows="3"
                          placeholder="Số nhà, tên đường, phường/xã, quận/huyện, tỉnh/thành phố..."
                          minlength="10" maxlength="500" required>${fn:escapeXml(shippingAddress)}</textarea>
            </div>

            <div class="form-group">
                <label for="note">Ghi chú cho người vận chuyển (không bắt buộc)</label>
                <textarea id="note" name="note" class="form-control" rows="2"
                          placeholder="Chỉ dẫn giao hàng, thời gian nhận sách thuận tiện..."
                          maxlength="500">${fn:escapeXml(note)}</textarea>
            </div>

            <h2 style="margin-top: 36px;">2. Phương Thức Thanh Toán</h2>
            <div class="cod-method-card">
                <input type="radio" id="paymentMethodCod" name="paymentMethod" value="COD" checked class="cod-radio-indicator">
                <div class="cod-method-desc">
                    <label for="paymentMethodCod" style="cursor: pointer;">
                        <strong>Thanh Toán Khi Nhận Hàng (COD)</strong>
                        <p>Bạn thanh toán tiền mặt cho nhân viên giao vận khi nhận hàng.</p>
                    </label>
                </div>
            </div>
        </form>

        <aside class="order-summary-card">
            <h3>Đơn Sách Của Bạn</h3>

            <div class="checkout-items-list">
                <c:forEach var="item" items="${sessionScope.cart.items}">
                    <div class="checkout-item-entry">
                        <div style="min-width: 0;">
                            <div class="checkout-item-entry-title">
                                <c:out value="${item.book.title}"/>
                            </div>
                            <span class="checkout-item-entry-qty">Số lượng: ${item.quantity} cuốn</span>
                        </div>
                        <span class="checkout-item-entry-sub">
                            $<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/>
                        </span>
                    </div>
                </c:forEach>
            </div>

            <div class="summary-data-row">
                <span>Tổng số sách</span>
                <strong>${sessionScope.cart.itemCount} cuốn</strong>
            </div>

            <div class="summary-data-row">
                <span>Phí vận chuyển</span>
                <span style="color: var(--forest); font-weight: 600;">$0.00</span>
            </div>

            <div class="summary-data-row total-row">
                <span>Tổng thanh toán</span>
                <strong>$<fmt:formatNumber value="${sessionScope.cart.total}" minFractionDigits="2" maxFractionDigits="2"/></strong>
            </div>

            <div class="cart-summary-actions">
                <button type="submit" form="codCheckoutForm" class="btn btn-primary btn-block btn-large">
                    Xác Nhận Đặt Đơn Hàng (COD)
                </button>
                <p style="font-size: 0.78rem; color: var(--muted); text-align: center; margin: 4px 0 0;">
                    Bằng việc bấm xác nhận, bạn đồng ý nhận sách và thanh toán đúng số tiền khi đơn hàng tới.
                </p>
            </div>
        </aside>
    </div>
</body>
</html>
