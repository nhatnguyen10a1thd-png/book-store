<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="BookStore Tri Thức — Tuyển chọn và cung cấp những ấn bản sách giá trị về công nghệ, kiến trúc phần mềm và văn học cổ điển.">
    <meta name="robots" content="index, follow">
    <meta name="referrer" content="strict-origin-when-cross-origin">
    <title><sitemesh:write property='title'/> — BookStore Tri Thức</title>
    <link rel="canonical" href="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${requestScope['jakarta.servlet.forward.request_uri'] != null ? requestScope['jakarta.servlet.forward.request_uri'] : pageContext.request.requestURI}">

    <%-- Favicons --%>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" sizes="any">
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.svg" type="image/svg+xml">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/assets/images/apple-touch-icon.png">
    <link rel="manifest" href="${pageContext.request.contextPath}/manifest.json">

    <%-- Open Graph --%>
    <meta property="og:type" content="website">
    <meta property="og:title" content="BookStore Tri Thức — Ấn bản sách giá trị">
    <meta property="og:description" content="Không gian lưu giữ và lan tỏa các ấn bản công nghệ, kiến trúc phần mềm và văn học cổ điển.">
    <meta property="og:url" content="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.requestURI}">
    <meta property="og:image" content="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/assets/images/og-image.jpg">

    <%-- Twitter Card --%>
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="BookStore Tri Thức — Ấn bản sách giá trị">
    <meta name="twitter:description" content="Không gian lưu giữ và lan tỏa các ấn bản công nghệ, kiến trúc phần mềm và văn học cổ điển.">
    <meta name="twitter:image" content="${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/assets/images/og-image.jpg">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;0,700;1,400;1,600&family=Inter:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=20261005">

    <%-- JSON-LD Structured Data --%>
    <script type="application/ld+json">
    {
        "@context": "https://schema.org",
        "@type": "WebSite",
        "name": "BookStore Tri Thức",
        "url": "${pageContext.request.scheme}://${pageContext.request.serverName}:${pageContext.request.serverPort}${pageContext.request.contextPath}/",
        "description": "Tuyển chọn và cung cấp những ấn bản sách giá trị về công nghệ, kiến trúc phần mềm và văn học cổ điển."
    }
    </script>

    <sitemesh:write property='head'/>
</head>
<body>
    <%-- Skip navigation link for accessibility --%>
    <a href="#main-content" class="skip-link">Bỏ qua điều hướng</a>

    <aside class="top-notice-bar" aria-label="Thông báo đầu trang">
        <div class="container top-notice-inner">
            <div class="top-notice-text">
                Tuyển chọn những ấn bản sách giá trị
            </div>
        </div>
    </aside>

    <header class="site-header">
        <div class="container header-inner">
            <a href="${pageContext.request.contextPath}/home" class="site-brand" aria-label="BookStore Tri Thức - Trang chủ">
                <span class="site-brand-title">
                    BookStore<span class="site-brand-dot"></span>
                </span>
                <span class="site-brand-sub">Timeless Literary Catalogue</span>
            </a>

            <nav class="primary-nav" aria-label="Điều hướng chính">
                <ul class="nav-links-list">
                    <li>
                        <a href="${pageContext.request.contextPath}/home"
                           class="nav-item-link ${pageContext.request.servletPath == '/WEB-INF/views/home.jsp' ? 'active' : ''}">
                            Trang Chủ
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/products"
                           class="nav-item-link ${pageContext.request.servletPath == '/WEB-INF/views/products.jsp' ? 'active' : ''}">
                            Danh Mục Sách
                        </a>
                    </li>
                </ul>
            </nav>

            <div class="header-actions">
                <div class="cart-widget">
                    <details class="mini-cart">
                        <summary class="cart-icon-btn" aria-label="Giỏ hàng của bạn">
                            <svg class="cart-svg-icon" viewBox="0 0 24 24" aria-hidden="true">
                                <path d="M4 4h2l2.5 12h9l2-8H7"/>
                                <circle cx="10" cy="19" r="1.5"/>
                                <circle cx="17" cy="19" r="1.5"/>
                            </svg>
                            <span>Giỏ hàng</span>
                            <c:if test="${not empty sessionScope.cart && sessionScope.cart.itemCount > 0}">
                                <span class="cart-counter">${sessionScope.cart.itemCount}</span>
                            </c:if>
                        </summary>

                        <div class="mini-cart-dropdown">
                            <div class="mini-cart-header">
                                <h4>Giỏ Sách Của Bạn</h4>
                                <c:if test="${not empty sessionScope.cart}">
                                    <span>${sessionScope.cart.itemCount} cuốn</span>
                                </c:if>
                            </div>

                            <c:choose>
                                <c:when test="${not empty sessionScope.cart && not empty sessionScope.cart.items}">
                                    <div class="mini-cart-items-scroll">
                                        <c:forEach var="item" items="${sessionScope.cart.items}">
                                            <div class="mini-cart-item-row">
                                                <div class="mini-cart-item-info">
                                                    <a href="${pageContext.request.contextPath}/book?id=${item.book.bookId}">
                                                        <c:out value="${item.book.title}"/>
                                                    </a>
                                                    <small>${item.quantity} × $<fmt:formatNumber value="${item.book.price}" minFractionDigits="2" maxFractionDigits="2"/></small>
                                                </div>
                                                <span class="mini-cart-price">
                                                    $<fmt:formatNumber value="${item.subtotal}" minFractionDigits="2" maxFractionDigits="2"/>
                                                </span>
                                            </div>
                                        </c:forEach>
                                    </div>
                                    <div class="mini-cart-summary-total">
                                        <span>Tổng thanh toán</span>
                                        <strong>$<fmt:formatNumber value="${sessionScope.cart.total}" minFractionDigits="2" maxFractionDigits="2"/></strong>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/cart" class="btn btn-primary btn-block">
                                        Xem Giỏ Hàng &amp; Đặt Hàng
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <div class="mini-cart-empty-view">
                                        <svg class="mini-cart-empty-icon" viewBox="0 0 24 24" aria-hidden="true">
                                            <path d="M4 4h2l2.5 12h9l2-8H7" stroke-linecap="round" stroke-linejoin="round"/>
                                            <circle cx="10" cy="19" r="1.5"/>
                                            <circle cx="17" cy="19" r="1.5"/>
                                        </svg>
                                        <p>Giỏ sách của bạn hiện đang trống</p>
                                        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline btn-small">
                                            Khám phá sách mới
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </details>
                </div>

                <c:choose>
                    <c:when test="${sessionScope.user != null}">
                        <div class="user-auth-pill">
                            <span class="user-initial-mark">
                                ${fn:substring(sessionScope.user.fullname, 0, 1)}
                            </span>
                            <span class="user-auth-name"><c:out value="${sessionScope.user.fullname}"/></span>
                        </div>
                        <c:if test="${sessionScope.user.admin}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-gold btn-small">
                                Quản trị
                            </a>
                        </c:if>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-small">
                            Đăng xuất
                        </a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-small">
                            Đăng nhập
                        </a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-primary btn-small">
                            Đăng ký
                        </a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <c:if test="${not empty requestScope.cartMessage}">
        <div id="cartToast" class="cart-toast alert-${requestScope.cartMessageType}" role="status" aria-live="polite">
            <svg viewBox="0 0 24 24" width="18" height="18" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M20 6L9 17l-5-5"/>
            </svg>
            <span><c:out value="${requestScope.cartMessage}"/></span>
        </div>
    </c:if>

    <main id="main-content" class="main-content">
        <div class="container">
            <sitemesh:write property='body'/>
        </div>
    </main>

    <footer class="site-footer">
        <div class="container">
            <div class="footer-top-grid">
                <div class="footer-col">
                    <h4>BookStore Tri Thức</h4>
                    <p>Không gian lưu giữ và lan tỏa các ấn bản công nghệ, kiến trúc phần mềm và văn học cổ điển. Mỗi cuốn sách là một nhịp chậm trên hành trình trau dồi tri thức.</p>
                </div>
                <div class="footer-col">
                    <h4>Danh Mục Tuyển Chọn</h4>
                    <ul class="footer-links-list">
                        <li><a href="${pageContext.request.contextPath}/home">Trang chủ tuyển tập</a></li>
                        <li><a href="${pageContext.request.contextPath}/products">Tất cả ấn bản sách</a></li>
                        <li><a href="${pageContext.request.contextPath}/cart">Giỏ hàng &amp; Đặt hàng</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Mua Sắm Thuận Tiện</h4>
                    <ul class="footer-links-list">
                        <li>Thanh toán trực tiếp khi nhận hàng (COD)</li>
                        <li>Chủ động cập nhật giỏ hàng trước khi đặt mua</li>
                        <li>Xác thực tài khoản qua thư điện tử</li>
                    </ul>
                </div>
            </div>

            <div class="footer-bottom-bar">
                <div class="footer-copyright">
                    © BookStore. Bảo lưu mọi quyền.
                </div>
            </div>
        </div>
    </footer>

    <noscript>
        <style>.mini-cart-dropdown { display: none; } .cart-toast { display: none; }</style>
        <p class="noscript-notice">Trình duyệt của bạn chưa bật JavaScript. Một số chức năng (giỏ hàng thu nhỏ, thông báo) sẽ không hoạt động.</p>
    </noscript>

    <script src="${pageContext.request.contextPath}/assets/js/app.js?v=20261005" defer></script>
</body>
</html>
