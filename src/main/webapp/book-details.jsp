<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Book Details & 3D Viewer - 3D Library");
%>
<jsp:include page="includes/header.jsp" />

<div class="container py-4">
    <!-- Breadcrumb -->
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb mb-0">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/index.jsp" class="text-secondary text-decoration-none">Home</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/books" class="text-secondary text-decoration-none">Catalog</a></li>
            <li class="breadcrumb-item active text-cyan" style="color: var(--primary-cyan);" aria-current="page">${book.title}</li>
        </ol>
    </nav>

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

    <div class="row g-4">
        <!-- 3D Interactive Book Canvas Viewer Column -->
        <div class="col-lg-5">
            <div class="glass-card p-3">
                <div class="d-flex justify-content-between align-items-center mb-2 px-2">
                    <span class="badge bg-primary-subtle text-cyan border border-info small">
                        <i class="fa-solid fa-cube"></i> Interactive 3D Model
                    </span>
                    <span class="text-muted small"><i class="fa-solid fa-arrows-up-down-left-right me-1"></i> Drag to rotate 360°</span>
                </div>

                <div id="book-viewer-container">
                    <canvas id="book-viewer-canvas"></canvas>
                    <div class="viewer-hint">
                        <i class="fa-solid fa-hand-pointer"></i> Click & Drag to inspect in 3D
                    </div>
                </div>

                <div class="text-center mt-3">
                    <span class="text-secondary small">Real-time rendered Three.js geometry with dynamic cover texture and realistic spine foil.</span>
                </div>
            </div>
        </div>

        <!-- Book Metadata and Issue Column -->
        <div class="col-lg-7">
            <div class="glass-card p-4 p-md-5 h-100 d-flex flex-direction-column justify-content-between">
                <div>
                    <div class="d-flex flex-wrap gap-2 mb-3">
                        <span class="badge bg-dark border border-secondary text-cyan px-3 py-2 rounded-pill" style="color: var(--primary-cyan);">
                            <i class="fa-solid fa-bookmark me-1"></i> ${book.category}
                        </span>
                        <c:choose>
                            <c:when test="${book.availableCopies > 0}">
                                <span class="badge-stock badge-in-stock px-3 py-2 rounded-pill">
                                    <i class="fa-solid fa-check"></i> ${book.availableCopies} of ${book.quantity} Available
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-stock badge-out-stock px-3 py-2 rounded-pill">
                                    <i class="fa-solid fa-xmark"></i> Out of Stock
                                </span>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h2 class="text-white fw-bold mb-2" style="font-family: var(--font-heading); font-size: 1.85rem;">
                        ${book.title}
                    </h2>
                    <p class="text-secondary fs-5 mb-4">
                        <i class="fa-solid fa-pen-nib text-cyan me-1" style="color: var(--primary-cyan);"></i> By <strong class="text-white">${book.author}</strong>
                    </p>

                    <!-- Synopsis / Description -->
                    <div class="mb-4">
                        <h6 class="text-cyan text-uppercase fw-bold small" style="color: var(--primary-cyan); letter-spacing: 0.5px;">Synopsis</h6>
                        <p class="text-light opacity-75" style="line-height: 1.7;">
                            ${not empty book.description ? book.description : "No description provided for this academic volume."}
                        </p>
                    </div>

                    <!-- Metadata Grid -->
                    <div class="row g-3 p-3 rounded-3 mb-4" style="background: rgba(18, 27, 54, 0.6); border: 1px solid var(--border-glass);">
                        <div class="col-sm-6">
                            <span class="text-muted small">ISBN-13:</span>
                            <div class="text-white fw-semibold">${book.isbn}</div>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted small">Publisher:</span>
                            <div class="text-white fw-semibold">${book.publisher}</div>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted small">Standard Loan Duration:</span>
                            <div class="text-cyan fw-semibold" style="color: var(--primary-cyan);">14 Days (Renewable)</div>
                        </div>
                        <div class="col-sm-6">
                            <span class="text-muted small">Library Catalog ID:</span>
                            <div class="text-white fw-semibold">#LIB-${book.id}</div>
                        </div>
                    </div>
                </div>

                <!-- Issue Action Section -->
                <div class="pt-3 border-top border-secondary">
                    <c:choose>
                        <c:when test="${isAlreadyIssued}">
                            <div class="alert-futuristic alert-futuristic-success mb-0">
                                <i class="fa-solid fa-circle-check"></i>
                                <span>You currently have an active borrowed copy of this book.</span>
                                <a href="${pageContext.request.contextPath}/my-books" class="btn btn-sm btn-glass-futuristic ms-auto">
                                    View in My Books
                                </a>
                            </div>
                        </c:when>
                        <c:when test="${sessionScope.student != null}">
                            <c:choose>
                                <c:when test="${book.availableCopies > 0}">
                                    <form action="${pageContext.request.contextPath}/issue-book" method="post" class="d-flex flex-wrap align-items-center gap-3">
                                        <input type="hidden" name="bookId" value="${book.id}">
                                        <div class="d-flex align-items-center gap-2">
                                            <label for="days" class="text-secondary small fw-bold text-nowrap">Borrow For:</label>
                                            <select name="days" id="days" class="form-select form-select-futuristic py-1" style="width: 140px;">
                                                <option value="14" selected>14 Days (Default)</option>
                                                <option value="7">7 Days</option>
                                                <option value="21">21 Days</option>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-primary-futuristic btn-lg flex-grow-1">
                                            <i class="fa-solid fa-bookmark"></i> Confirm & Issue Book
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert-futuristic alert-futuristic-danger mb-0">
                                        <i class="fa-solid fa-circle-exclamation"></i>
                                        <span>All copies are currently issued to other students. Please check back later.</span>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <div class="d-flex align-items-center justify-content-between p-3 rounded-3" style="background: rgba(0, 242, 254, 0.05); border: 1px dashed rgba(0, 242, 254, 0.3);">
                                <div>
                                    <h6 class="text-white mb-1">Want to borrow this book?</h6>
                                    <p class="text-secondary small mb-0">Sign in with your student account to check out this title.</p>
                                </div>
                                <a href="${pageContext.request.contextPath}/login" class="btn btn-primary-futuristic">
                                    <i class="fa-solid fa-right-to-bracket"></i> Login to Issue
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Standalone 3D Book Viewer Script -->
<script src="${pageContext.request.contextPath}/js/3d-book-viewer.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', () => {
        init3DBookViewer({
            title: "${book.title}",
            author: "${book.author}",
            category: "${book.category}"
        });
    });
</script>

<jsp:include page="includes/footer.jsp" />

