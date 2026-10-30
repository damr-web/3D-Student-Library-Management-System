<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Student Registration - 3D Library");
%>
<jsp:include page="includes/header.jsp" />

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-7 col-md-10">
            <div class="glass-card p-4 p-md-5">
                <div class="text-center mb-4">
                    <div class="stat-icon-wrapper stat-icon-purple mx-auto mb-3">
                        <i class="fa-solid fa-id-card-clip"></i>
                    </div>
                    <h3 class="text-white fw-bold mb-1" style="font-family: var(--font-heading);">Student Registration</h3>
                    <p class="text-secondary small">Create your digital university library account to start borrowing books.</p>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert-futuristic alert-futuristic-danger">
                        <i class="fa-solid fa-triangle-exclamation"></i>
                        <span>${errorMessage}</span>
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/register" method="post">
                    <div class="row g-3">
                        <!-- Student ID -->
                        <div class="col-md-6">
                            <label for="studentId" class="form-label-futuristic">
                                <i class="fa-solid fa-hashtag text-cyan" style="color: var(--primary-cyan);"></i> Student Roll / ID No.
                            </label>
                            <input type="text" class="form-control form-control-futuristic" id="studentId" name="studentId" 
                                   value="${studentIdVal}" placeholder="e.g. STU-2026-005" required>
                        </div>

                        <!-- Full Name -->
                        <div class="col-md-6">
                            <label for="name" class="form-label-futuristic">
                                <i class="fa-solid fa-user text-cyan" style="color: var(--primary-cyan);"></i> Full Name
                            </label>
                            <input type="text" class="form-control form-control-futuristic" id="name" name="name" 
                                   value="${nameVal}" placeholder="e.g. Devika Nair" required>
                        </div>

                        <!-- Email -->
                        <div class="col-md-6">
                            <label for="email" class="form-label-futuristic">
                                <i class="fa-solid fa-envelope text-cyan" style="color: var(--primary-cyan);"></i> University Email
                            </label>
                            <input type="email" class="form-control form-control-futuristic" id="email" name="email" 
                                   value="${emailVal}" placeholder="e.g. devika@student.edu" required>
                        </div>

                        <!-- Password -->
                        <div class="col-md-6">
                            <label for="password" class="form-label-futuristic">
                                <i class="fa-solid fa-lock text-cyan" style="color: var(--primary-cyan);"></i> Account Password
                            </label>
                            <input type="password" class="form-control form-control-futuristic" id="password" name="password" 
                                   placeholder="Min 6 characters" required>
                        </div>

                        <!-- Department -->
                        <div class="col-md-6">
                            <label for="department" class="form-label-futuristic">
                                <i class="fa-solid fa-building-columns text-cyan" style="color: var(--primary-cyan);"></i> Department / Major
                            </label>
                            <select class="form-select form-select-futuristic" id="department" name="department" required>
                                <option value="" disabled ${empty departmentVal ? 'selected' : ''}>Select Department</option>
                                <option value="Computer Science & Engineering" ${departmentVal == 'Computer Science & Engineering' ? 'selected' : ''}>Computer Science & Engineering</option>
                                <option value="Artificial Intelligence & Data Science" ${departmentVal == 'Artificial Intelligence & Data Science' ? 'selected' : ''}>Artificial Intelligence & Data Science</option>
                                <option value="Information Technology" ${departmentVal == 'Information Technology' ? 'selected' : ''}>Information Technology</option>
                                <option value="Electronics & Communication" ${departmentVal == 'Electronics & Communication' ? 'selected' : ''}>Electronics & Communication</option>
                                <option value="Mechanical Engineering" ${departmentVal == 'Mechanical Engineering' ? 'selected' : ''}>Mechanical Engineering</option>
                                <option value="Mathematics & Computing" ${departmentVal == 'Mathematics & Computing' ? 'selected' : ''}>Mathematics & Computing</option>
                                <option value="General Sciences" ${departmentVal == 'General Sciences' ? 'selected' : ''}>General Sciences</option>
                            </select>
                        </div>

                        <!-- Semester -->
                        <div class="col-md-6">
                            <label for="semester" class="form-label-futuristic">
                                <i class="fa-solid fa-graduation-cap text-cyan" style="color: var(--primary-cyan);"></i> Current Semester
                            </label>
                            <select class="form-select form-select-futuristic" id="semester" name="semester" required>
                                <option value="" disabled ${empty semesterVal ? 'selected' : ''}>Select Semester</option>
                                <option value="1st Semester" ${semesterVal == '1st Semester' ? 'selected' : ''}>1st Semester</option>
                                <option value="2nd Semester" ${semesterVal == '2nd Semester' ? 'selected' : ''}>2nd Semester</option>
                                <option value="3rd Semester" ${semesterVal == '3rd Semester' ? 'selected' : ''}>3rd Semester</option>
                                <option value="4th Semester" ${semesterVal == '4th Semester' ? 'selected' : ''}>4th Semester</option>
                                <option value="5th Semester" ${semesterVal == '5th Semester' ? 'selected' : ''}>5th Semester</option>
                                <option value="6th Semester" ${semesterVal == '6th Semester' ? 'selected' : ''}>6th Semester</option>
                                <option value="7th Semester" ${semesterVal == '7th Semester' ? 'selected' : ''}>7th Semester</option>
                                <option value="8th Semester" ${semesterVal == '8th Semester' ? 'selected' : ''}>8th Semester</option>
                            </select>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary-futuristic w-100 py-2 mt-4">
                        <i class="fa-solid fa-user-check"></i> Complete Registration
                    </button>
                </form>

                <div class="text-center mt-4 pt-3 border-top border-secondary">
                    <p class="text-secondary small mb-0">
                        Already have an account? 
                        <a href="${pageContext.request.contextPath}/login" class="text-cyan fw-bold text-decoration-none" style="color: var(--primary-cyan);">
                            Sign In Here
                        </a>
                    </p>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

