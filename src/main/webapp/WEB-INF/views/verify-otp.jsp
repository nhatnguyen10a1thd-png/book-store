<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Xác Thực Mã OTP — BookStore Tri Thức</title>
</head>
<body>
    <div class="auth-split-wrapper" style="max-width: 620px; grid-template-columns: 1fr;">
        <div class="auth-form-container" style="padding: 48px; text-align: center;">
            <span class="eyebrow">Xác Thực Bảo Mật</span>
            <h2 style="font-size: 2rem; margin-bottom: 8px;">Nhập Mã Số Xác Thực (OTP)</h2>
            <p style="color: var(--muted); margin-bottom: 28px;">
                Mã xác nhận 6 chữ số đã được chuyển tới địa chỉ email của bạn.<br>
                Vui lòng kiểm tra hộp thư đến (Inbox) hoặc thư rác (Spam).
            </p>

            <c:if test="${not empty error}">
                <div class="alert-danger" role="alert" style="text-align: left; margin-bottom: 20px;">
                    <c:out value="${error}"/>
                </div>
            </c:if>

            <c:if test="${not empty message}">
                <div class="alert-success" role="status" style="text-align: left; margin-bottom: 20px;">
                    <c:out value="${message}"/>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/verify-otp" method="post" style="max-width: 380px; margin: 0 auto;">
                <div class="form-group" style="text-align: left;">
                    <label for="otp" style="text-align: center; display: block; margin-bottom: 10px;">
                        Mã OTP 6 chữ số
                    </label>
                    <input type="text" id="otp" name="otp" class="form-control otp-input-box"
                           placeholder="••••••" required autofocus maxlength="6">
                </div>

                <button type="submit" class="btn btn-primary btn-block btn-large" style="margin-top: 24px;">
                    Xác Nhận &amp; Kích Hoạt Tài Khoản
                </button>
            </form>
            
            <div class="auth-footer-prompt" style="margin-top: 32px;">
                Không nhận được mã hoặc cần chỉnh sửa thông tin?
                <a href="${pageContext.request.contextPath}/register">Đăng ký lại</a>
            </div>
        </div>
    </div>
</body>
</html>
