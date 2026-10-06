<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<html>
<head>
    <title>Bảng Điều Khiển Quản Trị</title>
    <style>
        .admin-kpi-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
            margin-bottom: 28px;
        }
        .kpi-card {
            background: var(--paper-surface, #ffffff);
            border: 1px solid var(--border, #CEC4B4);
            border-radius: var(--radius-md, 4px);
            padding: 20px 22px;
            box-shadow: var(--shadow-panel, 0 1px 3px rgba(28, 26, 23, 0.04));
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
            transition: transform var(--transition-snappy, 0.18s ease-in-out), box-shadow var(--transition-snappy, 0.18s ease-in-out);
        }
        .kpi-card:hover {
            transform: translateY(-2px);
            box-shadow: var(--shadow-book, 0 4px 14px rgba(28, 26, 23, 0.08));
        }
        .kpi-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: var(--border, #CEC4B4);
        }
        .kpi-card.kpi-books::before { background: var(--burgundy, #642D32); }
        .kpi-card.kpi-authors::before { background: var(--antique-gold, #A78350); }
        .kpi-card.kpi-inventory::before { background: var(--forest, #28342D); }
        .kpi-card.kpi-warning::before { background: #c2410c; }
        .kpi-info { min-width: 0; }
        .kpi-label {
            font-size: 0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--muted, #726A5E);
            margin-bottom: 6px;
            font-weight: 600;
        }
        .kpi-value {
            font-family: var(--font-serif, 'Cormorant Garamond', serif);
            font-size: 2.1rem;
            font-weight: 700;
            color: var(--ink, #1C1A17);
            line-height: 1.1;
        }
        .kpi-subtext {
            font-size: 0.8rem;
            color: var(--muted, #726A5E);
            margin-top: 6px;
        }
        .kpi-icon-bubble {
            width: 44px;
            height: 44px;
            border-radius: 50%;
            background: var(--paper-light, #FAF8F3);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.3rem;
            border: 1px solid var(--border-light, #E4DCD0);
        }
        .low-stock-alert-panel {
            background: #FFFBF5;
            border: 1px solid #F6D8A8;
            border-radius: var(--radius-md, 4px);
            padding: 20px 24px;
            margin-bottom: 28px;
        }
        .low-stock-alert-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 14px;
            color: #9A5807;
        }
        .low-stock-alert-header h3 {
            font-size: 1.15rem;
            margin: 0;
        }
        @media (max-width: 1024px) {
            .admin-kpi-grid { grid-template-columns: repeat(2, 1fr); }
        }
        @media (max-width: 600px) {
            .admin-kpi-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="admin-dashboard-layout">
        <div class="section-head" style="margin-bottom: 24px;">
            <div class="section-head-title">
                <span class="eyebrow">Hệ Thống Quản Lý</span>
                <h1>Bảng Điều Khiển Trung Tâm</h1>
                <p>Tổng quan vận hành kho sách, tác giả và chỉ số kinh doanh tại BookStore.</p>
            </div>
        </div>

        <!-- 4 KPI Metric Cards (Item 8) -->
        <div class="admin-kpi-grid">
            <div class="kpi-card kpi-books">
                <div class="kpi-info">
                    <div class="kpi-label">Tổng Đầu Sách</div>
                    <div class="kpi-value">${totalBooks != null ? totalBooks : 0}</div>
                    <div class="kpi-subtext">Kho hiện có ${totalInventory != null ? totalInventory : 0} cuốn</div>
                </div>
                <div class="kpi-icon-bubble" aria-hidden="true">📚</div>
            </div>

            <div class="kpi-card kpi-authors">
                <div class="kpi-info">
                    <div class="kpi-label">Hồ Sơ Tác Giả</div>
                    <div class="kpi-value">${totalAuthors != null ? totalAuthors : 0}</div>
                    <div class="kpi-subtext">Tác giả &amp; Dịch giả liên kết</div>
                </div>
                <div class="kpi-icon-bubble" aria-hidden="true">✍️</div>
            </div>

            <div class="kpi-card kpi-warning">
                <div class="kpi-info">
                    <div class="kpi-label">Cảnh Báo Tồn Kho</div>
                    <div class="kpi-value">${not empty lowStockBooks ? lowStockBooks.size() : 0}</div>
                    <div class="kpi-subtext">${outOfStockCount != null ? outOfStockCount : 0} ấn bản đã hết hàng</div>
                </div>
                <div class="kpi-icon-bubble" aria-hidden="true">⚠️</div>
            </div>

            <div class="kpi-card kpi-inventory">
                <div class="kpi-info">
                    <div class="kpi-label">Giá Bình Quân</div>
                    <div class="kpi-value">
                        $<fmt:formatNumber value="${averagePrice != null ? averagePrice : 0}" minFractionDigits="2" maxFractionDigits="2"/>
                    </div>
                    <div class="kpi-subtext">Giá niêm yết trung bình</div>
                </div>
                <div class="kpi-icon-bubble" aria-hidden="true">🏷️</div>
            </div>
        </div>

        <!-- Low Stock Alert Panel (Item 8) -->
        <c:if test="${not empty lowStockBooks}">
            <div class="low-stock-alert-panel">
                <div class="low-stock-alert-header">
                    <span style="font-size: 1.3rem;">⚠️</span>
                    <h3>Ấn Bản Cần Bổ Sung Tồn Kho (Tồn kho &le; 5 cuốn)</h3>
                </div>
                <table class="data-table" style="margin-bottom: 0;">
                    <thead>
                        <tr>
                            <th>Mã Sách</th>
                            <th>Tựa Đề Ấn Bản</th>
                            <th>Tác Giả</th>
                            <th>Tồn Kho</th>
                            <th>Đơn Giá</th>
                            <th>Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="book" items="${lowStockBooks}">
                            <tr>
                                <td><code>#${book.bookId}</code></td>
                                <td>
                                    <strong><c:out value="${book.title}"/></strong>
                                </td>
                                <td>${book.authorNames != null ? book.authorNames : 'Đang cập nhật'}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${book.quantity <= 0}">
                                            <span class="detail-stock-badge out-of-stock">0 cuốn (Hết hàng)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="detail-stock-badge" style="background: #FFF4E5; color: #B76E00; border: 1px solid #FFE0B2;">
                                                Còn ${book.quantity} cuốn
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>$<fmt:formatNumber value="${book.price}" minFractionDigits="2" maxFractionDigits="2"/></td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/admin/book-form?id=${book.bookId}" class="btn btn-outline btn-small">
                                        Cập nhật kho
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>

        <div class="admin-grid-2col">
            <div class="admin-panel">
                <div class="admin-panel-head">
                    <h2 class="admin-panel-title">Thông Tin Quản Trị Viên</h2>
                    <span class="top-notice-badge">Đang hoạt động</span>
                </div>
                <table class="data-table" style="margin-bottom: 0;">
                    <tbody>
                        <tr>
                            <th style="width: 170px;">Họ và tên</th>
                            <td><strong>${sessionScope.user.fullname}</strong></td>
                        </tr>
                        <tr>
                            <th>Email quản trị</th>
                            <td><code>${sessionScope.user.email}</code></td>
                        </tr>
                        <tr>
                            <th>Số điện thoại</th>
                            <td>${not empty sessionScope.user.phone ? sessionScope.user.phone : "Chưa cập nhật"}</td>
                        </tr>
                        <tr>
                            <th>Vai trò phân quyền</th>
                            <td><span class="detail-stock-badge in-stock">Quản trị viên</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="admin-panel">
                <div class="admin-panel-head">
                    <h2 class="admin-panel-title">Thao Tác Quản Trị Nhanh</h2>
                </div>
                <div class="quick-action-list">
                    <a href="${pageContext.request.contextPath}/admin/books" class="quick-action-btn primary-action">
                        <span>Quản lý kho sách</span>
                        <span>&rarr;</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/authors" class="quick-action-btn">
                        <span>Quản lý hồ sơ tác giả</span>
                        <span>&rarr;</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/admin/book-form" class="quick-action-btn">
                        <span>+ Thêm sách mới vào kho</span>
                        <span>&rarr;</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/products" class="quick-action-btn">
                        <span>Xem giao diện phía độc giả</span>
                        <span>&rarr;</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="quick-action-btn" style="color: var(--state-danger-text);">
                        <span>Đăng xuất phiên làm việc</span>
                        <span>&rarr;</span>
                    </a>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
