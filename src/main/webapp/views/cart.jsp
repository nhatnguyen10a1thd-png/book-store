<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>Giỏ Hàng</title>
</head>
<body>
    <div class="page-header cart-page-header">
        <div>
            <h1>Giỏ Hàng</h1>
            <p>Kiểm tra sản phẩm và điều chỉnh số lượng trước khi đặt hàng.</p>
        </div>
        <a href="${pageContext.request.contextPath}/products" class="btn-outline">Tiếp tục mua sắm</a>
    </div>

    <c:choose>
        <c:when test="${not empty sessionScope.cart && not empty sessionScope.cart.items}">
            <div class="cart-layout">
                <div class="cart-table-wrapper">
                    <table class="data-table cart-table">
                        <thead>
                            <tr>
                                <th>Sản phẩm</th>
                                <th>Đơn giá</th>
                                <th>Số lượng</th>
                                <th>Thành tiền</th>
                                <th>Thao tác</th>
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
                                        <div class="cart-product">
                                            <a href="${pageContext.request.contextPath}/book?id=${item.book.bookId}">
                                                <img src="${coverUrl}" alt="${item.book.title}" class="cart-product-image"
                                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';"/>
                                            </a>
                                            <div>
                                                <a href="${pageContext.request.contextPath}/book?id=${item.book.bookId}" class="cart-product-title">
                                                    <c:out value="${item.book.title}"/>
                                                </a>
                                                <small>Còn ${item.book.quantity} cuốn trong kho</small>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="cart-price">
                                        $<fmt:formatNumber value="${item.book.price}" minFractionDigits="2" maxFractionDigits="2"/>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="quantity-form">
                                            <input type="hidden" name="action" value="update"/>
                                            <input type="hidden" name="bookId" value="${item.book.bookId}"/>
                                            <input type="number" name="quantity" value="${item.quantity}" min="1"
                                                   max="${item.book.quantity}" class="quantity-input" required/>
                                            <button type="submit" class="btn-outline">Cập nhật</button>
                                        </form>
                                    </td>
                                    <td class="cart-subtotal">
                                        $<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/>
                                    </td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/cart" method="post">
                                            <input type="hidden" name="action" value="remove"/>
                                            <input type="hidden" name="bookId" value="${item.book.bookId}"/>
                                            <button type="submit" class="btn-danger">Xóa</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <aside class="cart-summary">
                    <h2>Tóm tắt giỏ hàng</h2>
                    <div class="cart-summary-row">
                        <span>Số lượng</span>
                        <strong>${sessionScope.cart.itemCount} cuốn</strong>
                    </div>
                    <div class="cart-summary-row cart-total">
                        <span>Tổng cộng</span>
                        <strong>$<fmt:formatNumber value="${sessionScope.cart.total}" minFractionDigits="2" maxFractionDigits="2"/></strong>
                    </div>
                    <a href="${pageContext.request.contextPath}/checkout" class="btn-primary btn-block cart-checkout-button">
                        Thanh toán COD
                    </a>
                    <form action="${pageContext.request.contextPath}/cart" method="post"
                          onsubmit="return confirm('Bạn có chắc muốn xóa toàn bộ giỏ hàng?');">
                        <input type="hidden" name="action" value="clear"/>
                        <button type="submit" class="btn-outline btn-block">Xóa toàn bộ giỏ hàng</button>
                    </form>
                </aside>
            </div>
        </c:when>
        <c:otherwise>
            <div class="panel empty-cart">
                <div class="empty-cart-icon">🛒</div>
                <h2>Giỏ hàng của bạn đang trống</h2>
                <p>Hãy chọn những cuốn sách bạn yêu thích để thêm vào giỏ.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn-primary">Xem danh mục sách</a>
            </div>
        </c:otherwise>
    </c:choose>
</body>
</html>
