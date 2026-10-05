<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<html>
<head>
    <title>Quản Lý Tác Giả</title>
</head>
<body>
    <div class="panel">
        <h2 class="panel-title">Quản Lý Tác Giả</h2>
        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/admin/author-form" class="btn-primary">Thêm Tác Giả Mới</a>
        </div>
        
        <table class="data-table">
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Tên Tác Giả</th>
                    <th>Ngày Sinh</th>
                    <th>Hành Động</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="author" items="${authors}">
                    <tr>
                        <td>${author.authorId}</td>
                        <td>${author.authorName}</td>
                        <td>${author.dateOfBirth}</td>
                        <td>
                            <a href="${pageContext.request.contextPath}/admin/author-form?id=${author.authorId}" style="color: #007bff; margin-right: 10px;">Sửa</a>
                            <a href="${pageContext.request.contextPath}/admin/author-delete?id=${author.authorId}" style="color: red;" onclick="return confirm('Bạn có chắc chắn muốn xóa?');">Xóa</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <div class="pagination" style="margin-top: 20px; text-align: center;">
            <c:if test="${totalPages > 1}">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <a href="${pageContext.request.contextPath}/admin/authors?page=${i}" 
                       class="btn-primary" 
                       style="${i == currentPage ? 'background: #0056b3;' : 'background: #007bff;'} margin: 0 5px; padding: 5px 10px;">${i}</a>
                </c:forEach>
            </c:if>
        </div>
    </div>
</body>
</html>
