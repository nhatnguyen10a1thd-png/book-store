<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> - BookStore</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=7">
    <sitemesh:write property='head'/>
</head>
<body>
    <!-- ========== HEADER ========== -->
    <header class="header">
        <div class="container header-inner">
            <a href="${pageContext.request.contextPath}/home" class="logo">
                <span class="logo-icon">📚</span>
                <span>BookStore</span>
                <span class="logo-badge">KTQT</span>
            </a>
            <nav class="nav">
                <ul class="nav-list">
                    <li><a href="${pageContext.request.contextPath}/home" class="nav-link">Trang Chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/products" class="nav-link">Sản phẩm</a></li>
                    <li class="nav-cart-item">
                        <details class="mini-cart">
                            <summary class="cart-icon-button" aria-label="Mở giỏ hàng" title="Giỏ hàng">
                                <svg viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M3 3h2l2.2 10.2a2 2 0 0 0 2 1.6h7.7a2 2 0 0 0 2-1.6L20.3 7H6.1M10 20a1 1 0 1 1-2 0 1 1 0 0 1 2 0Zm8 0a1 1 0 1 1-2 0 1 1 0 0 1 2 0Z"/>
                                </svg>
                                <c:if test="${not empty sessionScope.cart && sessionScope.cart.itemCount > 0}">
                                    <span class="cart-badge">${sessionScope.cart.itemCount}</span>
                                </c:if>
                            </summary>
                            <div class="mini-cart-panel">
                                <div class="mini-cart-header">
                                    <strong>Giỏ hàng của bạn</strong>
                                    <c:if test="${not empty sessionScope.cart}">
                                        <span>${sessionScope.cart.itemCount} sản phẩm</span>
                                    </c:if>
                                </div>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.cart && not empty sessionScope.cart.items}">
                                        <div class="mini-cart-list">
                                            <c:forEach var="item" items="${sessionScope.cart.items}">
                                                <div class="mini-cart-product">
                                                    <div class="mini-cart-product-info">
                                                        <a href="${pageContext.request.contextPath}/book?id=${item.book.bookId}">
                                                            <c:out value="${item.book.title}"/>
                                                        </a>
                                                        <small>${item.quantity} × $<fmt:formatNumber value="${item.book.price}" minFractionDigits="2" maxFractionDigits="2"/></small>
                                                    </div>
                                                    <strong>$<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/></strong>
                                                </div>
                                            </c:forEach>
                                        </div>
                                        <div class="mini-cart-total">
                                            <span>Tổng cộng</span>
                                            <strong>$<fmt:formatNumber value="${sessionScope.cart.total}" minFractionDigits="2" maxFractionDigits="2"/></strong>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/cart" class="btn-primary btn-block">Xem giỏ hàng</a>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="mini-cart-empty">
                                            <span>🛒</span>
                                            <p>Giỏ hàng đang trống</p>
                                            <a href="${pageContext.request.contextPath}/products">Khám phá sách</a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </details>
                    </li>
                    <c:choose>
                        <c:when test="${sessionScope.user != null}">
                            <li>
                                <div class="user-profile-badge">
                                    <span>${sessionScope.user.fullname}</span>
                                </div>
                            </li>
                            <c:if test="${sessionScope.user.admin}">
                                <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link nav-admin-btn">⚙️ Quản trị</a></li>
                            </c:if>
                            <li><a href="${pageContext.request.contextPath}/logout" class="nav-link btn-logout">Đăng xuất</a></li>
                        </c:when>
                        <c:otherwise>
                            <li><a href="${pageContext.request.contextPath}/login" class="nav-link btn-login">Đăng nhập</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </nav>
        </div>
    </header>

    <c:if test="${not empty requestScope.cartMessage}">
        <div id="cartToast" class="cart-toast alert-${requestScope.cartMessageType}" role="status">
            <c:out value="${requestScope.cartMessage}"/>
        </div>
    </c:if>

    <!-- ========== MAIN CONTENT ========== -->
    <main class="main-content">
        <div class="container">
            <sitemesh:write property='body'/>
        </div>
    </main>

    <!-- ========== FOOTER ========== -->
    <footer class="footer">
        <div class="container footer-inner">
            <div class="footer-info">
                <div class="footer-tag">👤 Họ tên: <strong>Hà Nguyễn Nhật Nguyên</strong></div>
                <div class="footer-tag">🆔 MSSV: <strong>24110288</strong></div>
                <div class="footer-tag">📝 Mã đề: <strong>01</strong></div>
            </div>
            <div class="footer-copyright">
                © 2026 BookStore Management System • LTWeb
            </div>
        </div>
    </footer>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const miniCart = document.querySelector('.mini-cart');
            const cartToast = document.getElementById('cartToast');

            document.addEventListener('click', function(event) {
                if (miniCart && miniCart.open && !miniCart.contains(event.target)) {
                    miniCart.removeAttribute('open');
                }
            });

            if (cartToast) {
                window.setTimeout(function() {
                    cartToast.classList.add('cart-toast-hidden');
                }, 2800);
            }
        });
    </script>
</body>
</html>
