<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>Danh Mục Sách — Toàn Bộ Ấn Bản Tuyển Chọn</title>
</head>
<body>
    <div class="section-head" style="margin-bottom: 36px;">
        <div class="section-head-title">
            <span class="eyebrow">Thư Mục Toàn Diện</span>
            <h1>Danh Mục Toàn Bộ Ấn Bản Sách</h1>
            <p>
                <c:choose>
                    <c:when test="${not empty books}">
                        Hiện có <strong>${books.size()} tác phẩm</strong> được lưu trữ và phát hành trực tiếp từ hệ thống.
                    </c:when>
                    <c:otherwise>
                        Danh mục hiện chưa có ấn bản nào.
                    </c:otherwise>
                </c:choose>
            </p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline btn-small">
                &larr; Về trang chủ
            </a>
        </div>
    </div>

    <c:choose>
        <c:when test="${not empty books}">
            <div class="book-shelf-grid">
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

                    <article class="book-card-item">
                        <div class="book-cover-wrap">
                            <a href="${pageContext.request.contextPath}/book?id=${book.bookId}" aria-label="Xem chi tiết ${book.title}">
                                <img src="${coverUrl}" alt="${book.title}" class="book-cover-img" loading="lazy"
                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';"/>
                            </a>
                            <c:if test="${book.quantity <= 0}">
                                <span class="book-stock-pill out-of-stock">Tạm hết hàng</span>
                            </c:if>
                        </div>

                        <div class="book-card-meta">
                            <span class="book-card-category">${not empty book.publisher ? book.publisher : 'Chưa cập nhật nhà xuất bản'}</span>
                            <h2 class="book-card-title">
                                <a href="${pageContext.request.contextPath}/book?id=${book.bookId}">
                                    <c:out value="${book.title}"/>
                                </a>
                            </h2>
                            <p class="book-card-author">
                                ${book.authorNames != null ? book.authorNames : 'Đang cập nhật tác giả'}
                            </p>

                            <div class="book-card-pricing">
                                <span class="book-price-figure">
                                    $<fmt:formatNumber value="${book.price}" minFractionDigits="2" maxFractionDigits="2"/>
                                </span>
                                <span class="book-stock-hint">
                                    <c:choose>
                                        <c:when test="${book.quantity > 0}">Kho: ${book.quantity} cuốn</c:when>
                                        <c:otherwise>Hết hàng</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <div class="book-card-actions">
                                <c:choose>
                                    <c:when test="${book.quantity > 0}">
                                        <form action="${pageContext.request.contextPath}/cart" method="post" class="add-cart-form">
                                            <input type="hidden" name="action" value="add"/>
                                            <input type="hidden" name="bookId" value="${book.bookId}"/>
                                            <input type="hidden" name="quantity" value="1"/>
                                            <input type="hidden" name="returnUrl" value="/products"/>
                                            <button type="submit" class="btn btn-primary btn-block btn-small">
                                                Thêm Vào Giỏ Sách
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" class="btn btn-outline btn-block btn-small" disabled>
                                            Tạm Hết Hàng
                                        </button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </article>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state-editorial">
                <svg class="empty-state-icon" viewBox="0 0 24 24">
                    <path d="M12 6.253v13m0-13C10.832 5.477 9.246 5 7.5 5S4.168 5.477 3 6.253v13C4.168 18.477 5.754 18 7.5 18s3.332.477 4.5 1.253m0-13C13.168 5.477 14.754 5 16.5 5c1.747 0 3.332.477 4.5 1.253v13C19.832 18.477 18.247 18 16.5 18c-1.746 0-3.332.477-4.5 1.253"/>
                </svg>
                <h2>Kho Sách Đang Được Cập Nhật</h2>
                <p>Hiện chưa có sách nào trong danh mục. Bạn có thể quay lại sau hoặc liên hệ quản trị viên.</p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Quay Về Trang Chủ</a>
            </div>
        </c:otherwise>
    </c:choose>
</body>
</html>
