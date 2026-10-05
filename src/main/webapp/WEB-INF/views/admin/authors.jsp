<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>Quản Lý Tác Giả — Back-Office</title>
</head>
<body>
    <div class="section-head" style="margin-bottom: 24px; display: flex; justify-content: space-between; align-items: flex-end;">
        <div class="section-head-title">
            <span class="eyebrow">Hồ Sơ Nhân Sự</span>
            <h1>Quản Lý Tác Giả &amp; Dịch Giả</h1>
            <p style="margin: 0; color: var(--muted);">Danh sách tác giả chuyên môn được liên kết với các ấn bản trong kho.</p>
        </div>
        <div>
            <a href="${pageContext.request.contextPath}/admin/author-form" class="btn btn-primary">
                + Thêm Tác Giả Mới
            </a>
        </div>
    </div>

    <div class="admin-table-wrapper">
        <table class="admin-table">
            <thead>
                <tr>
                    <th style="width: 70px;">Mã ID</th>
                    <th>Tên Tác Giả / Dịch Giả</th>
                    <th>Ngày Sinh</th>
                    <th style="width: 140px; text-align: right;">Thao Tác</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="author" items="${authors}">
                    <tr>
                        <td><code>#${author.authorId}</code></td>
                        <td>
                            <strong style="color: var(--ink); font-size: 0.95rem;">
                                <c:out value="${author.authorName}"/>
                            </strong>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty author.dateOfBirth}">
                                    <fmt:formatDate value="${author.dateOfBirth}" pattern="dd/MM/yyyy"/>
                                </c:when>
                                <c:otherwise>
                                    <span style="color: var(--muted-light);">Chưa cập nhật</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="admin-actions-cell" style="text-align: right;">
                            <a href="${pageContext.request.contextPath}/admin/author-form?id=${author.authorId}" class="action-edit-btn">
                                Sửa
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/author-delete?id=${author.authorId}"
                               class="action-delete-btn"
                               onclick="return confirm('Bạn có chắc chắn muốn xóa tác giả [${author.authorName}]?');">
                                Xóa
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <c:if test="${totalPages > 1}">
        <nav class="editorial-pagination" aria-label="Phân trang tác giả admin">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <a href="${pageContext.request.contextPath}/admin/authors?page=${i}"
                   class="page-num-btn ${i == currentPage ? 'active' : ''}">
                    ${i}
                </a>
            </c:forEach>
        </nav>
    </c:if>
</body>
</html>
