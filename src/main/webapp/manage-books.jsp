<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    request.setAttribute("pageTitle", "Manage Books & Inventory - Admin Console");
%>
<jsp:include page="includes/header.jsp" />

<div class="container py-4">
    <!-- Header & Action Controls -->
    <div class="glass-card p-4 mb-4">
        <div class="row align-items-center g-3">
            <div class="col-lg-6">
                <span class="text-cyan text-uppercase fw-bold small" style="color: var(--primary-cyan); letter-spacing: 1px;">
                    <i class="fa-solid fa-boxes-stacked"></i> Catalog Management
                </span>
                <h2 class="text-white fw-bold mb-1" style="font-family: var(--font-heading);">Book Inventory</h2>
                <p class="text-secondary small mb-0">Add new volumes, edit titles/stock quantities, and manage catalog data.</p>
            </div>
            <div class="col-lg-6 d-flex justify-content-lg-end gap-2">
                <button type="button" class="btn btn-primary-futuristic" data-bs-toggle="modal" data-bs-target="#addBookModal">
                    <i class="fa-solid fa-plus"></i> Add New Book
                </button>
                <a href="${pageContext.request.contextPath}/admin-dashboard" class="btn btn-glass-futuristic">
                    <i class="fa-solid fa-arrow-left"></i> Dashboard
                </a>
            </div>
        </div>

        <hr class="border-secondary my-3 opacity-25">

        <!-- Search & Filter Bar -->
        <form action="${pageContext.request.contextPath}/manage-books" method="get" class="row g-2 align-items-center">
            <div class="col-md-7">
                <input type="text" name="q" class="form-control form-control-futuristic" 
                       value="${searchQuery}" placeholder="Search inventory by title, author, or ISBN...">
            </div>
            <div class="col-md-3">
                <select name="category" class="form-select form-select-futuristic">
                    <c:set var="cats" value="${['All', 'Programming', 'Artificial Intelligence', 'Computer Science', 'Networking', 'Database Management', 'Mathematics', 'Science', 'General Knowledge']}" />
                    <c:forEach var="c" items="${cats}">
                        <option value="${c}" ${selectedCategory == c ? 'selected' : ''}>${c}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-2 d-flex gap-2">
                <button type="submit" class="btn btn-primary-futuristic w-100">Filter</button>
                <c:if test="${not empty searchQuery || (selectedCategory != 'All' && not empty selectedCategory)}">
                    <a href="${pageContext.request.contextPath}/manage-books" class="btn btn-glass-futuristic">
                        <i class="fa-solid fa-xmark"></i>
                    </a>
                </c:if>
            </div>
        </form>
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

    <!-- Books Management Table -->
    <div class="glass-card p-4">
        <c:choose>
            <c:when test="${not empty booksList}">
                <div class="table-responsive">
                    <table class="table-futuristic">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Book & Author</th>
                                <th>Category</th>
                                <th>ISBN</th>
                                <th>Stock Status</th>
                                <th>Publisher</th>
                                <th class="text-end">Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="b" items="${booksList}" varStatus="status">
                                <tr>
                                    <td class="text-secondary">${status.count}</td>
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <img src="${b.coverImage}" alt="${b.title}" class="rounded-2" style="width: 38px; height: 52px; object-fit: cover;" onerror="this.src='https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400'">
                                            <div>
                                                <div class="fw-bold text-white">${b.title}</div>
                                                <div class="text-secondary small">by ${b.author}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td><span class="badge bg-dark border border-secondary text-info">${b.category}</span></td>
                                    <td><code>${b.isbn}</code></td>
                                    <td>
                                        <div class="fw-bold ${b.availableCopies > 0 ? 'text-success' : 'text-danger'}">
                                            ${b.availableCopies} / ${b.quantity} Available
                                        </div>
                                    </td>
                                    <td><span class="text-secondary small">${b.publisher}</span></td>
                                    <td class="text-end">
                                        <div class="d-flex justify-content-end gap-2">
                                            <!-- Edit Button -->
                                            <button type="button" class="btn btn-sm btn-glass-futuristic" 
                                                    data-bs-toggle="modal" 
                                                    data-bs-target="#editBookModal${b.id}" 
                                                    title="Edit Book Details">
                                                <i class="fa-solid fa-pen-to-square text-cyan" style="color: var(--primary-cyan);"></i>
                                            </button>

                                            <!-- Delete Button -->
                                            <a href="${pageContext.request.contextPath}/admin/delete-book?id=${b.id}" 
                                               class="btn btn-sm btn-danger-futuristic" 
                                               onclick="return confirm('Are you sure you want to permanently delete \'${b.title}\'? This will also delete related issue history.');"
                                               title="Delete Book">
                                                <i class="fa-solid fa-trash"></i>
                                            </a>
                                        </div>

                                        <!-- Edit Book Modal for each row -->
                                        <div class="modal fade" id="editBookModal${b.id}" tabindex="-1" aria-hidden="true">
                                            <div class="modal-dialog modal-dialog-centered modal-lg">
                                                <div class="modal-content modal-content-futuristic">
                                                    <div class="modal-header modal-header-futuristic">
                                                        <h5 class="modal-title fw-bold text-white">
                                                            <i class="fa-solid fa-pen-to-square text-cyan me-2" style="color: var(--primary-cyan);"></i> Edit Book: ${b.title}
                                                        </h5>
                                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                                                    </div>
                                                    <form action="${pageContext.request.contextPath}/admin/update-book" method="post">
                                                        <div class="modal-body p-4 text-start">
                                                            <input type="hidden" name="id" value="${b.id}">
                                                            <div class="row g-3">
                                                                <div class="col-md-8">
                                                                    <label class="form-label-futuristic">Book Title</label>
                                                                    <input type="text" name="title" class="form-control form-control-futuristic" value="${b.title}" required>
                                                                </div>
                                                                <div class="col-md-4">
                                                                    <label class="form-label-futuristic">Category</label>
                                                                    <select name="category" class="form-select form-select-futuristic" required>
                                                                        <c:forEach var="catItem" items="${cats}">
                                                                            <c:if test="${catItem != 'All'}">
                                                                                <option value="${catItem}" ${b.category == catItem ? 'selected' : ''}>${catItem}</option>
                                                                            </c:if>
                                                                        </c:forEach>
                                                                    </select>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label class="form-label-futuristic">Author</label>
                                                                    <input type="text" name="author" class="form-control form-control-futuristic" value="${b.author}" required>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label class="form-label-futuristic">ISBN</label>
                                                                    <input type="text" name="isbn" class="form-control form-control-futuristic" value="${b.isbn}" required>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label class="form-label-futuristic">Publisher</label>
                                                                    <input type="text" name="publisher" class="form-control form-control-futuristic" value="${b.publisher}" required>
                                                                </div>
                                                                <div class="col-md-3">
                                                                    <label class="form-label-futuristic">Total Quantity</label>
                                                                    <input type="number" name="quantity" class="form-control form-control-futuristic" value="${b.quantity}" min="1" required>
                                                                </div>
                                                                <div class="col-md-3">
                                                                    <label class="form-label-futuristic">Available Copies</label>
                                                                    <input type="number" name="availableCopies" class="form-control form-control-futuristic" value="${b.availableCopies}" min="0" required>
                                                                </div>
                                                                <div class="col-12">
                                                                    <label class="form-label-futuristic">Cover Image URL</label>
                                                                    <input type="url" name="coverImage" class="form-control form-control-futuristic" value="${b.coverImage}">
                                                                </div>
                                                                <div class="col-12">
                                                                    <label class="form-label-futuristic">Description / Synopsis</label>
                                                                    <textarea name="description" class="form-control form-control-futuristic" rows="3">${b.description}</textarea>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="modal-footer modal-footer-futuristic">
                                                            <button type="button" class="btn btn-glass-futuristic" data-bs-dismiss="modal">Cancel</button>
                                                            <button type="submit" class="btn btn-primary-futuristic">Save Changes</button>
                                                        </div>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center py-5 text-secondary">
                    <i class="fa-solid fa-boxes-stacked fa-3x mb-3"></i>
                    <h5 class="text-white">No books found in this filter</h5>
                    <p class="small mb-3">Add your first book using the "Add New Book" button above.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Modal: Add New Book -->
<div class="modal fade" id="addBookModal" tabindex="-1" aria-labelledby="addBookModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content modal-content-futuristic">
            <div class="modal-header modal-header-futuristic">
                <h5 class="modal-title fw-bold text-white" id="addBookModalLabel">
                    <i class="fa-solid fa-plus-circle text-cyan me-2" style="color: var(--primary-cyan);"></i> Add New Book to Library
                </h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="${pageContext.request.contextPath}/admin/add-book" method="post">
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label for="newTitle" class="form-label-futuristic">Book Title *</label>
                            <input type="text" id="newTitle" name="title" class="form-control form-control-futuristic" placeholder="e.g. Modern Operating Systems" required>
                        </div>
                        <div class="col-md-4">
                            <label for="newCategory" class="form-label-futuristic">Category *</label>
                            <select id="newCategory" name="category" class="form-select form-select-futuristic" required>
                                <option value="Programming">Programming</option>
                                <option value="Artificial Intelligence">Artificial Intelligence</option>
                                <option value="Computer Science" selected>Computer Science</option>
                                <option value="Networking">Networking</option>
                                <option value="Database Management">Database Management</option>
                                <option value="Mathematics">Mathematics</option>
                                <option value="Science">Science</option>
                                <option value="General Knowledge">General Knowledge</option>
                            </select>
                        </div>
                        <div class="col-md-6">
                            <label for="newAuthor" class="form-label-futuristic">Author(s) *</label>
                            <input type="text" id="newAuthor" name="author" class="form-control form-control-futuristic" placeholder="e.g. Andrew S. Tanenbaum" required>
                        </div>
                        <div class="col-md-6">
                            <label for="newIsbn" class="form-label-futuristic">ISBN Number *</label>
                            <input type="text" id="newIsbn" name="isbn" class="form-control form-control-futuristic" placeholder="e.g. 978-0133591620" required>
                        </div>
                        <div class="col-md-6">
                            <label for="newPublisher" class="form-label-futuristic">Publisher *</label>
                            <input type="text" id="newPublisher" name="publisher" class="form-control form-control-futuristic" placeholder="e.g. Pearson Education" required>
                        </div>
                        <div class="col-md-6">
                            <label for="newQuantity" class="form-label-futuristic">Total Stock Quantity *</label>
                            <input type="number" id="newQuantity" name="quantity" class="form-control form-control-futuristic" value="5" min="1" required>
                        </div>
                        <div class="col-12">
                            <label for="newCover" class="form-label-futuristic">Book Cover Image URL</label>
                            <input type="url" id="newCover" name="coverImage" class="form-control form-control-futuristic" placeholder="https://images.unsplash.com/..." value="https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400">
                        </div>
                        <div class="col-12">
                            <label for="newDesc" class="form-label-futuristic">Description / Abstract</label>
                            <textarea id="newDesc" name="description" class="form-control form-control-futuristic" rows="3" placeholder="Overview of topics covered in this textbook..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer modal-footer-futuristic">
                    <button type="button" class="btn btn-glass-futuristic" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary-futuristic">
                        <i class="fa-solid fa-plus"></i> Add Book to Catalog
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="includes/footer.jsp" />

