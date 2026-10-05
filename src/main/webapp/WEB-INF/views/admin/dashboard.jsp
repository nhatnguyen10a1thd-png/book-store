<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Bảng Điều Khiển Quản Trị</title>
</head>
<body>
    <div class="admin-dashboard-layout">
        <div class="section-head" style="margin-bottom: 24px;">
            <div class="section-head-title">
                <span class="eyebrow">Hệ Thống Quản Lý</span>
                <h1>Bảng Điều Khiển Trung Tâm</h1>
                <p>Quản lý thông tin sách, tác giả và tài khoản đang sử dụng hệ thống.</p>
            </div>
        </div>

        <div class="admin-grid-2col">
            <div class="admin-panel">
                <div class="admin-panel-head">
                    <h2 class="admin-panel-title">Thông Tin Quản Trị Viên</h2>
                    <span class="top-notice-badge">Đang hoạt động</span>
                </div>
                <table class="data-table" style="margin-bottom: 0;">
                    <tbody>
                        <tr>
                            <th style="width: 170px;">Họ và tên</th>
                            <td><strong>${sessionScope.user.fullname}</strong></td>
                        </tr>
                        <tr>
                            <th>Email quản trị</th>
                            <td><code>${sessionScope.user.email}</code></td>
                        </tr>
                        <tr>
                            <th>Số điện thoại</th>
                            <td>${not empty sessionScope.user.phone ? sessionScope.user.phone : "Chưa cập nhật"}</td>
                        </tr>
                        <tr>
                            <th>Vai trò phân quyền</th>
                            <td><span class="detail-stock-badge in-stock">Quản trị viên</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="admin-panel">
                <div class="admin-panel-head">
                    <h2 class="admin-panel-title">Thao Tác Quản Trị Nhanh</h2>
                </div>
                <div class="quick-action-list">
                    <a href="${pageContext.request.contextPath}/admin/books" class="quick-action-btn primary-action">
                        <span>Quản lý kho sách</span>
                        <span>&rarr;</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/authors" class="quick-action-btn">
                        <span>Quản lý hồ sơ tác giả</span>
                        <span>&rarr;</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/book-form" class="quick-action-btn">
                        <span>+ Thêm sách mới vào kho</span>
                        <span>&rarr;</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/products" class="quick-action-btn">
                        <span>Xem giao diện phía độc giả</span>
                        <span>&rarr;</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="quick-action-btn" style="color: var(--state-danger-text);">
                        <span>Đăng xuất phiên làm việc</span>
                        <span>&rarr;</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
