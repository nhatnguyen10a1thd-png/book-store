<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quản Lý Sách</title>
</head>
<body>
    <div class="panel">
        <h2 class="panel-title">Quản Lý Sách</h2>
        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/admin/book-form" class="btn-primary">Thêm Sách Mới</a>
        </div>
        
        <table class="data-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Hình Ảnh</th>
                    <th>Tiêu Đề</th>
                    <th>ISBN</th>
                    <th>Tác Giả</th>
                    <th>Giá</th>
                    <th>Hành Động</th>
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
                        <td>${book.bookId}</td>
                        <td>
                            <img src="${coverUrl}" alt="${book.title}" style="width: 50px; height: 75px; object-fit: contain; background: #f8f9fa; border-radius: 4px; box-shadow: 0 1px 3px rgba(0,0,0,0.1);" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';"/>
                        </td>
                        <td>${book.title}</td>
                        <td>${book.isbn}</td>
                        <td>${book.authorNames != null ? book.authorNames : ''}</td>
                        <td>${book.price}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/book-form?id=${book.bookId}" style="color: #007bff; margin-right: 10px;">Sửa</a>
                            <a href="${pageContext.request.contextPath}/admin/book-delete?id=${book.bookId}" style="color: red;" onclick="return confirm('Bạn có chắc chắn muốn xóa?');">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <div class="pagination" style="margin-top: 20px; text-align: center;">
            <c:if test="${totalPages > 1}">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/admin/books?page=${i}" 
                       class="btn-primary" 
                       style="${i == currentPage ? 'background: #0056b3;' : 'background: #007bff;'} margin: 0 5px; padding: 5px 10px;">${i}</a>
                </c:forEach>
            </c:if>
        </div>
    </div>
</body>
</html>
