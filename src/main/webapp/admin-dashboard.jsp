<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Admin Console - 3D Library");
%>
<jsp:include page="includes/header.jsp" />

<div class="container py-4">
    <!-- Admin Header Banner -->
    <div class="glass-card p-4 mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <span class="badge bg-purple-subtle text-purple border border-purple px-3 py-1 rounded-pill mb-2" style="color: var(--primary-purple); border-color: var(--primary-purple) !important;">
                    <i class="fa-solid fa-shield-halved"></i> Master Library Operations Center
                </span>
                <h2 class="text-white fw-bold mb-1" style="font-family: var(--font-heading);">
                    Admin Console: <span style="color: var(--primary-cyan);">${sessionScope.admin.name}</span>
                </h2>
                <p class="text-secondary small mb-0">System User: <code>${sessionScope.admin.username}</code> &bull; Email: ${sessionScope.admin.email}</p>
            </div>
            <div class="d-flex flex-wrap gap-2">
                <a href="${pageContext.request.contextPath}/manage-books" class="btn btn-primary-futuristic">
                    <i class="fa-solid fa-boxes-stacked"></i> Manage Books & Inventory
                </a>
                <a href="${pageContext.request.contextPath}/admin-students" class="btn btn-purple-futuristic">
                    <i class="fa-solid fa-users"></i> Students
                </a>
                <a href="${pageContext.request.contextPath}/admin-issues" class="btn btn-glass-futuristic">
                    <i class="fa-solid fa-handshake"></i> Issued Records
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

    <!-- Admin Metric Cards (6 Statistics) -->
    <div class="row g-4 mb-4">
        <!-- Total Titles -->
        <div class="col-xl-2 col-md-4 col-sm-6">
            <div class="stat-card-futuristic">
                <div class="stat-icon-wrapper stat-icon-cyan" style="width: 48px; height: 48px; font-size: 1.2rem;">
                    <i class="fa-solid fa-book"></i>
                </div>
                <div>
                    <div class="stat-number" style="font-size: 1.7rem;" data-target="${totalBooks}">${totalBooks}</div>
                    <div class="stat-label" style="font-size: 0.72rem;">Book Titles</div>
                </div>
            </div>
        </div>

        <!-- Total Copies -->
        <div class="col-xl-2 col-md-4 col-sm-6">
            <div class="stat-card-futuristic">
                <div class="stat-icon-wrapper stat-icon-purple" style="width: 48px; height: 48px; font-size: 1.2rem;">
                    <i class="fa-solid fa-cubes-stacked"></i>
                </div>
                <div>
                    <div class="stat-number" style="font-size: 1.7rem;" data-target="${totalCopies}">${totalCopies}</div>
                    <div class="stat-label" style="font-size: 0.72rem;">Total Copies</div>
                </div>
            </div>
        </div>

        <!-- Students -->
        <div class="col-xl-2 col-md-4 col-sm-6">
            <div class="stat-card-futuristic">
                <div class="stat-icon-wrapper stat-icon-amber" style="width: 48px; height: 48px; font-size: 1.2rem;">
                    <i class="fa-solid fa-user-graduate"></i>
                </div>
                <div>
                    <div class="stat-number" style="font-size: 1.7rem;" data-target="${totalStudents}">${totalStudents}</div>
                    <div class="stat-label" style="font-size: 0.72rem;">Students</div>
                </div>
            </div>
        </div>

        <!-- Active Issues -->
        <div class="col-xl-2 col-md-4 col-sm-6">
            <div class="stat-card-futuristic">
                <div class="stat-icon-wrapper stat-icon-cyan" style="width: 48px; height: 48px; font-size: 1.2rem;">
                    <i class="fa-solid fa-hand-holding-hand"></i>
                </div>
                <div>
                    <div class="stat-number" style="font-size: 1.7rem;" data-target="${activeIssues}">${activeIssues}</div>
                    <div class="stat-label" style="font-size: 0.72rem;">Active Issues</div>
                </div>
            </div>
        </div>

        <!-- Returned Count -->
        <div class="col-xl-2 col-md-4 col-sm-6">
            <div class="stat-card-futuristic">
                <div class="stat-icon-wrapper stat-icon-emerald" style="width: 48px; height: 48px; font-size: 1.2rem;">
                    <i class="fa-solid fa-circle-check"></i>
                </div>
                <div>
                    <div class="stat-number" style="font-size: 1.7rem;" data-target="${returnedCount}">${returnedCount}</div>
                    <div class="stat-label" style="font-size: 0.72rem;">Returned</div>
                </div>
            </div>
        </div>

        <!-- Overdue Count -->
        <div class="col-xl-2 col-md-4 col-sm-6">
            <div class="stat-card-futuristic">
                <div class="stat-icon-wrapper stat-icon-rose" style="width: 48px; height: 48px; font-size: 1.2rem;">
                    <i class="fa-solid fa-triangle-exclamation"></i>
                </div>
                <div>
                    <div class="stat-number" style="font-size: 1.7rem;" data-target="${overdueCount}">${overdueCount}</div>
                    <div class="stat-label" style="font-size: 0.72rem;">Overdue</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Active Issued Records Overview -->
    <div class="glass-card p-4 mb-4">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h4 class="text-white fw-bold mb-0" style="font-family: var(--font-heading);">
                <i class="fa-solid fa-list-check text-cyan me-2" style="color: var(--primary-cyan);"></i> Active Borrowing Operations
            </h4>
            <a href="${pageContext.request.contextPath}/admin-issues" class="btn btn-sm btn-glass-futuristic">
                View All Records
            </a>
        </div>

        <c:choose>
            <c:when test="${not empty recentIssues}">
                <div class="table-responsive">
                    <table class="table-futuristic">
                        <thead>
                            <tr>
                                <th>Student</th>
                                <th>Book Title</th>
                                <th>Issue Date</th>
                                <th>Due Date</th>
                                <th>Status</th>
                                <th>Fine Due</th>
                                <th class="text-end">Action</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${recentIssues}" end="5">
                                <tr>
                                    <td>
                                        <div class="fw-bold text-white">${item.studentName}</div>
                                        <div class="text-secondary small">${item.studentIdStr} &bull; ${item.studentDept}</div>
                                    </td>
                                    <td>
                                        <div class="text-white fw-semibold">${item.bookTitle}</div>
                                        <span class="badge bg-dark border border-secondary text-info">${item.bookCategory}</span>
                                    </td>
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
                                                    <i class="fa-solid fa-triangle-exclamation"></i> Overdue (${Math.abs(item.daysRemaining)}d)
                                                </span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge-status badge-status-issued">
                                                    <i class="fa-solid fa-clock"></i> Active (${item.daysRemaining}d left)
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
                                        <form action="${pageContext.request.contextPath}/return-book" method="post" class="d-inline" onsubmit="return confirm('Process return of book for ${item.studentName}?');">
                                            <input type="hidden" name="issueId" value="${item.id}">
                                            <input type="hidden" name="bookId" value="${item.bookId}">
                                            <input type="hidden" name="studentId" value="${item.studentId}">
                                            <button type="submit" class="btn btn-sm btn-danger-futuristic">
                                                <i class="fa-solid fa-rotate-left"></i> Process Return
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
                <div class="text-center py-4 text-secondary">
                    <i class="fa-solid fa-check-circle fa-2x mb-2 text-success"></i>
                    <p class="mb-0">No active books currently issued. All volumes returned!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

