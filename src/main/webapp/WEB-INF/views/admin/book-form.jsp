<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>${book == null ? 'Thêm' : 'Cập Nhật'} Sách — Back-Office</title>
</head>
<body>
    <div class="section-head" style="margin-bottom: 24px; display: flex; justify-content: space-between; align-items: flex-end;">
        <div class="section-head-title">
            <span class="eyebrow">Hồ Sơ Ấn Bản</span>
            <h1>${book == null ? 'Khởi Tạo Ấn Bản Sách Mới' : 'Cập Nhật Hồ Sơ Sách'}</h1>
            <p style="margin: 0; color: var(--muted);">Cập nhật thông tin cuốn sách hiển thị trong cửa hàng.</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-outline btn-small">
                &larr; Hủy &amp; Quay lại
            </a>
        </div>
    </div>

    <div class="admin-form-container">
        <form action="${pageContext.request.contextPath}/admin/book-save" method="post">
            <input type="hidden" name="bookId" value="${book != null ? book.bookId : ''}">

            <div class="admin-form-grid">
                <div class="form-group">
                    <label for="isbn">Mã ISBN Quốc Tế *</label>
                    <input type="text" id="isbn" name="isbn" value="${book != null ? book.isbn : ''}" required class="form-control" placeholder="978-0132350884">
                </div>

                <div class="form-group">
                    <label for="title">Tiêu Đề Ấn Bản *</label>
                    <input type="text" id="title" name="title" value="${book != null ? book.title : ''}" required class="form-control" placeholder="Tên cuốn sách">
                </div>

                <div class="form-group admin-form-full">
                    <label for="authorIds">Tác Giả (Giữ phím Ctrl hoặc Cmd để chọn nhiều tác giả):</label>
                    <select id="authorIds" name="authorIds" multiple class="form-control" style="height: 110px;">
                        <c:forEach var="author" items="${authors}">
                            <option value="${author.authorId}">${author.authorName}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="publisher">Nhà Xuất Bản</label>
                    <input type="text" id="publisher" name="publisher" value="${book != null ? book.publisher : ''}" class="form-control" placeholder="Pearson, O'Reilly, Addison-Wesley...">
                </div>

                <div class="form-group">
                    <label for="publishDate">Ngày Phát Hành (yyyy-MM-dd)</label>
                    <input type="date" id="publishDate" name="publishDate"
                           value="<fmt:formatDate value='${book.publishDate}' pattern='yyyy-MM-dd'/>" class="form-control">
                </div>

                <div class="form-group">
                    <label for="price">Giá Bán ($) *</label>
                    <input type="number" step="0.01" id="price" name="price" value="${book != null ? book.price : ''}" required class="form-control" placeholder="29.99">
                </div>

                <div class="form-group">
                    <label for="quantity">Số Lượng Trong Kho *</label>
                    <input type="number" id="quantity" name="quantity" value="${book != null ? book.quantity : '0'}" required class="form-control" placeholder="10">
                </div>

                <div class="form-group admin-form-full">
                    <label for="coverImageInput">Tên File Ảnh Bìa Hoặc Liên Kết (URL):</label>
                    <input type="text" name="coverImage" id="coverImageInput" value="${book != null ? book.coverImage : ''}"
                           placeholder="clean-code.jpg hoặc https://..." class="form-control">

                    <c:if test="${not empty book.coverImage}">
                        <c:set var="cover" value="${book.coverImage}" />
                        <c:choose>
                            <c:when test="${cover.startsWith('http://') || cover.startsWith('https://') || cover.startsWith('data:')}">
                                <c:set var="prevUrl" value="${cover}" />
                            </c:when>
                            <c:when test="${cover.startsWith('/')}">
                                <c:set var="prevUrl" value="${pageContext.request.contextPath}${cover}" />
                            </c:when>
                            <c:when test="${cover.startsWith('assets/')}">
                                <c:set var="prevUrl" value="${pageContext.request.contextPath}/${cover}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="prevUrl" value="${pageContext.request.contextPath}/assets/images/${cover}" />
                            </c:otherwise>
                        </c:choose>
                        <div class="admin-cover-preview-box">
                            <img src="${prevUrl}" alt="Ảnh bìa xem trước" class="admin-cover-preview-img"
                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';">
                            <div>
                                <strong style="display: block; font-size: 0.88rem; color: var(--ink);">Ảnh bìa hiện tại</strong>
                                <span style="font-size: 0.78rem; color: var(--muted);">${book.coverImage}</span>
                            </div>
                        </div>
                    </c:if>
                </div>

                <div class="form-group admin-form-full">
                    <label for="description">Lời Tựa &amp; Mô Tả Tác Phẩm:</label>
                    <textarea id="description" name="description" rows="4" class="form-control"
                              placeholder="Nội dung tóm tắt, mục lục chính hoặc giá trị học thuật của ấn phẩm...">${book != null ? book.description : ''}</textarea>
                </div>
            </div>

            <div class="admin-form-actions">
                <button type="submit" class="btn btn-primary btn-large">
                    Lưu Thông Tin Sách
                </button>
                <a href="${pageContext.request.contextPath}/admin/books" class="btn btn-outline">
                    Hủy Bỏ
                </a>
            </div>
        </form>
    </div>
</body>
</html>
