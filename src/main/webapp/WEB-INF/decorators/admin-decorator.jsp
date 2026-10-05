<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="robots" content="noindex, nofollow">
    <meta name="referrer" content="strict-origin-when-cross-origin">
    <title><sitemesh:write property='title'/> — Quản Trị BookStore</title>

    <%-- Favicons --%>
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.ico" sizes="any">
    <link rel="icon" href="${pageContext.request.contextPath}/assets/images/favicon.svg" type="image/svg+xml">
    <link rel="apple-touch-icon" href="${pageContext.request.contextPath}/assets/images/apple-touch-icon.png">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,500;0,600;0,700;1,400&family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=20261005">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=20261005">
    <sitemesh:write property='head'/>
</head>
<body class="admin-body">
    <%-- Skip navigation link for accessibility --%>
    <a href="#main-content" class="skip-link">Bỏ qua điều hướng</a>

    <aside class="top-notice-bar" aria-label="Thông báo quản trị">
        <div class="container top-notice-inner">
            <div class="top-notice-text">
                Khu Vực Quản Trị Hệ Thống • BookStore Back-Office
            </div>
            <div class="top-notice-meta">
                <span>Quản trị viên: <strong>${sessionScope.user.fullname}</strong></span>
            </div>
        </div>
    </aside>

    <header class="site-header admin-header">
        <div class="container header-inner">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="site-brand">
                <span class="site-brand-title">
                    BookStore<span class="admin-badge">Back-Office</span>
                </span>
                <span class="site-brand-sub">Quản Lý &amp; Vận Hành Hệ Thống</span>
            </a>

            <nav class="primary-nav" aria-label="Menu quản trị">
                <ul class="nav-links-list">
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/dashboard"
                           class="nav-item-link ${pageContext.request.servletPath == '/WEB-INF/views/admin/dashboard.jsp' ? 'active' : ''}">
                            Bảng Điều Khiển
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/books"
                           class="nav-item-link ${pageContext.request.servletPath == '/WEB-INF/views/admin/books.jsp' || pageContext.request.servletPath == '/WEB-INF/views/admin/book-form.jsp' ? 'active' : ''}">
                            Quản Lý Sách
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/admin/authors"
                           class="nav-item-link ${pageContext.request.servletPath == '/WEB-INF/views/admin/authors.jsp' || pageContext.request.servletPath == '/WEB-INF/views/admin/author-form.jsp' ? 'active' : ''}">
                            Quản Lý Tác Giả
                        </a>
                    </li>
                    <li>
                        <a href="${pageContext.request.contextPath}/home" class="nav-item-link">
                            Xem Cửa Hàng &rarr;
                        </a>
                    </li>
                </ul>
            </nav>

            <div class="header-actions">
                <div class="user-auth-pill">
                    <span class="user-initial-mark">
                        ${fn:substring(sessionScope.user.fullname, 0, 1)}
                    </span>
                    <span class="user-auth-name">${sessionScope.user.fullname}</span>
                </div>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline btn-small">
                    Đăng xuất
                </a>
            </div>
        </div>
    </header>

    <main id="main-content" class="main-content admin-main">
        <div class="container">
            <sitemesh:write property='body'/>
        </div>
    </main>

    <footer class="site-footer">
        <div class="container">
            <div class="footer-bottom-bar">
                <div class="footer-copyright">
                    © BookStore. Bảo lưu mọi quyền.
                </div>
            </div>
        </div>
    </footer>
</body>
</html>
