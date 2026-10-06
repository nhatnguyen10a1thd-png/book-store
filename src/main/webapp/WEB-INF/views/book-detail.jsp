<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<html>
<head>
    <title>${book.title} — Chi Tiết Ấn Bản</title>
</head>
<body>
    <div class="book-detail-wrapper">
        <nav class="breadcrumb-nav" aria-label="Đường dẫn trang">
            <a href="${pageContext.request.contextPath}/home">Trang chủ</a>
            <span>/</span>
            <a href="${pageContext.request.contextPath}/products">Sách</a>
            <span>/</span>
            <span><c:out value="${book.title}"/></span>
        </nav>

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

        <div class="detail-columns-layout">
            <div class="detail-cover-showcase">
                <div class="detail-cover-frame">
                    <img src="${coverUrl}" alt="${book.title}"
                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';"/>
                </div>
            </div>

            <div class="detail-info-panel">
                <span class="eyebrow">${not empty book.publisher ? book.publisher : 'Chưa cập nhật nhà xuất bản'}</span>

                <h1 class="detail-title"><c:out value="${book.title}"/></h1>

                <p class="detail-byline">
                    Tác giả: <strong>${book.authorNames != null ? book.authorNames : 'Đang cập nhật'}</strong>
                </p>

                <div class="detail-rating-strip">
                    <c:choose>
                        <c:when test="${not empty reviews}">
                            <div class="star-rating" aria-label="Điểm trung bình ${averageRating} trên 5 sao">
                                <c:forEach begin="1" end="5" var="star">
                                    <span class="${star <= averageRating + 0.5 ? '' : 'star-muted'}">★</span>
                                </c:forEach>
                            </div>
                            <span class="rating-count-label">
                                <fmt:formatNumber value="${averageRating}" minFractionDigits="1" maxFractionDigits="1"/>/5
                                · ${fn:length(reviews)} nhận xét
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="rating-count-label">Chưa có đánh giá</span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="detail-price-box">
                    <span class="detail-main-price">
                        $<fmt:formatNumber value="${book.price}" minFractionDigits="2" maxFractionDigits="2"/>
                    </span>
                    <c:choose>
                        <c:when test="${book.quantity <= 0}">
                            <span class="detail-stock-badge out-of-stock">
                                ✕ Tạm thời hết hàng
                            </span>
                        </c:when>
                        <c:when test="${book.quantity <= 3}">
                            <span class="stock-urgency-badge">
                                🔥 Chỉ còn duy nhất ${book.quantity} cuốn trong kho
                            </span>
                        </c:when>
                        <c:otherwise>
                            <span class="detail-stock-badge in-stock">
                                ✓ Còn ${book.quantity} cuốn trong kho
                            </span>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="detail-description-block">
                    <c:choose>
                        <c:when test="${not empty book.description}">
                            <p>${fn:replace(book.description, '\\n', '<br/>')}</p>
                        </c:when>
                        <c:otherwise>
                            <p>
                                Thông tin mô tả cho cuốn sách này đang được cập nhật.
                            </p>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="detail-purchase-form">
                    <c:choose>
                        <c:when test="${book.quantity > 0}">
                            <form action="${pageContext.request.contextPath}/cart" method="post" class="detail-purchase-row">
                                <input type="hidden" name="action" value="add"/>
                                <input type="hidden" name="bookId" value="${book.bookId}"/>
                                <input type="hidden" name="returnUrl" value="/book?id=${book.bookId}"/>

                                <div class="quantity-control-group">
                                    <label for="cartQuantity">Số lượng:</label>
                                    <div class="quantity-stepper-control">
                                        <button type="button" class="stepper-btn stepper-minus" aria-label="Giảm số lượng">-</button>
                                        <input id="cartQuantity" type="number" name="quantity" value="1" min="1"
                                               max="${book.quantity}" class="stepper-input" required/>
                                        <button type="button" class="stepper-btn stepper-plus" aria-label="Tăng số lượng">+</button>
                                    </div>
                                </div>

                                <button type="submit" class="btn btn-primary btn-large">
                                    Thêm Vào Giỏ Sách (COD)
                                </button>

                                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline">
                                    Xem thêm sách khác
                                </a>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div style="display: flex; gap: 16px; align-items: center;">
                                <p class="out-of-stock" style="margin: 0;">Sản phẩm hiện đang tạm hết hàng trong kho.</p>
                                <a href="${pageContext.request.contextPath}/products" class="btn btn-outline btn-small">
                                    Tìm sách tương tự
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <section class="specimen-section">
            <h2 class="specimen-section-title">Hồ Sơ Kỹ Thuật &amp; Xuất Bản</h2>
            <div class="specimen-grid">
                <div class="specimen-cell">
                    <span class="specimen-cell-label">Mã ISBN Quốc Tế</span>
                    <span class="specimen-cell-value"><code>${book.isbn}</code></span>
                </div>
                <div class="specimen-cell">
                    <span class="specimen-cell-label">Nhà Xuất Bản</span>
                    <span class="specimen-cell-value">${book.publisher}</span>
                </div>
                <div class="specimen-cell">
                    <span class="specimen-cell-label">Ngày Phát Hành</span>
                    <span class="specimen-cell-value">
                        <c:choose>
                            <c:when test="${not empty book.publishDate}">
                                <fmt:formatDate value="${book.publishDate}" pattern="dd/MM/yyyy"/>
                            </c:when>
                            <c:otherwise>Đang cập nhật</c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div class="specimen-cell">
                    <span class="specimen-cell-label">Tồn Kho Hiện Hữu</span>
                    <span class="specimen-cell-value">${book.quantity} cuốn</span>
                </div>
                <div class="specimen-cell">
                    <span class="specimen-cell-label">Hình Thức Thanh Toán</span>
                    <span class="specimen-cell-value">Giao hàng &amp; Thanh toán COD tận nơi</span>
                </div>
            </div>
        </section>

        <section class="reviews-section">
            <div class="reviews-header">
                <div>
                    <span class="eyebrow">Cộng Đồng Độc Giả</span>
                    <h2>Ghi Chép &amp; Đánh Giá Từ Người Đọc</h2>
                </div>
            </div>

            <div class="reviews-list">
                <c:choose>
                    <c:when test="${not empty reviews}">
                        <c:forEach var="review" items="${reviews}">
                            <article class="review-item-card">
                                <div class="review-card-top">
                                    <div class="reviewer-profile">
                                        <div class="reviewer-avatar">
                                            ${fn:substring(review.fullname, 0, 1)}
                                        </div>
                                        <div>
                                            <div class="reviewer-name"><c:out value="${review.fullname}"/></div>
                                            <small style="color: var(--muted); font-size: 0.8rem;">Độc giả đã xác thực</small>
                                        </div>
                                    </div>
                                    <div class="star-rating" style="font-size: 0.9rem;" aria-label="${review.rating} trên 5 sao">
                                        <c:forEach begin="1" end="5" var="star">
                                            <span class="${star <= review.rating ? '' : 'star-muted'}">★</span>
                                        </c:forEach>
                                    </div>
                                </div>
                                <div class="review-body-content">
                                    <p><c:out value="${review.reviewText}"/></p>
                                </div>
                            </article>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="panel" style="text-align: center; padding: 36px 20px; color: var(--muted);">
                            <p style="margin: 0;">Chưa có nhận xét nào cho ấn bản này. Hãy là người đầu tiên chia sẻ cảm nhận đọc.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="review-submission-box">
                <h4>Gửi Lời Bình Cho Cuốn Sách Này</h4>
                <c:if test="${sessionScope.user == null}">
                    <p style="color: var(--burgundy); margin-bottom: 16px; font-size: 0.92rem;">
                        Quý độc giả vui lòng <a href="${pageContext.request.contextPath}/login?redirect=/book?id=${book.bookId}" style="text-decoration: underline; font-weight: 600;">đăng nhập</a> để ghi nhận đánh giá.
                    </p>
                </c:if>
                <form action="${pageContext.request.contextPath}/book" method="post">
                    <input type="hidden" name="bookId" value="${book.bookId}">
                    <div class="form-group">
                        <label for="rating">Mức đánh giá:</label>
                        <select id="rating" name="rating" class="form-control" required ${sessionScope.user == null ? 'disabled' : ''}>
                            <option value="">Chọn số sao</option>
                            <option value="5">5 sao</option>
                            <option value="4">4 sao</option>
                            <option value="3">3 sao</option>
                            <option value="2">2 sao</option>
                            <option value="1">1 sao</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="reviewText">Cảm nhận và chiêm nghiệm của bạn:</label>
                        <textarea id="reviewText" name="reviewText" rows="4" class="form-control"
                                  placeholder="Chia sẻ góc nhìn của bạn về nội dung, giá trị ứng dụng của cuốn sách..."
                                  required ${sessionScope.user == null ? 'disabled' : ''}></textarea>
                    </div>
                    <button type="submit" class="btn btn-primary" ${sessionScope.user == null ? 'disabled' : ''}>
                        Gửi Đánh Giá Của Bạn
                    </button>
                </form>
            </div>
        </section>

        <!-- Related Books Section (Item 5) -->
        <c:if test="${not empty relatedBooks}">
            <section class="related-books-section">
                <div class="related-books-head">
                    <div>
                        <span class="eyebrow">Ấn Bản Cùng Tuyển Tập</span>
                        <h2>Có Thể Bạn Quan Tâm</h2>
                    </div>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline btn-small">
                        Xem tất cả ấn bản &rarr;
                    </a>
                </div>

                <div class="related-books-grid">
                    <c:forEach var="relBook" items="${relatedBooks}">
                        <c:set var="relCover" value="${relBook.coverImage}" />
                        <c:choose>
                            <c:when test="${empty relCover}">
                                <c:set var="relCoverUrl" value="${pageContext.request.contextPath}/assets/images/default-book.png" />
                            </c:when>
                            <c:when test="${relCover.startsWith('http://') || relCover.startsWith('https://') || relCover.startsWith('data:')}">
                                <c:set var="relCoverUrl" value="${relCover}" />
                            </c:when>
                            <c:when test="${relCover.startsWith('/')}">
                                <c:set var="relCoverUrl" value="${pageContext.request.contextPath}${relCover}" />
                            </c:when>
                            <c:when test="${relCover.startsWith('assets/')}">
                                <c:set var="relCoverUrl" value="${pageContext.request.contextPath}/${relCover}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="relCoverUrl" value="${pageContext.request.contextPath}/assets/images/${relCover}" />
                            </c:otherwise>
                        </c:choose>

                        <article class="book-card-item">
                            <div class="book-cover-wrap">
                                <a href="${pageContext.request.contextPath}/book?id=${relBook.bookId}">
                                    <img src="${relCoverUrl}" alt="${relBook.title}" class="book-cover-img" loading="lazy"
                                         onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';"/>
                                </a>
                                <c:if test="${relBook.quantity <= 0}">
                                    <span class="book-stock-pill out-of-stock">Tạm hết</span>
                                </c:if>
                            </div>

                            <div class="book-card-meta">
                                <span class="book-card-category">${not empty relBook.publisher ? relBook.publisher : 'Ấn bản chọn lọc'}</span>
                                <h3 class="book-card-title">
                                    <a href="${pageContext.request.contextPath}/book?id=${relBook.bookId}">
                                        <c:out value="${relBook.title}"/>
                                    </a>
                                </h3>
                                <p class="book-card-author">
                                    ${relBook.authorNames != null ? relBook.authorNames : 'Đang cập nhật'}
                                </p>

                                <div class="book-card-pricing">
                                    <span class="book-price-figure">
                                        $<fmt:formatNumber value="${relBook.price}" minFractionDigits="2" maxFractionDigits="2"/>
                                    </span>
                                </div>

                                <div class="book-card-actions">
                                    <a href="${pageContext.request.contextPath}/book?id=${relBook.bookId}" class="btn btn-outline btn-block btn-small">
                                        Xem Chi Tiết
                                    </a>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </div>
            </section>
        </c:if>
    </div>
</body>
</html>
