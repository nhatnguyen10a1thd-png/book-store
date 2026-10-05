<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>Chi Tiết Sách - ${book.title}</title>
</head>
<body>
    <div class="panel">
        <div style="margin-bottom: 20px;">
            <a href="${pageContext.request.contextPath}/home" class="btn-primary">Quay lại trang chủ</a>
        </div>
        <h2 class="panel-title">Chi Tiết Sách</h2>
        
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
        <div style="display: flex; gap: 30px; margin-bottom: 40px;">
            <div style="flex: 0 0 250px;">
                <img src="${coverUrl}" alt="${book.title}" style="width: 100%; max-height: 380px; object-fit: contain; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.15);" onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/assets/images/default-book.png';"/>
            </div>
            <div style="flex: 1; font-size: 16px; line-height: 1.6;">
                <div style="font-size: 24px; font-weight: bold; margin-bottom: 15px; color: var(--primary);">Tiêu đề: ${book.title}</div>
                <div><strong>Mã isbn:</strong> ${book.isbn}</div>
                <div><strong>Tác giả:</strong> ${book.authorNames != null ? book.authorNames : 'Đang cập nhật'}</div>
                <div><strong>Publisher:</strong> ${book.publisher}</div>
                <div><strong>Publisher_date:</strong> ${book.publishDate}</div>
                <div><strong>Quantity:</strong> ${book.quantity}</div>
                <div class="book-detail-price">
                    $<fmt:formatNumber value="${book.price}" minFractionDigits="2" maxFractionDigits="2"/>
                </div>
                <div><strong>Reviews</strong> (${book.reviewCount > 0 ? book.reviewCount : 10})</div>
                <c:choose>
                    <c:when test="${book.quantity > 0}">
                        <form action="${pageContext.request.contextPath}/cart" method="post" class="detail-cart-form">
                            <input type="hidden" name="action" value="add"/>
                            <input type="hidden" name="bookId" value="${book.bookId}"/>
                            <input type="hidden" name="returnUrl" value="/book?id=${book.bookId}"/>
                            <label for="cartQuantity"><strong>Số lượng:</strong></label>
                            <input id="cartQuantity" type="number" name="quantity" value="1" min="1"
                                   max="${book.quantity}" class="quantity-input" required/>
                            <button type="submit" class="btn-primary">Thêm vào giỏ</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <p class="out-of-stock">Sản phẩm hiện đã hết hàng.</p>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <hr style="border: 0; border-top: 1px solid #eee; margin: 30px 0;">

        <h3 style="margin-bottom: 20px; font-size: 20px;">Reviews</h3>
        
        <div class="reviews-list" style="margin-bottom: 30px;">
            <c:choose>
                <c:when test="${not empty reviews}">
                    <c:forEach var="review" items="${reviews}">
                        <div style="background: #f9f9f9; padding: 15px; border-radius: 8px; margin-bottom: 10px;">
                            <strong>[${review.fullname}]:</strong> ${review.reviewText}
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p style="color: #777;">Chưa có review nào.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="review-form" style="background: #fff; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">
            <h4 style="margin-top: 0; margin-bottom: 15px;">Form thêm reviews</h4>
            <c:if test="${sessionScope.user == null}">
                <p style="color: red; margin-bottom: 10px;">Bạn cần <a href="${pageContext.request.contextPath}/login?redirect=/book?id=${book.bookId}">đăng nhập</a> để thêm review.</p>
            </c:if>
            <form action="${pageContext.request.contextPath}/book" method="post">
                <input type="hidden" name="bookId" value="${book.bookId}">
                <div class="form-group" style="margin-bottom: 15px;">
                    <textarea name="reviewText" rows="4" style="width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px;" placeholder="Nhập nội dung review..." required ${sessionScope.user == null ? 'disabled' : ''}></textarea>
                </div>
                <button type="submit" class="btn-primary" ${sessionScope.user == null ? 'disabled' : ''}>[Submit]</button>
            </form>
        </div>
    </div>
</body>
</html>
