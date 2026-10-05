<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Trang Quản Trị</title>
</head>
<body>
    <div class="admin-dashboard-container">
        <div class="page-header">
            <h1>Bảng Điều Khiển Quản Trị</h1>
            <p>Hệ thống giám sát và quản lý dữ liệu ứng dụng BookStore</p>
        </div>

        <div class="admin-stats-grid">
            <div class="stat-box">
                <div class="stat-title">Tổng số sách</div>
                <div class="stat-value">5</div>
                <div class="stat-sub">Đã lưu trong CSDL</div>
            </div>
            <div class="stat-box">
                <div class="stat-title">Người dùng</div>
                <div class="stat-value">4</div>
                <div class="stat-sub">Tài khoản hoạt động</div>
            </div>
            <div class="stat-box">
                <div class="stat-title">Tác giả</div>
                <div class="stat-value">5</div>
                <div class="stat-sub">Hồ sơ tác giả</div>
            </div>
        </div>

        <div class="admin-grid-2col">
            <div class="panel">
                <h2 class="panel-title">Thông Tin Tài Khoản Quản Trị</h2>
                <table class="data-table">
                    <tbody>
                        <tr>
                            <th style="width: 180px;">Họ và tên</th>
                            <td>${sessionScope.user.fullname}</td>
                        </tr>
                        <tr>
                            <th>Email đăng nhập</th>
                            <td>${sessionScope.user.email}</td>
                        </tr>
                        <tr>
                            <th>Số điện thoại</th>
                            <td>${not empty sessionScope.user.phone ? sessionScope.user.phone : "Chưa cập nhật"}</td>
                        </tr>
                        <tr>
                            <th>Quyền hạn</th>
                            <td style="font-weight: 600;">Toàn quyền quản trị (Super Admin)</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="panel">
                <h2 class="panel-title">Lối Tắt Nhanh</h2>
                <div class="quick-action-list">
                    <a href="${pageContext.request.contextPath}/admin/books" class="quick-action-btn" style="background-color: var(--primary); color: white; border: none;">Quản lý Sách (CRUD)</a>
                    <a href="${pageContext.request.contextPath}/admin/authors" class="quick-action-btn" style="background-color: var(--primary); color: white; border: none;">Quản lý Tác giả (CRUD)</a>
                    <a href="${pageContext.request.contextPath}/products" class="quick-action-btn">Xem danh mục sách</a>
                    <a href="${pageContext.request.contextPath}/home" class="quick-action-btn">Về trang chủ</a>
                    <a href="${pageContext.request.contextPath}/logout" class="quick-action-btn">Đăng xuất</a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
