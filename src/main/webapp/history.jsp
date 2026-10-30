<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Borrowing History - 3D Library");
%>
<jsp:include page="includes/header.jsp" />

<div class="container py-4">
    <div class="glass-card p-4 mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <span class="text-cyan text-uppercase fw-bold small" style="color: var(--primary-cyan); letter-spacing: 1px;">
                    <i class="fa-solid fa-clock-rotate-left"></i> Archive & Logs
                </span>
                <h2 class="text-white fw-bold mb-1" style="font-family: var(--font-heading);">Borrowing History</h2>
                <p class="text-secondary small mb-0">Complete historical record of all books borrowed and returned by you.</p>
            </div>
            <div class="d-flex gap-2">
                <input type="text" id="tableSearch" class="form-control form-control-futuristic" placeholder="Filter history..." style="width: 220px;">
                <a href="${pageContext.request.contextPath}/books" class="btn btn-primary-futuristic">
                    <i class="fa-solid fa-plus"></i> Issue Book
                </a>
            </div>
        </div>
    </div>

    <div class="glass-card p-4">
        <c:choose>
            <c:when test="${not empty historyBooks}">
                <div class="table-responsive">
                    <table class="table-futuristic">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Book Title & Author</th>
                                <th>Category</th>
                                <th>Issued On</th>
                                <th>Due Date</th>
                                <th>Returned On</th>
                                <th>Status</th>
                                <th>Fine Paid</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${historyBooks}" varStatus="status">
                                <tr>
                                    <td class="text-secondary">${status.count}</td>
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <img src="${item.bookCover}" alt="${item.bookTitle}" class="rounded-2" style="width: 36px; height: 50px; object-fit: cover;" onerror="this.src='https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400'">
                                            <div>
                                                <div class="fw-bold text-white">${item.bookTitle}</div>
                                                <div class="text-secondary small">by ${item.bookAuthor}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge bg-dark border border-secondary text-info">${item.bookCategory}</span></td>
                                    <td><span class="text-secondary">${item.issueDate}</span></td>
                                    <td><span class="text-secondary">${item.dueDate}</span></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.returnDate}">
                                                <span class="text-success fw-semibold"><i class="fa-solid fa-check-double me-1"></i> ${item.returnDate}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-warning small"><i class="fa-solid fa-hourglass-start me-1"></i> Still in possession</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.status == 'RETURNED'}">
                                                <span class="badge-status badge-status-returned">
                                                    <i class="fa-solid fa-check"></i> RETURNED
                                                </span>
                                            </c:when>
                                            <c:when test="${item.overdue}">
                                                <span class="badge-status badge-status-overdue">
                                                    <i class="fa-solid fa-triangle-exclamation"></i> OVERDUE
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-status badge-status-issued">
                                                    <i class="fa-solid fa-book-bookmark"></i> ACTIVE
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="${item.fine > 0 ? 'text-danger fw-bold' : 'text-muted'}">
                                            ₹${item.fine}
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <i class="fa-solid fa-folder-open fa-3x text-secondary mb-3"></i>
                    <h4 class="text-white">No historical borrowing records</h4>
                    <p class="text-secondary small mb-4">You have not returned any books yet.</p>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-primary-futuristic">
                        <i class="fa-solid fa-magnifying-glass"></i> Browse Catalog
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

