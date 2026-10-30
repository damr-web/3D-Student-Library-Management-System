<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Student Dashboard - 3D Library");
%>
<jsp:include page="includes/header.jsp" />

<div class="container py-4">
    <!-- Welcome Header Banner -->
    <div class="glass-card p-4 mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-1 rounded-pill mb-2">
                    <i class="fa-solid fa-graduation-cap"></i> ${sessionScope.student.department} &bull; ${sessionScope.student.semester}
                </span>
                <h2 class="text-white fw-bold mb-1" style="font-family: var(--font-heading);">
                    Welcome back, <span class="gradient-text">${sessionScope.student.name}</span>!
                </h2>
                <p class="text-secondary small mb-0">Student ID: <span class="text-white">${sessionScope.student.studentId}</span> &bull; Email: ${sessionScope.student.email}</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/books" class="btn btn-primary-futuristic">
                    <i class="fa-solid fa-book-medical"></i> Borrow New Book
                </a>
                <a href="${pageContext.request.contextPath}/history" class="btn btn-glass-futuristic">
                    <i class="fa-solid fa-clock-rotate-left"></i> History
                </a>
            </div>
        </div>
    </div>

    <!-- Flash Message Handling -->
    <c:if test="${not empty sessionScope.successMessage}">
        <div class="alert-futuristic alert-futuristic-success">
            <i class="fa-solid fa-circle-check"></i>
            <span>${sessionScope.successMessage}</span>
        </div>
        <c:remove var="successMessage" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="alert-futuristic alert-futuristic-danger">
            <i class="fa-solid fa-triangle-exclamation"></i>
            <span>${sessionScope.errorMessage}</span>
        </div>
        <c:remove var="errorMessage" scope="session"/>
    </c:if>

    <!-- Student Dashboard Metric Cards -->
    <div class="row g-4 mb-4">
        <!-- Total Borrowed -->
        <div class="col-lg-3 col-sm-6">
            <div class="stat-card-futuristic">
                <div class="stat-icon-wrapper stat-icon-cyan">
                    <i class="fa-solid fa-book-bookmark"></i>
                </div>
                <div>
                    <div class="stat-number" data-target="${totalBorrowed}">${totalBorrowed}</div>
                    <div class="stat-label">Total Borrowed</div>
                </div>
            </div>
        </div>

        <!-- Currently Issued -->
        <div class="col-lg-3 col-sm-6">
            <div class="stat-card-futuristic">
                <div class="stat-icon-wrapper stat-icon-purple">
                    <i class="fa-solid fa-book-reader"></i>
                </div>
                <div>
                    <div class="stat-number" data-target="${currentlyIssued}">${currentlyIssued}</div>
                    <div class="stat-label">Currently Issued</div>
                </div>
            </div>
        </div>

        <!-- Returned Books -->
        <div class="col-lg-3 col-sm-6">
            <div class="stat-card-futuristic">
                <div class="stat-icon-wrapper stat-icon-emerald">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
                <div>
                    <div class="stat-number" data-target="${returnedBooks}">${returnedBooks}</div>
                    <div class="stat-label">Returned Books</div>
                </div>
            </div>
        </div>

        <!-- Overdue Books -->
        <div class="col-lg-3 col-sm-6">
            <div class="stat-card-futuristic">
                <div class="stat-icon-wrapper stat-icon-rose">
                    <i class="fa-solid fa-bell"></i>
                </div>
                <div>
                    <div class="stat-number" data-target="${overdueBooks}">${overdueBooks}</div>
                    <div class="stat-label">Overdue Books</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Currently Active Issued Books Section -->
    <div class="glass-card p-4 mb-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-white fw-bold mb-0" style="font-family: var(--font-heading);">
                <i class="fa-solid fa-hand-holding-hand text-cyan me-2" style="color: var(--primary-cyan);"></i> My Currently Issued Books
            </h4>
            <a href="${pageContext.request.contextPath}/my-books" class="btn btn-sm btn-glass-futuristic">
                View All Details
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty activeIssuedBooks}">
                <div class="table-responsive">
                    <table class="table-futuristic">
                        <thead>
                            <tr>
                                <th>Book Title</th>
                                <th>Category</th>
                                <th>Issue Date</th>
                                <th>Due Date</th>
                                <th>Status / Timeline</th>
                                <th>Fine Due</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${activeIssuedBooks}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <img src="${item.bookCover}" alt="${item.bookTitle}" class="rounded-2" style="width: 38px; height: 50px; object-fit: cover;" onerror="this.src='https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400'">
                                            <div>
                                                <div class="fw-bold text-white">${item.bookTitle}</div>
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
                                                    <i class="fa-solid fa-triangle-exclamation"></i> Overdue by ${Math.abs(item.daysRemaining)} days
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-status badge-status-issued">
                                                    <i class="fa-solid fa-hourglass-half"></i> ${item.daysRemaining} days remaining
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
                    <h5 class="text-white">No books currently borrowed</h5>
                    <p class="text-secondary small mb-3">You don't have any pending returns. Explore our 3D library catalog to issue a book!</p>
                    <a href="${pageContext.request.contextPath}/books" class="btn btn-primary-futuristic">
                        <i class="fa-solid fa-magnifying-glass"></i> Browse Catalog
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Recently Added Books Section -->
    <div class="mb-5">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-white fw-bold mb-0" style="font-family: var(--font-heading);">
                <i class="fa-solid fa-sparkles text-cyan me-2" style="color: var(--primary-cyan);"></i> Recently Added Books
            </h4>
            <a href="${pageContext.request.contextPath}/books" class="btn btn-sm btn-glass-futuristic">Explore All</a>
        </div>

        <div class="row g-4">
            <c:forEach var="book" items="${recentBooks}">
                <div class="col-lg-4 col-md-6">
                    <div class="book-card-futuristic">
                        <div class="book-cover-wrapper" style="height: 180px;">
                            <img src="${book.coverImage}" alt="${book.title}" class="book-cover-img" onerror="this.src='https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400'">
                            <span class="book-category-badge">${book.category}</span>
                        </div>
                        <div class="book-card-body">
                            <h5 class="book-title" style="font-size: 1rem;">${book.title}</h5>
                            <p class="book-author small mb-2"><i class="fa-solid fa-pen-nib me-1"></i> ${book.author}</p>
                            <div class="book-card-footer">
                                <span class="small ${book.availableCopies > 0 ? 'text-success' : 'text-danger'}">
                                    <i class="fa-solid fa-circle" style="font-size: 0.5rem;"></i> ${book.availableCopies} Copies Available
                                </span>
                                <a href="${pageContext.request.contextPath}/book-details?id=${book.id}" class="btn btn-sm btn-primary-futuristic">
                                    View Details
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

