<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><sitemesh:write property='title'/> - BookStore</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css?v=4">
    <%-- Chống chớp (FOUC): ẩn body đến khi load xong --%>
    <style>
        body { opacity: 0; }
        body.loaded { opacity: 1; transition: opacity 0.15s ease-in; }
    </style>
    <sitemesh:write property='head'/>
</head>
<body>
    <header class="header">
        <div class="container header-inner">
            <a href="${pageContext.request.contextPath}/home" class="logo">
                <span class="logo-text">BookStore</span>
            </a>
            <nav class="nav">
                <ul class="nav-list">
                    <li><a href="${pageContext.request.contextPath}/home" class="nav-link">Trang Chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/products" class="nav-link">Sản phẩm</a></li>
                    <c:choose>
                        <c:when test="${sessionScope.user == null}">
                            <li><a href="${pageContext.request.contextPath}/login" class="nav-link">Đăng nhập</a></li>
                        </c:when>
                        <c:otherwise>
                            <!-- Đã đăng nhập thì ẩn Đăng nhập, hiện Đăng xuất -->
                            <li><a href="${pageContext.request.contextPath}/logout" class="nav-link">Đăng xuất</a></li>
                        </c:otherwise>
                    </c:choose>
                    <c:if test="${sessionScope.user != null && sessionScope.user.admin}">
                        <li><a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">Trang quản trị</a></li>
                    </c:if>
                </ul>
            </nav>
            <div class="header-user">
                <c:if test="${sessionScope.user != null}">
                    <div class="user-info">
                        <div class="user-avatar">${fn:substring(sessionScope.user.fullname, 0, 1)}</div>
                        <div class="user-name">
                            <span class="user-role">Khách hàng</span>
                            <strong>${sessionScope.user.fullname}</strong>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </header>

    <main class="main-content">
        <div class="container">
            <sitemesh:write property='body'/>
        </div>
    </main>

    <footer class="footer">
        <div class="container footer-inner">
            <div class="footer-info">
                <span>Họ tên: <strong>Hà Nguyễn Nhật Nguyên</strong></span> |
                <span>MSSV: <strong>24110288</strong></span> |
                <span>Mã đề: <strong>01</strong></span>
            </div>
            <div class="footer-copyright">
                © 2026 BookStore
            </div>
        </div>
    </footer>
    <%-- Script chống chớp: hiện trang sau khi load xong --%>
    <script>document.addEventListener('DOMContentLoaded', function() { document.body.classList.add('loaded'); });</script>
</body>
</html>
