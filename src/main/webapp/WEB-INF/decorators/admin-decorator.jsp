<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> - Admin BookStore</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=2">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin.css?v=2">
    <sitemesh:write property='head'/>
</head>
<body class="admin-body">
    <!-- ========== ADMIN HEADER ========== -->
    <header class="header admin-header">
        <div class="container header-inner">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="logo">
                <span class="logo-icon">⚡</span>
                <span>Admin BookStore</span>
                <span class="logo-badge">Quản trị</span>
            </a>
            <nav class="nav">
                <ul class="nav-list">
                    <li><a href="${pageContext.request.contextPath}/home" class="nav-link">Trang Chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/products" class="nav-link">Sản phẩm</a></li>
                    <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link" style="color: #60a5fa; font-weight:700;">Trang quản trị</a></li>
                    <li>
                        <div class="user-profile-badge">
                            <span>${sessionScope.user.fullname}</span>
                        </div>
                    </li>
                    <li><a href="${pageContext.request.contextPath}/logout" class="nav-link btn-logout">Đăng xuất</a></li>
                </ul>
            </nav>
        </div>
    </header>

    <!-- ========== ADMIN MAIN CONTENT ========== -->
    <main class="main-content admin-main">
        <div class="container">
            <sitemesh:write property='body'/>
        </div>
    </main>

    <!-- ========== FOOTER ========== -->
    <footer class="footer admin-footer">
        <div class="container footer-inner">
            <div class="footer-info">
                <div class="footer-tag">👤 Họ tên: <strong>Hà Nguyễn Nhật Nguyên</strong></div>
                <div class="footer-tag">🆔 MSSV: <strong>24110288</strong></div>
                <div class="footer-tag">📝 Mã đề: <strong>01</strong></div>
            </div>
            <div class="footer-copyright">
                © 2026 Admin Portal • BookStore Management System
            </div>
        </div>
    </footer>
</body>
</html>
