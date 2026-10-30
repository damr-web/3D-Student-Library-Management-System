<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Explore Books Catalog - 3D Library");
%>
<jsp:include page="includes/header.jsp" />

<div class="container py-4">
    <!-- Header & Search Controls -->
    <div class="glass-card p-4 mb-4">
        <div class="row align-items-center g-3">
            <div class="col-lg-5">
                <span class="text-cyan text-uppercase fw-bold small" style="color: var(--primary-cyan); letter-spacing: 1px;">
                    <i class="fa-solid fa-layer-group"></i> Academic Library Repository
                </span>
                <h2 class="text-white fw-bold mb-1" style="font-family: var(--font-heading);">Explore Books</h2>
                <p class="text-secondary small mb-0">Search, filter by category, inspect 3D models, and issue books instantly.</p>
            </div>

            <!-- Search Form -->
            <div class="col-lg-7">
                <form action="${pageContext.request.contextPath}/books" method="get">
                    <input type="hidden" name="category" value="${selectedCategory}">
                    <div class="input-group">
                        <span class="input-group-text border-0" style="background: rgba(18, 27, 54, 0.9); color: var(--primary-cyan);">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </span>
                        <input type="text" name="q" class="form-control form-control-futuristic" 
                               value="${searchQuery}" placeholder="Search by title, author, ISBN, or publisher..." autofocus>
                        <button type="submit" class="btn btn-primary-futuristic">
                            Search
                        </button>
                        <c:if test="${not empty searchQuery || (selectedCategory != 'All' && not empty selectedCategory)}">
                            <a href="${pageContext.request.contextPath}/books" class="btn btn-glass-futuristic" title="Reset Filters">
                                <i class="fa-solid fa-xmark"></i>
                            </a>
                        </c:if>
                    </div>
                </form>
            </div>
        </div>

        <hr class="border-secondary my-3 opacity-25">

        <!-- Category Filter Pills -->
        <div class="category-pills mb-0">
            <c:set var="categories" value="${['All', 'Programming', 'Artificial Intelligence', 'Computer Science', 'Networking', 'Database Management', 'Mathematics', 'Science', 'General Knowledge']}" />
            
            <c:forEach var="cat" items="${categories}">
                <a href="${pageContext.request.contextPath}/books?category=${cat}&q=${searchQuery}" 
                   class="cat-pill ${selectedCategory == cat || (empty selectedCategory && cat == 'All') ? 'active' : ''}">
                    ${cat}
                </a>
            </c:forEach>
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

    <!-- Books Grid -->
    <div class="row g-4">
        <c:choose>
            <c:when test="${not empty booksList}">
                <c:forEach var="book" items="${booksList}">
                    <div class="col-xl-3 col-lg-4 col-md-6">
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
                                <div class="text-secondary small mb-3">
                                    <span>Publisher: ${book.publisher}</span><br>
                                    <span class="text-muted">ISBN: ${book.isbn}</span>
                                </div>
                                <div class="book-card-footer">
                                    <a href="${pageContext.request.contextPath}/book-details?id=${book.id}" class="btn btn-sm btn-glass-futuristic">
                                        <i class="fa-solid fa-cube"></i> 3D View
                                    </a>

                                    <c:choose>
                                        <c:when test="${sessionScope.student != null}">
                                            <c:choose>
                                                <c:when test="${book.availableCopies > 0}">
                                                    <form action="${pageContext.request.contextPath}/issue-book" method="post" class="d-inline">
                                                        <input type="hidden" name="bookId" value="${book.id}">
                                                        <input type="hidden" name="days" value="14">
                                                        <button type="submit" class="btn btn-sm btn-primary-futuristic">
                                                            <i class="fa-solid fa-plus"></i> Issue (14d)
                                                        </button>
                                                    </form>
                                                </c:when>
                                                <c:otherwise>
                                                    <button class="btn btn-sm btn-glass-futuristic opacity-50" disabled>
                                                        Unavailable
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <a href="${pageContext.request.contextPath}/login" class="btn btn-sm btn-primary-futuristic">
                                                Login to Issue
                                            </a>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="col-12">
                    <div class="glass-card text-center py-5">
                        <i class="fa-solid fa-magnifying-glass fa-3x text-secondary mb-3"></i>
                        <h4 class="text-white">No books match your query</h4>
                        <p class="text-secondary small mb-4">Try searching with a different keyword, title, author, or select another category.</p>
                        <a href="${pageContext.request.contextPath}/books" class="btn btn-primary-futuristic">
                            Reset Filters & Show All Books
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

