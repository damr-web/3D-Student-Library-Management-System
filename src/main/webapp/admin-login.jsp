<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Administrator Console Login - 3D Library");
%>
<jsp:include page="includes/header.jsp" />

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-5 col-md-8">
            <div class="glass-card p-4 p-md-5">
                <div class="text-center mb-4">
                    <div class="stat-icon-wrapper stat-icon-purple mx-auto mb-3">
                        <i class="fa-solid fa-shield-halved"></i>
                    </div>
                    <h3 class="text-white fw-bold mb-1" style="font-family: var(--font-heading);">Admin Console</h3>
                    <p class="text-secondary small">Restricted access portal for University Librarians and Administrators.</p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert-futuristic alert-futuristic-danger">
                        <i class="fa-solid fa-shield-virus"></i>
                        <span>${errorMessage}</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post">
                    <input type="hidden" name="role" value="admin">

                    <div class="mb-3">
                        <label for="username" class="form-label-futuristic">
                            <i class="fa-solid fa-user-gear me-1 text-purple" style="color: var(--primary-purple);"></i> Admin Username / Email
                        </label>
                        <input type="text" class="form-control form-control-futuristic" id="username" name="username" 
                               value="${username}" placeholder="e.g. admin or admin@library.edu" required autofocus>
                    </div>

                    <div class="mb-4">
                        <label for="password" class="form-label-futuristic">
                            <i class="fa-solid fa-key me-1 text-purple" style="color: var(--primary-purple);"></i> Master Password
                        </label>
                        <input type="password" class="form-control form-control-futuristic" id="password" name="password" 
                               placeholder="Enter admin password" required>
                    </div>

                    <button type="submit" class="btn btn-purple-futuristic w-100 py-2 mb-3">
                        <i class="fa-solid fa-lock-open"></i> Authenticate & Enter Console
                    </button>
                </form>

                <div class="p-3 my-2 rounded-3 text-center" style="background: rgba(157, 78, 221, 0.08); border: 1px dashed rgba(157, 78, 221, 0.3);">
                    <span class="text-secondary small">Default Admin Credentials:</span><br>
                    <span class="text-white small fw-bold">User: <code>admin</code></span> &bull; 
                    <span class="text-white small">Pass: <code>admin123</code></span>
                </div>

                <div class="text-center mt-4 pt-3 border-top border-secondary">
                    <p class="text-secondary small mb-0">
                        Student trying to login? 
                        <a href="${pageContext.request.contextPath}/login" class="text-cyan fw-bold text-decoration-none" style="color: var(--primary-cyan);">
                            Go to Student Login
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

