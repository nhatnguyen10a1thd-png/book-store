<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<html>
<head>
    <title>Danh Mục Sách — Toàn Bộ Ấn Bản Tuyển Chọn</title>
</head>
<body>
    <div class="section-head" style="margin-bottom: 28px;">
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
            <!-- Catalogue Search & Filter Toolbar (Item 4) -->
            <div class="catalogue-toolbar">
                <div class="catalogue-toolbar-row">
                    <div class="catalogue-search-box">
                        <svg class="catalogue-search-icon" viewBox="0 0 24 24">
                            <circle cx="11" cy="11" r="8"/>
                            <line x1="21" y1="21" x2="16.65" y2="16.65"/>
                        </svg>
                        <input type="text" id="catalogueSearchInput" class="catalogue-search-input"
                               placeholder="Tìm theo tên sách, tác giả, nhà xuất bản..." autocomplete="off">
                        <button type="button" id="catalogueSearchClear" class="catalogue-search-clear" aria-label="Xóa từ khóa">&times;</button>
                    </div>

                    <div class="catalogue-filters-group">
                        <select id="catalogueStockFilter" class="filter-select" aria-label="Lọc theo tình trạng kho">
                            <option value="all">Tất cả trạng thái kho</option>
                            <option value="in-stock">Chỉ sách còn hàng</option>
                            <option value="out-of-stock">Tạm hết hàng</option>
                        </select>

                        <select id="cataloguePriceFilter" class="filter-select" aria-label="Lọc theo mức giá">
                            <option value="all">Tất cả mức giá</option>
                            <option value="under-30">Dưới $30</option>
                            <option value="30-50">$30 – $50</option>
                            <option value="over-50">Trên $50</option>
                        </select>

                        <select id="catalogueSortFilter" class="filter-select" aria-label="Sắp xếp danh mục">
                            <option value="default">Sắp xếp: Mặc định</option>
                            <option value="price-asc">Giá: Thấp đến cao</option>
                            <option value="price-desc">Giá: Cao đến thấp</option>
                            <option value="title-asc">Tên sách: A – Z</option>
                        </select>
                    </div>
                </div>

                <div class="catalogue-status-bar">
                    <span id="catalogueResultCount">Hiển thị ${books.size()} / ${books.size()} ấn bản</span>
                    <span>Thanh toán khi nhận hàng (COD) tận nơi</span>
                </div>
            </div>

            <!-- Empty Search State -->
            <div id="catalogueEmptyState" class="catalogue-empty-state" style="display: none;">
                <h3>Không tìm thấy ấn bản phù hợp</h3>
                <p>Không có cuốn sách nào khớp với từ khóa tìm kiếm hoặc bộ lọc bạn đã chọn.</p>
                <button type="button" id="catalogueResetBtn" class="btn btn-outline btn-small">
                    Đặt Lại Bộ Lọc
                </button>
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

                    <article class="book-card-item"
                             data-title="${fn:escapeXml(book.title)}"
                             data-author="${fn:escapeXml(book.authorNames != null ? book.authorNames : '')}"
                             data-publisher="${fn:escapeXml(book.publisher != null ? book.publisher : '')}"
                             data-price="${book.price}"
                             data-stock="${book.quantity}">
                        <div class="book-cover-wrap">
                            <a href="${pageContext.request.contextPath}/book?id=${book.bookId}" aria-label="Xem chi tiết ${book.title}">
                                <img src="${coverUrl}" alt="${book.title}" class="book-cover-img" loading="lazy"
                                     onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';"/>
                            </a>
                            <c:choose>
                                <c:when test="${book.quantity <= 0}">
                                    <span class="book-stock-pill out-of-stock">Tạm hết hàng</span>
                                </c:when>
                                <c:when test="${book.quantity <= 3}">
                                    <span class="book-stock-pill" style="background: #FFF4E5; color: #B76E00; border-color: #FFE0B2;">
                                        Chỉ còn ${book.quantity} cuốn
                                    </span>
                                </c:when>
                            </c:choose>
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
