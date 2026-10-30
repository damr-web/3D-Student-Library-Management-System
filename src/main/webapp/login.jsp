<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Student Login - 3D Library");
%>
<jsp:include page="includes/header.jsp" />

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-5 col-md-8">
            <div class="glass-card p-4 p-md-5">
                <div class="text-center mb-4">
                    <div class="stat-icon-wrapper stat-icon-cyan mx-auto mb-3">
                        <i class="fa-solid fa-user-astronaut"></i>
                    </div>
                    <h3 class="text-white fw-bold mb-1" style="font-family: var(--font-heading);">Student Portal</h3>
                    <p class="text-secondary small">Access your borrowed books, borrowing history, and digital issues.</p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert-futuristic alert-futuristic-danger">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <span>${errorMessage}</span>
                    </div>
                </c:if>

                <c:if test="${not empty successMessage}">
                    <div class="alert-futuristic alert-futuristic-success">
                        <i class="fa-solid fa-circle-check"></i>
                        <span>${successMessage}</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post">
                    <input type="hidden" name="role" value="student">

                    <div class="mb-3">
                        <label for="email" class="form-label-futuristic">
                            <i class="fa-solid fa-envelope me-1 text-cyan" style="color: var(--primary-cyan);"></i> Student Email Address
                        </label>
                        <input type="email" class="form-control form-control-futuristic" id="email" name="email" 
                               value="${email}" placeholder="e.g. aarav.sharma@student.edu" required autofocus>
                    </div>

                    <div class="mb-4">
                        <label for="password" class="form-label-futuristic">
                            <i class="fa-solid fa-key me-1 text-cyan" style="color: var(--primary-cyan);"></i> Password
                        </label>
                        <input type="password" class="form-control form-control-futuristic" id="password" name="password" 
                               placeholder="Enter your password" required>
                    </div>

                    <button type="submit" class="btn btn-primary-futuristic w-100 py-2 mb-3">
                        <i class="fa-solid fa-right-to-bracket"></i> Sign In to Library
                    </button>
                </form>

                <div class="p-3 my-2 rounded-3 text-center" style="background: rgba(0, 242, 254, 0.05); border: 1px dashed rgba(0, 242, 254, 0.2);">
                    <span class="text-secondary small">Demo Account:</span><br>
                    <span class="text-cyan small fw-bold" style="color: var(--primary-cyan);">aarav.sharma@student.edu</span> &bull; 
                    <span class="text-muted small">Pass: <code>student123</code></span>
                </div>

                <div class="text-center mt-4 pt-3 border-top border-secondary">
                    <p class="text-secondary small mb-2">
                        Don't have an account? 
                        <a href="${pageContext.request.contextPath}/register" class="text-cyan fw-bold text-decoration-none" style="color: var(--primary-cyan);">
                            Register as New Student
                        </a>
                    </p>
                    <p class="text-muted small mb-0">
                        Library Administrator? 
                        <a href="${pageContext.request.contextPath}/admin-login" class="text-purple fw-bold text-decoration-none" style="color: var(--primary-purple);">
                            Admin Console <i class="fa-solid fa-arrow-right-to-bracket ms-1"></i>
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

