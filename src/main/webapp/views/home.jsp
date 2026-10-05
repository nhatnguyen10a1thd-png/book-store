<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Trang Chủ</title>
</head>
<body>
    <div class="panel home-hero">
        <h1>Hệ Thống Quản Lý &amp; Bán Sách BookStore</h1>
        <div style="margin-top: 16px;">
            <a href="${pageContext.request.contextPath}/products" class="btn-primary">Danh mục sách</a>
            <c:if test="${sessionScope.user == null}">
                <a href="${pageContext.request.contextPath}/login" class="btn-primary" style="background: #fff; color: #333 !important; margin-left: 8px;">Đăng nhập</a>
            </c:if>
            <c:if test="${sessionScope.user != null && sessionScope.user.admin}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn-primary" style="background: #fff; color: #333 !important; margin-left: 8px;">Trang quản trị</a>
            </c:if>
        </div>
    </div>

    <div class="panel">
        <h2 class="panel-title">Thông Tin Sinh Viên Dự Thi</h2>
        <table class="data-table">
            <tbody>
                <tr>
                    <th style="width: 200px;">Họ và tên</th>
                    <td>Hà Nguyễn Nhật Nguyên</td>
                </tr>
                <tr>
                    <th>Mã số sinh viên</th>
                    <td>24110288</td>
                </tr>
                <tr>
                    <th>Mã đề thi</th>
                    <td>01</td>
                </tr>
                <tr>
                    <th>Trạng thái CSDL</th>
                    <td style="color: green; font-weight: 600;">Kết nối SQL Server thành công</td>
                </tr>
            </tbody>
        </table>
    </div>

    <div class="feature-grid">
        <div class="feature-card">
            <h3>Danh mục sách</h3>
            <p>Xem toàn bộ danh mục sách được nạp trực tiếp từ SQL Server.</p>
            <a href="${pageContext.request.contextPath}/products" style="color: var(--primary); font-weight: 500;">Xem chi tiết</a>
        </div>
        <div class="feature-card">
            <h3>Phân quyền hệ thống</h3>
            <p>Sử dụng Filter để kiểm tra quyền truy cập của Admin và User.</p>
        </div>
        <div class="feature-card">
            <h3>Quản trị viên</h3>
            <p>Khu vực dành riêng cho quản trị viên, sử dụng decorator riêng biệt.</p>
            <c:if test="${sessionScope.user != null && sessionScope.user.admin}">
                <a href="${pageContext.request.contextPath}/admin/dashboard" style="color: var(--primary); font-weight: 500;">Vào bảng điều khiển</a>
            </c:if>
        </div>
    </div>
    <div class="panel">
        <h2 class="panel-title">Danh Sách Sản Phẩm</h2>
        <div class="book-grid" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
            <c:forEach var="book" items="${books}">
                <c:set var="cover" value="${book.coverImage}" />
                <c:choose>
                    <c:when test="${empty cover}">
                        <c:set var="coverUrl" value="${pageContext.request.contextPath}/assets/images/default-book.png" />
                    </c:when>
                    <c:when test="${cover.startsWith('http://') || cover.startsWith('https://') || cover.startsWith('data:')}">
                        <c:set var="coverUrl" value="${cover}" />
                    </c:when>
                    <c:when test="${cover.startsWith('/')}">
                        <c:set var="coverUrl" value="${pageContext.request.contextPath}${cover}" />
                    </c:when>
                    <c:when test="${cover.startsWith('assets/')}">
                        <c:set var="coverUrl" value="${pageContext.request.contextPath}/${cover}" />
                    </c:when>
                    <c:otherwise>
                        <c:set var="coverUrl" value="${pageContext.request.contextPath}/assets/images/${cover}" />
                    </c:otherwise>
                </c:choose>
                <div class="book-card" style="border: 1px solid #ddd; padding: 15px; border-radius: 8px;">
                    <div style="text-align: center; margin-bottom: 10px;">
                        <a href="${pageContext.request.contextPath}/book?id=${book.bookId}">
                            <img src="${coverUrl}" alt="${book.title}" style="max-width: 100%; height: 200px; object-fit: contain;" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';"/>
                        </a>
                    </div>
                    <div><strong>Tiêu đề:</strong> <a href="${pageContext.request.contextPath}/book?id=${book.bookId}" style="color: #007bff; text-decoration: none; font-weight: bold;">${book.title}</a></div>
                    <div><strong>Mã isbn:</strong> ${book.isbn}</div>
                    <div><strong>Tác giả:</strong> ${book.authorNames != null ? book.authorNames : 'Đang cập nhật'}</div>
                    <div><strong>Publisher:</strong> ${book.publisher}</div>
                    <div><strong>Publisher_date:</strong> ${book.publishDate}</div>
                    <div><strong>Quantity:</strong> ${book.quantity}</div>
                    <div><strong>Review</strong> (${book.reviewCount > 0 ? book.reviewCount : 10})</div>
                    <form action="${pageContext.request.contextPath}/cart" method="post" class="home-cart-form">
                        <input type="hidden" name="action" value="add"/>
                        <input type="hidden" name="bookId" value="${book.bookId}"/>
                        <input type="hidden" name="quantity" value="1"/>
                        <input type="hidden" name="returnUrl" value="/home?page=${currentPage}"/>
                        <button type="submit" class="btn-primary btn-block" ${book.quantity <= 0 ? 'disabled' : ''}>
                            ${book.quantity > 0 ? 'Thêm vào giỏ' : 'Hết hàng'}
                        </button>
                    </form>
                </div>
            </c:forEach>
        </div>
        
        <div class="pagination" style="margin-top: 20px; text-align: center;">
            <c:if test="${totalPages > 1}">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/home?page=${i}" 
                       class="btn-primary" 
                       style="${i == currentPage ? 'background: #0056b3;' : 'background: #007bff;'} margin: 0 5px; padding: 5px 10px;">${i}</a>
                </c:forEach>
            </c:if>
        </div>
    </div>
</body>
</html>
