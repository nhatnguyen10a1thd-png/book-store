<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>${author == null ? 'Thêm' : 'Cập Nhật'} Tác Giả — Back-Office</title>
</head>
<body>
    <div class="section-head" style="margin-bottom: 24px; display: flex; justify-content: space-between; align-items: flex-end;">
        <div class="section-head-title">
            <span class="eyebrow">Hồ Sơ Nhân Sự</span>
            <h1>${author == null ? 'Tạo Hồ Sơ Tác Giả Mới' : 'Cập Nhật Hồ Sơ Tác Giả'}</h1>
            <p style="margin: 0; color: var(--muted);">Cập nhật tên và ngày sinh của tác giả trong hệ thống.</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/admin/authors" class="btn btn-outline btn-small">
                &larr; Hủy &amp; Quay lại
            </a>
        </div>
    </div>

    <div class="admin-form-container" style="max-width: 580px;">
        <form action="${pageContext.request.contextPath}/admin/author-save" method="post">
            <input type="hidden" name="authorId" value="${author != null ? author.authorId : ''}">

            <div class="form-group">
                <label for="authorName">Tên Đầy Đủ Của Tác Giả / Dịch Giả *</label>
                <input type="text" id="authorName" name="authorName" value="${author != null ? author.authorName : ''}"
                       required class="form-control" placeholder="Ví dụ: Robert C. Martin, Joshua Bloch...">
            </div>

            <div class="form-group">
                <label for="dateOfBirth">Ngày Sinh (yyyy-MM-dd)</label>
                <input type="date" id="dateOfBirth" name="dateOfBirth"
                       value="<fmt:formatDate value='${author.dateOfBirth}' pattern='yyyy-MM-dd'/>" class="form-control">
            </div>

            <div class="admin-form-actions">
                <button type="submit" class="btn btn-primary btn-large">
                    Lưu Hồ Sơ Tác Giả
                </button>
                <a href="${pageContext.request.contextPath}/admin/authors" class="btn btn-outline">
                    Hủy Bỏ
                </a>
            </div>
        </form>
    </div>
</body>
</html>
