<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<html>
<head>
    <title>Đăng Nhập — BookStore Tri Thức</title>
</head>
<body>
    <div class="auth-split-wrapper">
        <div class="auth-editorial-banner auth-editorial-banner-centered">
            <div class="auth-brand-statement">
                <span class="eyebrow" style="color: var(--antique-gold-soft);">Hội Viên Độc Giả</span>
                <h3>Cửa ngõ dẫn lối đến những trang sách kinh điển.</h3>
                <p>Đăng nhập để theo dõi giỏ sách, thực hiện đặt hàng COD và lưu lại những cảm nhận văn học sâu sắc.</p>
            </div>
        </div>

        <div class="auth-form-container">
            <div class="auth-form-header">
                <h2>Đăng Nhập</h2>
                <p>Vui lòng điền thông tin tài khoản của bạn để tiếp tục.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert-danger" role="alert">
                    <c:out value="${error}"/>
                </div>
            </c:if>

            <c:if test="${not empty message}">
                <div class="alert-success" role="status">
                    <c:out value="${message}"/>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <c:if test="${not empty param.redirect || not empty redirect}">
                    <input type="hidden" name="redirect" value="${fn:escapeXml(not empty redirect ? redirect : param.redirect)}">
                </c:if>

                <div class="form-group">
                    <label for="email">Địa chỉ thư điện tử (Email)</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="example@domain.com" required autofocus>
                </div>

                <div class="form-group">
                    <label for="password">Mật khẩu truy cập</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>

                <button type="submit" class="btn btn-primary btn-block btn-large" style="margin-top: 24px;">
                    Đăng Nhập Vào Hệ Thống
                </button>

                <div class="auth-footer-prompt">
                    Chưa có tài khoản độc giả?
                    <a href="${pageContext.request.contextPath}/register">Đăng ký thành viên mới</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
