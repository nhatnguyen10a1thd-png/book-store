<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>Quản Lý Sách — Back-Office</title>
</head>
<body>
    <div class="section-head" style="margin-bottom: 24px; display: flex; justify-content: space-between; align-items: flex-end;">
        <div class="section-head-title">
            <span class="eyebrow">Dữ Liệu Kho</span>
            <h1>Quản Lý Danh Mục Sách</h1>
            <p style="margin: 0; color: var(--muted);">Thêm mới, cập nhật giá, tồn kho và thông tin chi tiết của từng ấn bản.</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/admin/book-form" class="btn btn-primary">
                + Thêm Sách Mới
            </a>
        </div>
    </div>

    <div class="admin-table-wrapper">
        <table class="admin-table">
            <thead>
                <tr>
                    <th style="width: 60px;">ID</th>
                    <th style="width: 70px;">Bìa Sách</th>
                    <th>Tiêu Đề Tác Phẩm</th>
                    <th>Mã ISBN</th>
                    <th>Tác Giả</th>
                    <th>Đơn Giá</th>
                    <th style="width: 130px; text-align: right;">Thao Tác</th>
                </tr>
            </thead>
            <tbody>
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
                    <tr>
                        <td><code>#${book.bookId}</code></td>
                        <td>
                            <img src="${coverUrl}" alt="${book.title}" class="admin-thumb-img"
                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';"/>
                        </td>
                        <td>
                            <strong style="color: var(--ink); font-size: 0.95rem;"><c:out value="${book.title}"/></strong>
                            <div style="font-size: 0.78rem; color: var(--muted); margin-top: 2px;">
                                NXB: ${book.publisher} • Kho: ${book.quantity} cuốn
                            </div>
                        </td>
                        <td><code>${book.isbn}</code></td>
                        <td>${book.authorNames != null ? book.authorNames : 'Chưa gán'}</td>
                        <td>
                            <strong style="color: var(--burgundy); font-family: var(--font-serif); font-size: 1.05rem;">
                                $<fmt:formatNumber value="${book.price}" minFractionDigits="2" maxFractionDigits="2"/>
                            </strong>
                        </td>
                        <td class="admin-actions-cell" style="text-align: right;">
                            <a href="${pageContext.request.contextPath}/admin/book-form?id=${book.bookId}" class="action-edit-btn">
                                Sửa
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/book-delete?id=${book.bookId}"
                               class="action-delete-btn"
                               onclick="return confirm('Bạn có chắc chắn muốn xóa ấn bản [${book.title}] khỏi danh mục?');">
                                Xóa
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <c:if test="${totalPages > 1}">
        <nav class="editorial-pagination" aria-label="Phân trang danh mục admin">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="${pageContext.request.contextPath}/admin/books?page=${i}"
                   class="page-num-btn ${i == currentPage ? 'active' : ''}">
                    ${i}
                </a>
            </c:forEach>
        </nav>
    </c:if>
</body>
</html>
