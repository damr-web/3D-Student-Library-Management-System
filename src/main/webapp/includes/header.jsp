<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String currentPath = request.getServletPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${pageTitle != null ? pageTitle : "3D Student Library Management System"}</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;600;700;800&display=swap" rel="stylesheet">

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Font Awesome 6 Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <!-- Custom Futuristic Style -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <!-- Three.js (r128) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/three.js/r128/three.min.js"></script>
</head>
<body>

    <!-- 3D Canvas Background -->
    <div id="three-canvas-container"></div>

    <!-- Futuristic Glass Navigation Bar -->
    <nav class="navbar navbar-expand-lg navbar-dark navbar-futuristic sticky-top">
        <div class="container">
            <a class="navbar-brand navbar-brand-futuristic" href="${pageContext.request.contextPath}/index.jsp">
                <i class="fa-solid fa-cube brand-icon-glow"></i>
                <span>STUDENT LIBRARY <span style="font-size: 0.8rem; color: var(--primary-cyan); font-weight: 600;">3D</span></span>
            </a>

            <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain" aria-controls="navbarMain" aria-expanded="false" aria-label="Toggle navigation">
                <i class="fa-solid fa-bars-staggered text-cyan" style="color: var(--primary-cyan);"></i>
            </button>

            <div class="collapse navbar-collapse" id="navbarMain">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0 ms-lg-4">
                    <li class="nav-item">
                        <a class="nav-link nav-link-futuristic ${pageContext.request.requestURI.endsWith('index.jsp') ? 'active' : ''}" href="${pageContext.request.contextPath}/index.jsp">
                            <i class="fa-solid fa-house"></i> Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link nav-link-futuristic ${pageContext.request.requestURI.contains('/books') ? 'active' : ''}" href="${pageContext.request.contextPath}/books">
                            <i class="fa-solid fa-book-bookmark"></i> Explore Books
                        </a>
                    </li>

                    <c:if test="${sessionScope.student != null}">
                        <li class="nav-item">
                            <a class="nav-link nav-link-futuristic ${pageContext.request.requestURI.contains('/dashboard') ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard">
                                <i class="fa-solid fa-chart-line"></i> Dashboard
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link nav-link-futuristic ${pageContext.request.requestURI.contains('/my-books') ? 'active' : ''}" href="${pageContext.request.contextPath}/my-books">
                                <i class="fa-solid fa-book-reader"></i> My Books
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link nav-link-futuristic ${pageContext.request.requestURI.contains('/history') ? 'active' : ''}" href="${pageContext.request.contextPath}/history">
                                <i class="fa-solid fa-clock-rotate-left"></i> History
                            </a>
                        </li>
                    </c:if>

                    <c:if test="${sessionScope.admin != null}">
                        <li class="nav-item">
                            <a class="nav-link nav-link-futuristic ${pageContext.request.requestURI.contains('/admin-dashboard') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin-dashboard">
                                <i class="fa-solid fa-gauge-high"></i> Admin Portal
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link nav-link-futuristic ${pageContext.request.requestURI.contains('/manage-books') ? 'active' : ''}" href="${pageContext.request.contextPath}/manage-books">
                                <i class="fa-solid fa-boxes-stacked"></i> Manage Books
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link nav-link-futuristic ${pageContext.request.requestURI.contains('/admin-students') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin-students">
                                <i class="fa-solid fa-user-graduate"></i> Students
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link nav-link-futuristic ${pageContext.request.requestURI.contains('/admin-issues') ? 'active' : ''}" href="${pageContext.request.contextPath}/admin-issues">
                                <i class="fa-solid fa-handshake"></i> Issued Records
                            </a>
                        </li>
                    </c:if>
                </ul>

                <div class="d-flex align-items-center gap-2">
                    <c:choose>
                        <c:when test="${sessionScope.student != null}">
                            <div class="dropdown">
                                <button class="btn btn-glass-futuristic dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                    <i class="fa-solid fa-user-astronaut text-cyan" style="color: var(--primary-cyan);"></i>
                                    <span>${sessionScope.student.name}</span>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end modal-content-futuristic">
                                    <li><span class="dropdown-item-text text-muted small"><i class="fa-solid fa-id-card"></i> ${sessionScope.student.studentId}</span></li>
                                    <li><hr class="dropdown-divider border-secondary"></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/dashboard"><i class="fa-solid fa-gauge"></i> My Dashboard</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/my-books"><i class="fa-solid fa-book"></i> Active Books</a></li>
                                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
                                </ul>
                            </div>
                        </c:when>
                        <c:when test="${sessionScope.admin != null}">
                            <div class="dropdown">
                                <button class="btn btn-purple-futuristic dropdown-toggle" type="button" data-bs-toggle="dropdown">
                                    <i class="fa-solid fa-shield-halved"></i>
                                    <span>Admin: ${sessionScope.admin.name}</span>
                                </button>
                                <ul class="dropdown-menu dropdown-menu-dark dropdown-menu-end modal-content-futuristic">
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin-dashboard"><i class="fa-solid fa-gauge-high"></i> Dashboard</a></li>
                                    <li><a class="dropdown-item" href="${pageContext.request.contextPath}/manage-books"><i class="fa-solid fa-book"></i> Book Inventory</a></li>
                                    <li><hr class="dropdown-divider border-secondary"></li>
                                    <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a></li>
                                </ul>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-glass-futuristic">
                                <i class="fa-solid fa-user"></i> Student Login
                            </a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-primary-futuristic">
                                <i class="fa-solid fa-user-plus"></i> Register
                            </a>
                            <a href="${pageContext.request.contextPath}/admin-login" class="btn btn-purple-futuristic" title="Librarian / Administrator Login">
                                <i class="fa-solid fa-lock"></i> Admin
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </nav>

