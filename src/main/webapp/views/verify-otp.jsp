<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Xác Thực OTP</title>
</head>
<body>
    <div class="login-container">
        <div class="panel" style="text-align: center;">
            <h2 style="margin-bottom: 16px;">Nhập Mã Xác Thực</h2>
            <p style="color: var(--text-muted); margin-bottom: 24px;">Mã OTP gồm 6 chữ số đã được gửi đến email của bạn.<br>Vui lòng kiểm tra hộp thư đến (hoặc hộp thư rác).</p>

            <c:if test="${not empty error}">
                <div class="alert-danger" style="text-align: left;">
                    ${error}
                </div>
            </c:if>

            <c:if test="${not empty message}">
                <div style="background: #d1e7dd; color: #0f5132; border: 1px solid #badbcc; padding: 12px 16px; border-radius: 4px; margin-bottom: 20px; font-size: 0.9rem; text-align: left;">
                    ${message}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/verify-otp" method="post">
                <div class="form-group" style="text-align: left;">
                    <label for="otp">Mã OTP (6 chữ số)</label>
                    <input type="text" id="otp" name="otp" class="form-control" placeholder="Ví dụ: 123456" required autofocus maxlength="6" style="font-size: 1.2rem; letter-spacing: 4px; text-align: center;">
                </div>

                <button type="submit" class="btn-primary" style="width: 100%; margin-top: 16px;">
                    Xác Thực
                </button>
            </form>
            
            <div style="margin-top: 24px; font-size: 0.9rem;">
                <p>Không nhận được mã? <a href="${pageContext.request.contextPath}/register" style="color: var(--primary); font-weight: 500;">Thử đăng ký lại</a></p>
            </div>
        </div>
    </div>
</body>
</html>
