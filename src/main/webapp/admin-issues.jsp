<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Issued Records & Circulation - Admin Console");
%>
<jsp:include page="includes/header.jsp" />

<div class="container py-4">
    <div class="glass-card p-4 mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <span class="text-cyan text-uppercase fw-bold small" style="color: var(--primary-cyan); letter-spacing: 1px;">
                    <i class="fa-solid fa-handshake"></i> Circulation Desk
                </span>
                <h2 class="text-white fw-bold mb-1" style="font-family: var(--font-heading);">Issued & Returned Books</h2>
                <p class="text-secondary small mb-0">Track active checkouts, overdue penalties, and historical returns across all students.</p>
            </div>
            <div class="d-flex gap-2">
                <input type="text" id="tableSearch" class="form-control form-control-futuristic" placeholder="Search circulation..." style="width: 220px;">
                <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-glass-futuristic">
                    <i class="fa-solid fa-arrow-left"></i> Dashboard
                </a>
            </div>
        </div>

        <hr class="border-secondary my-3 opacity-25">

        <!-- Filter View Tabs -->
        <div class="d-flex flex-wrap gap-2">
            <a href="${pageContext.request.contextPath}/admin-issues?view=active" 
               class="btn ${activeTab == 'active' || empty activeTab ? 'btn-primary-futuristic' : 'btn-glass-futuristic'} btn-sm">
                <i class="fa-solid fa-book-bookmark"></i> Active Issues
            </a>
            <a href="${pageContext.request.contextPath}/admin-issues?view=overdue" 
               class="btn ${activeTab == 'overdue' ? 'btn-danger-futuristic' : 'btn-glass-futuristic'} btn-sm">
                <i class="fa-solid fa-triangle-exclamation"></i> Overdue Books
            </a>
            <a href="${pageContext.request.contextPath}/admin-issues?view=returned" 
               class="btn ${activeTab == 'returned' ? 'btn-primary-futuristic' : 'btn-glass-futuristic'} btn-sm">
                <i class="fa-solid fa-circle-check"></i> Returned Archive
            </a>
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

    <!-- Issued Records Table -->
    <div class="glass-card p-4">
        <c:choose>
            <c:when test="${not empty issuedBooksList}">
                <div class="table-responsive">
                    <table class="table-futuristic">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Student</th>
                                <th>Book Title</th>
                                <th>Issue Date</th>
                                <th>Due Date</th>
                                <th>Return Date</th>
                                <th>Status</th>
                                <th>Fine</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${issuedBooksList}" varStatus="status">
                                <tr>
                                    <td class="text-secondary">${status.count}</td>
                                    <td>
                                        <div class="fw-bold text-white">${item.studentName}</div>
                                        <div class="text-secondary small">${item.studentIdStr} &bull; ${item.studentDept}</div>
                                    </td>
                                    <td>
                                        <div class="d-flex align-items-center gap-2">
                                            <img src="${item.bookCover}" alt="${item.bookTitle}" class="rounded-2" style="width: 32px; height: 44px; object-fit: cover;" onerror="this.src='https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400'">
                                            <div>
                                                <div class="text-white fw-semibold">${item.bookTitle}</div>
                                                <div class="text-secondary small">by ${item.bookAuthor}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="text-secondary">${item.issueDate}</span></td>
                                    <td>
                                        <span class="${item.overdue ? 'text-danger fw-bold' : 'text-white'}">
                                            ${item.dueDate}
                                        </span>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.returnDate}">
                                                <span class="text-success"><i class="fa-solid fa-check me-1"></i> ${item.returnDate}</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="text-muted small">&mdash; Pending &mdash;</span>
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
                                                    <i class="fa-solid fa-triangle-exclamation"></i> OVERDUE (${Math.abs(item.daysRemaining)}d)
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-status badge-status-issued">
                                                    <i class="fa-solid fa-clock"></i> ACTIVE (${item.daysRemaining}d left)
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
                                        <c:choose>
                                            <c:when test="${item.status != 'RETURNED'}">
                                                <form action="${pageContext.request.contextPath}/return-book" method="post" class="d-inline" onsubmit="return confirm('Process return of book for ${item.studentName}?');">
                                                    <input type="hidden" name="issueId" value="${item.id}">
                                                    <input type="hidden" name="bookId" value="${item.bookId}">
                                                    <input type="hidden" name="studentId" value="${item.studentId}">
                                                    <button type="submit" class="btn btn-sm btn-danger-futuristic">
                                                        <i class="fa-solid fa-rotate-left"></i> Return Book
                                                    </button>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary border border-secondary small">
                                                    Archived
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 text-secondary">
                    <i class="fa-solid fa-handshake fa-3x mb-3"></i>
                    <h5 class="text-white">No records found</h5>
                    <p class="small">There are currently no records under this category.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

