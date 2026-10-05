<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Đăng Ký</title>
</head>
<body>
    <div class="login-container">
        <div class="panel">
            <h2 style="text-align: center; margin-bottom: 24px;">Đăng Ký Tài Khoản</h2>

            <c:if test="${not empty error}">
                <div class="alert-danger">
                    ${error}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="form-group">
                    <label for="fullname">Họ và tên</label>
                    <input type="text" id="fullname" name="fullname" class="form-control" required autofocus>
                </div>
                
                <div class="form-group">
                    <label for="email">Địa chỉ Email</label>
                    <input type="email" id="email" name="email" class="form-control" required>
                </div>

                <div class="form-group">
                    <label for="phone">Số điện thoại</label>
                    <input type="text" id="phone" name="phone" class="form-control">
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>
                
                <div class="form-group">
                    <label for="confirm_password">Xác nhận mật khẩu</label>
                    <input type="password" id="confirm_password" name="confirm_password" class="form-control" required>
                </div>

                <button type="submit" class="btn-primary" style="width: 100%; margin-top: 8px;">
                    Đăng Ký
                </button>
                
                <div style="text-align: center; margin-top: 16px;">
                    <a href="${pageContext.request.contextPath}/login" style="color: var(--primary); font-weight: 500;">Đã có tài khoản? Đăng nhập</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
