<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>${book == null ? 'Thêm' : 'Cập Nhật'} Sách</title>
</head>
<body>
    <div class="panel">
        <h2 class="panel-title">${book == null ? 'Thêm' : 'Cập Nhật'} Sách</h2>
        <form action="${pageContext.request.contextPath}/admin/book-save" method="post" style="max-width: 600px;">
            <input type="hidden" name="bookId" value="${book != null ? book.bookId : ''}">
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label>ISBN:</label>
                <input type="text" name="isbn" value="${book != null ? book.isbn : ''}" required class="form-control" style="width: 100%; padding: 8px;">
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label>Tiêu Đề:</label>
                <input type="text" name="title" value="${book != null ? book.title : ''}" required class="form-control" style="width: 100%; padding: 8px;">
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label>Tác Giả (giữ Ctrl để chọn nhiều):</label>
                <select name="authorIds" multiple class="form-control" style="width: 100%; padding: 8px; height: 100px;">
                    <c:forEach var="author" items="${authors}">
                        <!-- For a full implementation, you would mark the authors that belong to the book as 'selected' -->
                        <option value="${author.authorId}">${author.authorName}</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label>Nhà Xuất Bản:</label>
                <input type="text" name="publisher" value="${book != null ? book.publisher : ''}" class="form-control" style="width: 100%; padding: 8px;">
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label>Ngày Xuất Bản:</label>
                <input type="date" name="publishDate" value="<fmt:formatDate value='${book.publishDate}' pattern='yyyy-MM-dd'/>" class="form-control" style="width: 100%; padding: 8px;">
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label>Giá:</label>
                <input type="number" step="0.01" name="price" value="${book != null ? book.price : ''}" required class="form-control" style="width: 100%; padding: 8px;">
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label>Số Lượng:</label>
                <input type="number" name="quantity" value="${book != null ? book.quantity : '0'}" required class="form-control" style="width: 100%; padding: 8px;">
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label>Hình Ảnh (Tên file hoặc URL):</label>
                <input type="text" name="coverImage" id="coverImageInput" value="${book != null ? book.coverImage : ''}" placeholder="clean-code.jpg hoặc https://..." class="form-control" style="width: 100%; padding: 8px;">
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
                    <div style="margin-top: 10px;">
                        <span style="font-size: 13px; color: #666;">Xem trước hình ảnh:</span><br>
                        <img id="imagePreview" src="${prevUrl}" alt="Preview" style="max-height: 120px; border-radius: 4px; border: 1px solid #ddd; margin-top: 5px;" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';">
                    </div>
                </c:if>
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label>Mô Tả:</label>
                <textarea name="description" rows="4" class="form-control" style="width: 100%; padding: 8px;">${book != null ? book.description : ''}</textarea>
            </div>
            
            <button type="submit" class="btn-primary">Lưu</button>
            <a href="${pageContext.request.contextPath}/admin/books" class="btn-primary" style="background: #6c757d; margin-left: 10px;">Hủy</a>
        </form>
    </div>
</body>
</html>
