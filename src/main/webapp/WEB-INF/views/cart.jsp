<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>Giỏ Sách Của Bạn — BookStore Tri Thức</title>
</head>
<body>
    <div class="page-header" style="margin-bottom: 28px; display: flex; justify-content: space-between; align-items: flex-end;">
        <div>
            <span class="eyebrow">Túi Sách Tuyển Chọn</span>
            <h1>Giỏ Hàng Của Bạn</h1>
            <p style="margin: 0; color: var(--muted);">Kiểm tra danh mục sách và số lượng trước khi xác nhận đơn hàng COD.</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline btn-small">
                &larr; Tiếp tục chọn sách
            </a>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty sessionScope.cart && not empty sessionScope.cart.items}">
            <!-- Free Shipping Progress Tracker (Item 6) -->
            <c:set var="freeShippingGoal" value="50.0" />
            <c:set var="cartTotal" value="${sessionScope.cart.total != null ? sessionScope.cart.total : 0}" />
            <div class="cart-shipping-notice">
                <div class="cart-shipping-notice-title">
                    <c:choose>
                        <c:when test="${cartTotal >= freeShippingGoal}">
                            <span>🎉 Chúc mừng! Đơn hàng của bạn đã đủ điều kiện <strong>Miễn Phí Giao Hàng COD</strong> toàn quốc.</span>
                            <span style="color: var(--forest); font-weight: 700;">Đã đạt Freeship</span>
                        </c:when>
                        <c:otherwise>
                            <span>Thêm <strong>$<fmt:formatNumber value="${freeShippingGoal - cartTotal}" minFractionDigits="2" maxFractionDigits="2"/></strong> để nhận ưu đãi <strong>Miễn Phí Giao Hàng (COD)</strong></span>
                            <span>Mục tiêu $50.00</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="shipping-progress-track">
                    <div class="shipping-progress-fill" style="width: ${cartTotal >= freeShippingGoal ? 100 : (cartTotal / freeShippingGoal) * 100}%;"></div>
                </div>
            </div>

            <div class="cart-two-column-layout">
                <div class="cart-table-card">
                    <table class="cart-editorial-table">
                        <thead>
                            <tr>
                                <th>Ấn Phẩm</th>
                                <th>Đơn Giá</th>
                                <th>Số Lượng</th>
                                <th>Thành Tiền</th>
                                <th></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${sessionScope.cart.items}">
                                <c:set var="cover" value="${item.book.coverImage}"/>
                                <c:choose>
                                    <c:when test="${empty cover}">
                                        <c:set var="coverUrl" value="${pageContext.request.contextPath}/assets/images/default-book.png"/>
                                    </c:when>
                                    <c:when test="${cover.startsWith('http://') || cover.startsWith('https://') || cover.startsWith('data:')}">
                                        <c:set var="coverUrl" value="${cover}"/>
                                    </c:when>
                                    <c:when test="${cover.startsWith('/')}">
                                        <c:set var="coverUrl" value="${pageContext.request.contextPath}${cover}"/>
                                    </c:when>
                                    <c:when test="${cover.startsWith('assets/')}">
                                        <c:set var="coverUrl" value="${pageContext.request.contextPath}/${cover}"/>
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="coverUrl" value="${pageContext.request.contextPath}/assets/images/${cover}"/>
                                    </c:otherwise>
                                </c:choose>

                                <tr>
                                    <td>
                                        <div class="cart-item-book-cell">
                                            <a href="${pageContext.request.contextPath}/book?id=${item.book.bookId}">
                                                <img src="${coverUrl}" alt="${item.book.title}" class="cart-thumb-img"
                                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';"/>
                                            </a>
                                            <div>
                                                <a href="${pageContext.request.contextPath}/book?id=${item.book.bookId}" class="cart-item-title-link">
                                                    <c:out value="${item.book.title}"/>
                                                </a>
                                                <span class="cart-item-stock-sub">Kho còn: ${item.book.quantity} cuốn</span>
                                            </div>
                                        </div>
                                    </td>
                                    <td>
                                        <span class="cart-price-tag">
                                            $<fmt:formatNumber value="${item.book.price}" minFractionDigits="2" maxFractionDigits="2"/>
                                        </span>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="cart-update-form" style="display: flex; align-items: center; gap: 8px;">
                                            <input type="hidden" name="action" value="update"/>
                                            <input type="hidden" name="bookId" value="${item.book.bookId}"/>
                                            <div class="quantity-stepper-control">
                                                <button type="button" class="stepper-btn stepper-minus" aria-label="Giảm">-</button>
                                                <input type="number" name="quantity" value="${item.quantity}" min="1"
                                                       max="${item.book.quantity}" class="stepper-input" required/>
                                                <button type="button" class="stepper-btn stepper-plus" aria-label="Tăng">+</button>
                                            </div>
                                            <button type="submit" class="btn btn-outline btn-small" title="Lưu số lượng">
                                                Lưu
                                            </button>
                                        </form>
                                    </td>
                                    <td>
                                        <span class="cart-subtotal-tag">
                                            $<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/>
                                        </span>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="cart-remove-form">
                                            <input type="hidden" name="action" value="remove"/>
                                            <input type="hidden" name="bookId" value="${item.book.bookId}"/>
                                            <button type="submit" class="btn btn-danger btn-small" title="Xóa khỏi giỏ hàng">
                                                Xóa
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <aside class="order-summary-card">
                    <h3>Tóm Tắt Đơn Hàng</h3>
                    <div class="summary-data-row">
                        <span>Tổng số lượng sách</span>
                        <strong>${sessionScope.cart.itemCount} cuốn</strong>
                    </div>
                    <div class="summary-data-row">
                        <span>Hình thức vận chuyển</span>
                        <span>Giao hàng COD</span>
                    </div>
                    <div class="summary-data-row">
                        <span>Phí giao hàng</span>
                        <c:choose>
                            <c:when test="${cartTotal >= freeShippingGoal}">
                                <strong style="color: var(--forest);">MIỄN PHÍ</strong>
                            </c:when>
                            <c:otherwise>
                                <span>Thanh toán theo đơn COD</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="summary-data-row total-row">
                        <span>Tổng thanh toán tạm tính</span>
                        <strong>$<fmt:formatNumber value="${sessionScope.cart.total}" minFractionDigits="2" maxFractionDigits="2"/></strong>
                    </div>

                    <div class="cart-summary-actions">
                        <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary btn-block btn-large">
                            Tiến Hành Đặt Hàng COD &rarr;
                        </a>
                        <form action="${pageContext.request.contextPath}/cart" method="post"
                              onsubmit="return confirm('Bạn có chắc muốn xóa toàn bộ sách trong giỏ hàng?');">
                            <input type="hidden" name="action" value="clear"/>
                            <button type="submit" class="btn btn-outline btn-block btn-small">
                                Xóa toàn bộ giỏ sách
                            </button>
                        </form>
                    </div>
                </aside>
            </div>

            <!-- Confirmation Modal for Removal (Item 6) -->
            <div id="cartConfirmModal" class="cart-confirm-modal" role="dialog" aria-modal="true" aria-labelledby="modalTitle">
                <div class="cart-confirm-card">
                    <h3 id="modalTitle">Xác Nhận Xóa Ấn Phẩm</h3>
                    <p>Bạn có chắc chắn muốn bỏ cuốn sách này ra khỏi túi sách tuyển chọn của mình?</p>
                    <div class="cart-confirm-actions">
                        <button type="button" id="cartConfirmNo" class="btn btn-outline">Giữ Lại</button>
                        <button type="button" id="cartConfirmYes" class="btn btn-danger">Xóa Khỏi Giỏ</button>
                    </div>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state-editorial">
                <svg class="empty-state-icon" viewBox="0 0 24 24">
                    <path d="M4 4h2l2.5 12h9l2-8H7" stroke-linecap="round" stroke-linejoin="round"/>
                    <circle cx="10" cy="19" r="1.5"/>
                    <circle cx="17" cy="19" r="1.5"/>
                </svg>
                <h2>Giỏ Sách Hiện Đang Trống</h2>
                <p>Bạn chưa thêm ấn phẩm nào vào giỏ sách của mình. Hãy dạo quanh danh mục để tìm những cuốn sách đáng đọc.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary">
                    Khám Phá Danh Mục Sách
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</body>
</html>
