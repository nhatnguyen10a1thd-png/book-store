<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html lang="vi">
<head>
    <title>Lịch Sử Đặt Hàng</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/orders.css?v=20261006">
</head>
<body>
    <section class="order-history" aria-labelledby="history-title">
        <header class="history-heading">
            <span class="eyebrow">Đơn hàng của bạn</span>
            <h1 id="history-title">Lịch Sử Đặt Hàng</h1>
            <p>Theo dõi những cuốn sách trên hành trình đến tay bạn. Tải lại trang để xem trạng thái mới nhất.</p>
        </header>

        <nav class="order-filters" aria-label="Lọc đơn hàng theo trạng thái">
            <a href="${pageContext.request.contextPath}/orders"
               class="order-filter ${empty selectedStatus ? 'is-active' : ''}"
               aria-current="${empty selectedStatus ? 'page' : 'false'}">Tất cả</a>
            <c:forEach var="status" items="${statuses}">
                <c:url var="filterUrl" value="/orders">
                    <c:param name="status" value="${status.code}"/>
                </c:url>
                <a href="${filterUrl}"
                   class="order-filter ${selectedStatus == status.code ? 'is-active' : ''}"
                   aria-current="${selectedStatus == status.code ? 'page' : 'false'}"><c:out value="${status.label}"/></a>
            </c:forEach>
        </nav>

        <c:choose>
            <c:when test="${not empty historyError}">
                <div class="alert alert-danger" role="alert"><c:out value="${historyError}"/></div>
            </c:when>
            <c:when test="${empty orders}">
                <div class="empty-state-editorial">
                    <c:choose>
                        <c:when test="${empty selectedStatus}">
                            <h2>Bạn chưa có đơn hàng nào</h2>
                            <p>Khám phá danh mục và chọn những cuốn sách yêu thích để bắt đầu.</p>
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">Khám phá sách</a>
                        </c:when>
                        <c:otherwise>
                            <h2>Chưa có đơn hàng ở trạng thái này</h2>
                            <p>Không tìm thấy đơn hàng: <c:out value="${selectedStatusLabel}"/>.</p>
                            <a href="${pageContext.request.contextPath}/orders" class="btn btn-outline">Xem tất cả đơn hàng</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:when>
            <c:otherwise>
                <div class="history-orders">
                    <c:forEach var="order" items="${orders}">
                        <article class="history-order" aria-labelledby="order-${order.orderId}">
                            <header class="history-order-header">
                                <div>
                                    <h2 id="order-${order.orderId}">Đơn hàng #${order.orderId}</h2>
                                    <p>Ngày đặt: <fmt:formatDate value="${order.createdAt}" pattern="dd/MM/yyyy HH:mm"/></p>
                                </div>
                                <span class="order-status order-status-${order.statusCode}"><c:out value="${order.statusLabel}"/></span>
                            </header>
                            <div class="history-recipient">
                                <p><strong>Người nhận:</strong> <c:out value="${order.recipientName}"/> · <c:out value="${order.recipientPhone}"/></p>
                                <p><strong>Địa chỉ:</strong> <c:out value="${order.shippingAddress}"/></p>
                            </div>
                            <ul class="history-items" aria-label="Sách trong đơn hàng">
                                <c:forEach var="item" items="${order.items}">
                                    <li class="history-item">
                                        <div>
                                            <strong><c:out value="${item.bookTitle}"/></strong>
                                            <p>Số lượng: ${item.quantity} × $<fmt:formatNumber value="${item.unitPrice}" minFractionDigits="2" maxFractionDigits="2"/></p>
                                        </div>
                                        <span>$<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></span>
                                    </li>
                                </c:forEach>
                            </ul>
                            <footer class="history-order-total">
                                <span>Thanh toán khi nhận hàng (COD)</span>
                                <strong>Tổng tiền: $<fmt:formatNumber value="${order.totalAmount}" minFractionDigits="2" maxFractionDigits="2"/></strong>
                            </footer>
                        </article>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </section>
</body>
</html>
