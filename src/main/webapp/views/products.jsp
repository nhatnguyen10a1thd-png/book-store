<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>Danh Sách Sách</title>
</head>
<body>
    <div class="page-header">
        <h1>Danh Mục Sách</h1>
        <c:if test="${not empty books}">
            <p>Tổng cộng: <strong>${books.size()} cuốn sách</strong></p>
        </c:if>
    </div>

    <c:choose>
        <c:when test="${not empty books}">
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Mã ISBN</th>
                        <th>Tên Sách</th>
                        <th>Nhà Xuất Bản</th>
                        <th>Giá Bán</th>
                        <th>Tồn Kho</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="book" items="${books}">
                        <tr>
                            <td><code>${book.isbn}</code></td>
                            <td style="font-weight: 500;">${book.title}</td>
                            <td>${book.publisher}</td>
                            <td style="color: var(--primary); font-weight: 600;">
                                $<fmt:formatNumber value="${book.price}" minFractionDigits="2" maxFractionDigits="2"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${book.quantity > 0}">
                                        <span style="color: green;">Còn ${book.quantity} cuốn</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: red;">Hết hàng</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:when>
        <c:otherwise>
            <div class="panel" style="text-align: center;">
                <p>Chưa có dữ liệu sách nào trong cơ sở dữ liệu.</p>
            </div>
        </c:otherwise>
    </c:choose>
</body>
</html>
