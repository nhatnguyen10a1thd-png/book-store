<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>${author == null ? 'Thêm' : 'Cập Nhật'} Tác Giả</title>
</head>
<body>
    <div class="panel">
        <h2 class="panel-title">${author == null ? 'Thêm' : 'Cập Nhật'} Tác Giả</h2>
        <form action="${pageContext.request.contextPath}/admin/author-save" method="post" style="max-width: 500px;">
            <input type="hidden" name="authorId" value="${author != null ? author.authorId : ''}">
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label>Tên Tác Giả:</label>
                <input type="text" name="authorName" value="${author != null ? author.authorName : ''}" required class="form-control" style="width: 100%; padding: 8px;">
            </div>
            
            <div class="form-group" style="margin-bottom: 15px;">
                <label>Ngày Sinh:</label>
                <input type="date" name="dateOfBirth" value="<fmt:formatDate value='${author.dateOfBirth}' pattern='yyyy-MM-dd'/>" class="form-control" style="width: 100%; padding: 8px;">
            </div>
            
            <button type="submit" class="btn-primary">Lưu</button>
            <a href="${pageContext.request.contextPath}/admin/authors" class="btn-primary" style="background: #6c757d; margin-left: 10px;">Hủy</a>
        </form>
    </div>
</body>
</html>
