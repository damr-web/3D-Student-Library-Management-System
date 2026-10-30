package com.library.controller;

import com.library.dao.BookDAO;
import com.library.dao.IssueDAO;
import com.library.dao.StudentDAO;
import com.library.dao.impl.BookDAOImpl;
import com.library.dao.impl.IssueDAOImpl;
import com.library.dao.impl.StudentDAOImpl;
import com.library.model.Admin;
import com.library.model.Book;
import com.library.model.IssuedBook;
import com.library.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = {
        "/admin-dashboard",
        "/manage-books",
        "/admin-students",
        "/admin-issues",
        "/admin/add-book",
        "/admin/update-book",
        "/admin/delete-book"
})
public class AdminServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAOImpl();
    private final IssueDAO issueDAO = new IssueDAOImpl();
    private final StudentDAO studentDAO = new StudentDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!validateAdminSession(request, response)) {
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/admin-dashboard":
                showDashboard(request, response);
                break;
            case "/manage-books":
                showManageBooks(request, response);
                break;
            case "/admin-students":
                showStudents(request, response);
                break;
            case "/admin-issues":
                showIssuedBooks(request, response);
                break;
            case "/admin/delete-book":
                handleDeleteBook(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!validateAdminSession(request, response)) {
            return;
        }

        String path = request.getServletPath();

        switch (path) {
            case "/admin/add-book":
                handleAddBook(request, response);
                break;
            case "/admin/update-book":
                handleUpdateBook(request, response);
                break;
            case "/admin/delete-book":
                handleDeleteBook(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin-dashboard");
                break;
        }
    }

    private boolean validateAdminSession(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;
        if (admin == null) {
            response.sendRedirect(request.getContextPath() + "/admin-login");
            return false;
        }
        return true;
    }

    private void showDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int totalBooks = bookDAO.getTotalBooksCount();
        int totalCopies = bookDAO.getTotalCopiesCount();
        int totalStudents = studentDAO.getTotalStudentsCount();
        int activeIssues = issueDAO.getActiveIssuedCount();
        int returnedCount = issueDAO.getReturnedCount();
        int overdueCount = issueDAO.getOverdueCount();

        List<IssuedBook> recentIssues = issueDAO.getAllActiveIssuedBooks();
        List<Book> recentBooks = bookDAO.getRecentlyAddedBooks(5);

        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("totalCopies", totalCopies);
        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("activeIssues", activeIssues);
        request.setAttribute("returnedCount", returnedCount);
        request.setAttribute("overdueCount", overdueCount);
        request.setAttribute("recentIssues", recentIssues);
        request.setAttribute("recentBooks", recentBooks);

        request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);
    }

    private void showManageBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");
        String category = request.getParameter("category");

        List<Book> books = bookDAO.searchBooks(query, category);
        request.setAttribute("booksList", books);
        request.setAttribute("searchQuery", query != null ? query : "");
        request.setAttribute("selectedCategory", category != null ? category : "All");

        request.getRequestDispatcher("/manage-books.jsp").forward(request, response);
    }

    private void showStudents(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Student> students = studentDAO.getAllStudents();
        request.setAttribute("studentsList", students);
        request.getRequestDispatcher("/admin-students.jsp").forward(request, response);
    }

    private void showIssuedBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String filter = request.getParameter("view");
        List<IssuedBook> list;

        if ("overdue".equalsIgnoreCase(filter)) {
            list = issueDAO.getOverdueBooks();
            request.setAttribute("activeTab", "overdue");
        } else if ("returned".equalsIgnoreCase(filter)) {
            list = issueDAO.getAllReturnedBooks();
            request.setAttribute("activeTab", "returned");
        } else {
            list = issueDAO.getAllActiveIssuedBooks();
            request.setAttribute("activeTab", "active");
        }

        request.setAttribute("issuedBooksList", list);
        request.getRequestDispatcher("/admin-issues.jsp").forward(request, response);
    }

    private void handleAddBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String category = request.getParameter("category");
        String isbn = request.getParameter("isbn");
        String publisher = request.getParameter("publisher");
        String quantityStr = request.getParameter("quantity");
        String coverImage = request.getParameter("coverImage");
        String description = request.getParameter("description");

        try {
            int quantity = Integer.parseInt(quantityStr.trim());
            if (coverImage == null || coverImage.trim().isEmpty()) {
                coverImage = "https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400";
            }

            Book book = new Book(title.trim(), author.trim(), category.trim(), isbn.trim(),
                    publisher.trim(), quantity, quantity, coverImage.trim(), description.trim());

            boolean success = bookDAO.addBook(book);
            if (success) {
                request.getSession().setAttribute("successMessage", "Book '" + title + "' added successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to add book. ISBN may already exist.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/manage-books");
    }

    private void handleUpdateBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String category = request.getParameter("category");
        String isbn = request.getParameter("isbn");
        String publisher = request.getParameter("publisher");
        String quantityStr = request.getParameter("quantity");
        String availableStr = request.getParameter("availableCopies");
        String coverImage = request.getParameter("coverImage");
        String description = request.getParameter("description");

        try {
            int id = Integer.parseInt(idStr.trim());
            int quantity = Integer.parseInt(quantityStr.trim());
            int availableCopies = Integer.parseInt(availableStr.trim());

            Book book = new Book();
            book.setId(id);
            book.setTitle(title.trim());
            book.setAuthor(author.trim());
            book.setCategory(category.trim());
            book.setIsbn(isbn.trim());
            book.setPublisher(publisher.trim());
            book.setQuantity(quantity);
            book.setAvailableCopies(Math.min(availableCopies, quantity));
            book.setCoverImage(coverImage != null ? coverImage.trim() : "");
            book.setDescription(description != null ? description.trim() : "");

            boolean success = bookDAO.updateBook(book);
            if (success) {
                request.getSession().setAttribute("successMessage", "Book updated successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to update book.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/manage-books");
    }

    private void handleDeleteBook(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idStr = request.getParameter("id");
        try {
            int id = Integer.parseInt(idStr.trim());
            boolean success = bookDAO.deleteBook(id);
            if (success) {
                request.getSession().setAttribute("successMessage", "Book deleted successfully!");
            } else {
                request.getSession().setAttribute("errorMessage", "Failed to delete book.");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Error deleting book: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/manage-books");
    }
}

