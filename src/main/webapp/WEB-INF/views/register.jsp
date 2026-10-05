<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Đăng Ký Thành Viên — BookStore Tri Thức</title>
</head>
<body>
    <div class="auth-split-wrapper">
        <div class="auth-editorial-banner">
            <div class="auth-brand-statement">
                <span class="eyebrow" style="color: var(--antique-gold-soft);">Chào Mừng Độc Giả</span>
                <h3>Trở thành một phần của cộng đồng yêu sách.</h3>
                <p>Khám phá kho tàng ấn bản chuyên sâu, lưu giữ đơn hàng COD dễ dàng và chia sẻ góc nhìn cùng những người yêu tri thức.</p>
            </div>

            <div class="auth-credentials-hint">
                <strong>Quy Trình Bảo Mật:</strong>
                <div>Sau khi hoàn tất đăng ký, một mã số xác thực (OTP) sẽ được gửi tới hòm thư của bạn để bảo vệ quyền lợi cá nhân.</div>
            </div>
        </div>

        <div class="auth-form-container">
            <div class="auth-form-header">
                <h2>Đăng Ký Tài Khoản</h2>
                <p>Khởi tạo hồ sơ độc giả mới trong hệ thống BookStore.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert-danger" role="alert">
                    <c:out value="${error}"/>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="form-group">
                    <label for="fullname">Họ và tên độc giả *</label>
                    <input type="text" id="fullname" name="fullname" class="form-control" placeholder="Ví dụ: Nguyễn Văn A" required autofocus>
                </div>
                
                <div class="form-group">
                    <label for="email">Địa chỉ thư điện tử (Email) *</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="name@domain.com" required>
                </div>

                <div class="form-group">
                    <label for="phone">Số điện thoại liên lạc</label>
                    <input type="tel" id="phone" name="phone" class="form-control" placeholder="09xxxxxxxx">
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu bảo mật *</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Tối thiểu 6 ký tự" required>
                </div>
                
                <div class="form-group">
                    <label for="confirm_password">Xác nhận lại mật khẩu *</label>
                    <input type="password" id="confirm_password" name="confirm_password" class="form-control" placeholder="Nhập lại mật khẩu" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block btn-large" style="margin-top: 24px;">
                    Tiếp Tục Xác Thực OTP
                </button>
                
                <div class="auth-footer-prompt">
                    Đã có tài khoản thành viên?
                    <a href="${pageContext.request.contextPath}/login">Đăng nhập tại đây</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
