<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>Trang Chủ — Tuyển Tập Sách Giá Trị</title>
</head>
<body>
    <section class="editorial-hero">
        <div class="editorial-hero-grid">
            <div class="hero-content">
                <span class="eyebrow">Ấn Bản Chọn Lọc</span>
                <h1 class="hero-title">Những cuốn sách đáng để dành thời gian.</h1>
                <p class="hero-lead">
                    Không gian tuyển chọn các tác phẩm nền tảng về công nghệ, kiến trúc phần mềm và tư tưởng học thuật. Mỗi cuốn sách là một nhịp đọc chậm, tĩnh tại và trường tồn.
                </p>
                <div class="hero-actions">
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-primary btn-large">
                        Khám Phá Toàn Bộ Sách
                    </a>
                    <c:choose>
                        <c:when test="${sessionScope.user == null}">
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline btn-large">
                                Đăng Nhập Thành Viên
                            </a>
                        </c:when>
                        <c:when test="${sessionScope.user.admin}">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-gold btn-large">
                                Bảng Quản Trị
                            </a>
                        </c:when>
                    </c:choose>
                </div>
            </div>

            <div class="hero-book-showcase" aria-hidden="true">
                <div class="hero-book-stack">
                    <div class="hero-book-card book-back">
                        <img src="${pageContext.request.contextPath}/assets/images/design-patterns.jpg" alt="Design Patterns"
                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';"/>
                    </div>
                    <div class="hero-book-card book-front">
                        <img src="${pageContext.request.contextPath}/assets/images/clean-code.jpg" alt="Clean Code"
                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';"/>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <section class="editorial-quotation-section">
        <div class="editorial-quote-grid">
            <div class="quote-numeral">01</div>
            <div class="quote-editorial-text">
                <blockquote>
                    “Sách để đọc. Sách để giữ. Từng trang giấy là một nhịp thở chậm giữa cuộc sống vội vã.”
                </blockquote>
            </div>
            <div class="quote-sidebar-notes">
                <p>
                    Thông tin từng tựa sách được trình bày rõ ràng để bạn dễ dàng lựa chọn tác phẩm phù hợp với nhu cầu học tập và phát triển chuyên môn.
                </p>
            </div>
        </div>
    </section>

    <section class="featured-book-section" id="catalogue">
        <div class="section-head">
            <div class="section-head-title">
                <span class="eyebrow">Danh Mục Ấn Phẩm</span>
                <h2>Khám Phá Danh Mục Sách</h2>
                <p>Các tựa sách kỹ thuật và tư duy phát triển phần mềm hiện có tại BookStore.</p>
            </div>
            <a href="${pageContext.request.contextPath}/products" class="btn btn-outline btn-small">
                Xem tất cả ấn bản &rarr;
            </a>
        </div>

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
                        <a href="${pageContext.request.contextPath}/book?id=${book.bookId}">
                            <img src="${coverUrl}" alt="${book.title}" class="book-cover-img" loading="lazy"
                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';"/>
                        </a>
                        <c:if test="${book.quantity <= 0}">
                            <span class="book-stock-pill out-of-stock">Tạm hết hàng</span>
                        </c:if>
                    </div>

                    <div class="book-card-meta">
                        <span class="book-card-category">${not empty book.publisher ? book.publisher : 'Chưa cập nhật nhà xuất bản'}</span>
                        <h3 class="book-card-title">
                            <a href="${pageContext.request.contextPath}/book?id=${book.bookId}">
                                <c:out value="${book.title}"/>
                            </a>
                        </h3>
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
                            <form action="${pageContext.request.contextPath}/cart" method="post" class="home-cart-form">
                                <input type="hidden" name="action" value="add"/>
                                <input type="hidden" name="bookId" value="${book.bookId}"/>
                                <input type="hidden" name="quantity" value="1"/>
                                <input type="hidden" name="returnUrl" value="/home?page=${currentPage}"/>
                                <button type="submit" class="btn btn-primary btn-block btn-small" ${book.quantity <= 0 ? 'disabled' : ''}>
                                    ${book.quantity > 0 ? 'Thêm Vào Giỏ Sách' : 'Tạm Hết Hàng'}
                                </button>
                            </form>
                        </div>
                    </div>
                </article>
            </c:forEach>
        </div>

        <c:if test="${totalPages > 1}">
            <nav class="editorial-pagination" aria-label="Phân trang sách">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/home?page=${i}" 
                       class="page-num-btn ${i == currentPage ? 'active' : ''}">
                        ${i}
                    </a>
                </c:forEach>
            </nav>
        </c:if>
    </section>

    <section class="literary-heritage-strip">
        <div class="heritage-col">
            <span class="heritage-col-marker">I. Danh mục</span>
            <h3>Thông tin rõ ràng</h3>
            <p>Mỗi tựa sách hiển thị đầy đủ thông tin xuất bản, giá bán và số lượng hiện có để bạn dễ dàng lựa chọn.</p>
        </div>
        <div class="heritage-col">
            <span class="heritage-col-marker">II. Giỏ hàng</span>
            <h3>Chủ động lựa chọn</h3>
            <p>Thêm sách, điều chỉnh số lượng hoặc loại bỏ sản phẩm trước khi xác nhận đơn hàng.</p>
        </div>
        <div class="heritage-col">
            <span class="heritage-col-marker">III. Thanh toán</span>
            <h3>Thanh toán khi nhận hàng</h3>
            <p>Thanh toán tiền mặt cho nhân viên giao vận khi đơn hàng được giao tới địa chỉ của bạn.</p>
        </div>
    </section>

</body>
</html>
