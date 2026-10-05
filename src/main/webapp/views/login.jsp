<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Đăng Nhập</title>
</head>
<body>
    <div class="login-container">
        <div class="panel">
            <h2 style="text-align: center; margin-bottom: 24px;">Đăng Nhập Hệ Thống</h2>

            <c:if test="${not empty error}">
                <div class="alert-danger">
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <label for="email">Địa chỉ Email</label>
                    <input type="email" id="email" name="email" class="form-control" required autofocus>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%; margin-top: 8px;">
                    Đăng Nhập
                </button>
                <div style="text-align: center; margin-top: 16px;">
                    <a href="${pageContext.request.contextPath}/register" style="color: var(--primary); font-weight: 500;">Chưa có tài khoản? Đăng ký ngay</a>
                </div>
            </form>

            <div class="hint-box">
                <div style="font-weight: 600; margin-bottom: 8px;">Tài khoản mẫu:</div>
                <div style="margin-bottom: 4px;">Admin: <code>admin@gmail.com / 123456</code></div>
                <div>User: <code>nguyen@gmail.com / 123456</code></div>
            </div>
        </div>
    </div>
</body>
</html>
