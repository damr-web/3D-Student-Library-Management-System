<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "My Issued Books - 3D Library");
%>
<jsp:include page="includes/header.jsp" />

<div class="container py-4">
    <div class="glass-card p-4 mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <span class="text-cyan text-uppercase fw-bold small" style="color: var(--primary-cyan); letter-spacing: 1px;">
                    <i class="fa-solid fa-book-reader"></i> Student Portfolio
                </span>
                <h2 class="text-white fw-bold mb-1" style="font-family: var(--font-heading);">My Borrowed Books</h2>
                <p class="text-secondary small mb-0">Active books currently in your possession. Return books on or before due date to avoid late fines.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/books" class="btn btn-primary-futuristic">
                    <i class="fa-solid fa-plus"></i> Issue More Books
                </a>
                <a href="${pageContext.request.contextPath}/history" class="btn btn-glass-futuristic">
                    <i class="fa-solid fa-clock-rotate-left"></i> Return History
                </a>
            </div>
        </div>
    </div>

    <!-- Alert / Flash Messages -->
    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert-futuristic alert-futuristic-danger">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <span>${sessionScope.errorMessage}</span>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert-futuristic alert-futuristic-success">
            <i class="fa-solid fa-circle-check"></i>
            <span>${sessionScope.successMessage}</span>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <div class="glass-card p-4">
        <c:choose>
            <c:when test="${not empty activeBooks}">
                <div class="table-responsive">
                    <table class="table-futuristic">
                        <thead>
                            <tr>
                                <th>Book Details</th>
                                <th>Category</th>
                                <th>Issue Date</th>
                                <th>Due Date</th>
                                <th>Status / Timeline</th>
                                <th>Overdue Fine</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${activeBooks}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <img src="${item.bookCover}" alt="${item.bookTitle}" class="rounded-2" style="width: 44px; height: 60px; object-fit: cover;" onerror="this.src='https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400'">
                                            <div>
                                                <a href="${pageContext.request.contextPath}/book-details?id=${item.bookId}" class="fw-bold text-white text-decoration-none hover-cyan">
                                                    ${item.bookTitle}
                                                </a>
                                                <div class="text-secondary small">by ${item.bookAuthor}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge bg-dark border border-secondary text-info">${item.bookCategory}</span></td>
                                    <td><span class="text-secondary">${item.issueDate}</span></td>
                                    <td>
                                        <span class="${item.overdue ? 'text-danger fw-bold' : 'text-white'}">
                                            ${item.dueDate}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${item.overdue}">
                                                <span class="badge-status badge-status-overdue">
                                                    <i class="fa-solid fa-triangle-exclamation"></i> Overdue (${Math.abs(item.daysRemaining)} days)
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-status badge-status-issued">
                                                    <i class="fa-solid fa-clock"></i> ${item.daysRemaining} days left
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <span class="${item.fine > 0 ? 'text-danger fw-bold' : 'text-muted'}">
                                            ₹${item.fine}
                                        </span>
                                    </td>
                                    <td class="text-end">
                                        <form action="${pageContext.request.contextPath}/return-book" method="post" class="d-inline" onsubmit="return confirm('Confirm returning: ${item.bookTitle}?');">
                                            <input type="hidden" name="issueId" value="${item.id}">
                                            <input type="hidden" name="bookId" value="${item.bookId}">
                                            <button type="submit" class="btn btn-sm btn-danger-futuristic">
                                                <i class="fa-solid fa-rotate-left"></i> Return Book
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5">
                    <i class="fa-solid fa-book-open-reader fa-3x text-secondary mb-3"></i>
                    <h4 class="text-white">You have no active issued books</h4>
                    <p class="text-secondary small mb-4">Ready to learn something new? Browse our futuristic 3D catalog and issue a book today.</p>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-primary-futuristic">
                        <i class="fa-solid fa-magnifying-glass"></i> Browse Catalog
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

