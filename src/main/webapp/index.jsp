<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.library.dao.impl.BookDAOImpl" %>
<%@ page import="com.library.dao.impl.StudentDAOImpl" %>
<%@ page import="com.library.dao.impl.IssueDAOImpl" %>
<%@ page import="com.library.model.Book" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    request.setAttribute("pageTitle", "Student Library Management System - Futuristic 3D");

    // Fetch real-time live database statistics
    BookDAOImpl bookDAO = new BookDAOImpl();
    StudentDAOImpl studentDAO = new StudentDAOImpl();
    IssueDAOImpl issueDAO = new IssueDAOImpl();

    int totalBooks = 0;
    int totalStudents = 0;
    int currentlyIssued = 0;
    List<Book> popularBooks = null;

    try {
        totalBooks = bookDAO.getTotalBooksCount();
        totalStudents = studentDAO.getTotalStudentsCount();
        currentlyIssued = issueDAO.getActiveIssuedCount();
        popularBooks = bookDAO.getPopularBooks(4);
    } catch (Exception e) {
        // Fallback default numbers if database is not yet initialized
        totalBooks = 12;
        totalStudents = 4;
        currentlyIssued = 3;
    }

    request.setAttribute("liveTotalBooks", totalBooks);
    request.setAttribute("liveTotalStudents", totalStudents);
    request.setAttribute("liveCurrentlyIssued", currentlyIssued);
    request.setAttribute("popularBooks", popularBooks);
%>

<jsp:include page="includes/header.jsp" />

<div class="container">
    <!-- Hero Section -->
    <section class="hero-section text-center text-lg-start">
        <div class="row align-items-center g-5">
            <div class="col-lg-7">
                <div class="hero-badge">
                    <i class="fa-solid fa-sparkles"></i> NEXT-GEN 3D UNIVERSITY LIBRARY
                </div>
                <h1 class="hero-title">
                    STUDENT LIBRARY <br>
                    <span class="gradient-text">MANAGEMENT SYSTEM</span>
                </h1>
                <p class="hero-subtitle">
                    <span class="tagline-highlight">Explore. Read. Learn. Grow.</span><br>
                    Step into an immersive 3D digital library environment. Browse thousands of academic titles, issue books instantly, and manage your borrowing history with precision.
                </p>

                <div class="d-flex flex-wrap gap-3 justify-content-center justify-content-lg-start">
                    <c:choose>
                        <c:when test="${sessionScope.student != null}">
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary-futuristic btn-lg">
                                <i class="fa-solid fa-gauge"></i> Go to Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/books" class="btn btn-glass-futuristic btn-lg">
                                <i class="fa-solid fa-magnifying-glass"></i> Browse Catalog
                            </a>
                        </c:when>
                        <c:when test="${sessionScope.admin != null}">
                            <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-purple-futuristic btn-lg">
                                <i class="fa-solid fa-shield-halved"></i> Admin Console
                            </a>
                            <a href="${pageContext.request.contextPath}/manage-books" class="btn btn-glass-futuristic btn-lg">
                                <i class="fa-solid fa-book"></i> Manage Inventory
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary-futuristic btn-lg">
                                <i class="fa-solid fa-user-astronaut"></i> Student Login
                            </a>
                            <a href="${pageContext.request.contextPath}/register" class="btn btn-glass-futuristic btn-lg">
                                <i class="fa-solid fa-user-plus"></i> Student Registration
                            </a>
                            <a href="${pageContext.request.contextPath}/admin-login" class="btn btn-purple-futuristic btn-lg">
                                <i class="fa-solid fa-lock"></i> Admin Login
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Hero Interactive 3D Callout Card -->
            <div class="col-lg-5">
                <div class="glass-card p-4 text-center">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-2 rounded-pill">
                            <i class="fa-solid fa-cube"></i> Interactive 3D World
                        </span>
                        <span class="text-secondary small"><i class="fa-solid fa-hand-pointer"></i> Move mouse to rotate</span>
                    </div>

                    <div class="p-3 my-2 rounded-4" style="background: rgba(0, 242, 254, 0.05); border: 1px dashed rgba(0, 242, 254, 0.3);">
                        <i class="fa-solid fa-book-open-reader fa-3x mb-3" style="color: var(--primary-cyan);"></i>
                        <h4 class="text-white fw-bold mb-1">Futuristic University Repository</h4>
                        <p class="text-secondary small mb-0">Seamless book checkout, real-time stock counters, automated 14-day borrowing cycles, and zero lag.</p>
                    </div>

                    <div class="d-flex justify-content-around mt-4 pt-3 border-top border-secondary">
                        <div>
                            <div class="fw-bold text-cyan" style="color: var(--primary-cyan); font-size: 1.1rem;">14 Days</div>
                            <div class="text-muted small">Standard Loan</div>
                        </div>
                        <div>
                            <div class="fw-bold text-purple" style="color: var(--primary-purple); font-size: 1.1rem;">Instant</div>
                            <div class="text-muted small">Auto-Issuance</div>
                        </div>
                        <div>
                            <div class="fw-bold text-success" style="font-size: 1.1rem;">8+ Categories</div>
                            <div class="text-muted small">Diverse Fields</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Real-time Live Library Statistics Section -->
    <section class="my-5">
        <div class="row g-4">
            <div class="col-md-4">
                <div class="stat-card-futuristic">
                    <div class="stat-icon-wrapper stat-icon-cyan">
                        <i class="fa-solid fa-book-atlas"></i>
                    </div>
                    <div>
                        <div class="stat-number" data-target="${liveTotalBooks}">${liveTotalBooks}</div>
                        <div class="stat-label">Total Books in Catalog</div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card-futuristic">
                    <div class="stat-icon-wrapper stat-icon-purple">
                        <i class="fa-solid fa-user-graduate"></i>
                    </div>
                    <div>
                        <div class="stat-number" data-target="${liveTotalStudents}">${liveTotalStudents}</div>
                        <div class="stat-label">Registered Students</div>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="stat-card-futuristic">
                    <div class="stat-icon-wrapper stat-icon-amber">
                        <i class="fa-solid fa-arrow-right-arrow-left"></i>
                    </div>
                    <div>
                        <div class="stat-number" data-target="${liveCurrentlyIssued}">${liveCurrentlyIssued}</div>
                        <div class="stat-label">Books Currently Issued</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- Popular Books Showcase Section -->
    <section class="my-5 pb-5">
        <div class="d-flex flex-wrap justify-content-between align-items-end mb-4">
            <div>
                <span class="text-cyan text-uppercase fw-bold small" style="color: var(--primary-cyan); letter-spacing: 1px;">
                    <i class="fa-solid fa-fire"></i> High Demand
                </span>
                <h2 class="text-white fw-bold mb-0" style="font-family: var(--font-heading);">Popular & Trending Books</h2>
            </div>
            <a href="${pageContext.request.contextPath}/books" class="btn btn-glass-futuristic mt-3 mt-md-0">
                View All Books <i class="fa-solid fa-arrow-right ms-1"></i>
            </a>
        </div>

        <div class="row g-4">
            <c:forEach var="book" items="${popularBooks}">
                <div class="col-xl-3 col-lg-4 col-sm-6">
                    <div class="book-card-futuristic">
                        <div class="book-cover-wrapper">
                            <img src="${book.coverImage}" alt="${book.title}" class="book-cover-img" onerror="this.src='https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400'">
                            <span class="book-category-badge">${book.category}</span>
                            <c:choose>
                                <c:when test="${book.availableCopies > 0}">
                                    <span class="book-stock-badge badge-in-stock">
                                        <i class="fa-solid fa-check"></i> ${book.availableCopies} Available
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="book-stock-badge badge-out-stock">
                                        <i class="fa-solid fa-xmark"></i> Out of Stock
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="book-card-body">
                            <h5 class="book-title" title="${book.title}">${book.title}</h5>
                            <p class="book-author"><i class="fa-solid fa-pen-nib me-1"></i> ${book.author}</p>
                            <div class="book-card-footer">
                                <span class="text-muted small">ISBN: ${book.isbn}</span>
                                <a href="${pageContext.request.contextPath}/book-details?id=${book.id}" class="btn btn-sm btn-primary-futuristic">
                                    <i class="fa-solid fa-eye"></i> Details
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </section>
</div>

<jsp:include page="includes/footer.jsp" />

