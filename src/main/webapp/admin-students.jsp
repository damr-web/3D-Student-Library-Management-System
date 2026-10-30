<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Registered Students - Admin Console");
%>
<jsp:include page="includes/header.jsp" />

<div class="container py-4">
    <div class="glass-card p-4 mb-4">
        <div class="d-flex flex-wrap justify-content-between align-items-center gap-3">
            <div>
                <span class="text-cyan text-uppercase fw-bold small" style="color: var(--primary-cyan); letter-spacing: 1px;">
                    <i class="fa-solid fa-users"></i> Member Directory
                </span>
                <h2 class="text-white fw-bold mb-1" style="font-family: var(--font-heading);">Registered Students</h2>
                <p class="text-secondary small mb-0">List of enrolled students authorized to issue library books.</p>
            </div>
            <div class="d-flex gap-2">
                <input type="text" id="tableSearch" class="form-control form-control-futuristic" placeholder="Search students..." style="width: 240px;">
                <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-glass-futuristic">
                    <i class="fa-solid fa-arrow-left"></i> Dashboard
                </a>
            </div>
        </div>
    </div>

    <div class="glass-card p-4">
        <c:choose>
            <c:when test="${not empty studentsList}">
                <div class="table-responsive">
                    <table class="table-futuristic">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Student Roll / ID</th>
                                <th>Full Name</th>
                                <th>Email Address</th>
                                <th>Department / Major</th>
                                <th>Semester</th>
                                <th>Registration Date</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="s" items="${studentsList}" varStatus="status">
                                <tr>
                                    <td class="text-secondary">${status.count}</td>
                                    <td>
                                        <span class="badge bg-dark border border-secondary text-cyan fw-bold" style="color: var(--primary-cyan);">
                                            ${s.studentId}
                                        </span>
                                    </td>
                                    <td class="fw-bold text-white">
                                        <i class="fa-solid fa-circle-user text-cyan me-1" style="color: var(--primary-cyan);"></i> ${s.name}
                                    </td>
                                    <td>
                                        <a href="mailto:${s.email}" class="text-secondary text-decoration-none hover-cyan">
                                            ${s.email}
                                        </a>
                                    </td>
                                    <td><span class="text-light">${s.department}</span></td>
                                    <td><span class="badge bg-purple-subtle text-white border border-purple" style="border-color: var(--primary-purple) !important;">${s.semester}</span></td>
                                    <td><span class="text-secondary small">${s.createdAt}</span></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 text-secondary">
                    <i class="fa-solid fa-user-graduate fa-3x mb-3"></i>
                    <h5 class="text-white">No registered students found</h5>
                    <p class="small">Students will appear here once they register on the portal.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

