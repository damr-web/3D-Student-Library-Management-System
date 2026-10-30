package com.library.controller;

import com.library.dao.BookDAO;
import com.library.dao.IssueDAO;
import com.library.dao.impl.BookDAOImpl;
import com.library.dao.impl.IssueDAOImpl;
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

@WebServlet(name = "BookServlet", urlPatterns = {"/books", "/book-details", "/dashboard"})
public class BookServlet extends HttpServlet {

    private final BookDAO bookDAO = new BookDAOImpl();
    private final IssueDAO issueDAO = new IssueDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/dashboard":
                handleDashboard(request, response);
                break;
            case "/book-details":
                handleBookDetails(request, response);
                break;
            case "/books":
            default:
                handleBooksCatalog(request, response);
                break;
        }
    }

    private void handleDashboard(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Student student = (session != null) ? (Student) session.getAttribute("student") : null;

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int studentId = student.getId();

        // Retrieve real statistics for the student
        int totalBorrowed = issueDAO.getStudentBorrowedCount(studentId);
        int currentlyIssued = issueDAO.getStudentActiveCount(studentId);
        int returnedBooks = issueDAO.getStudentReturnedCount(studentId);
        int overdueBooks = issueDAO.getStudentOverdueCount(studentId);

        // Fetch currently borrowed books list
        List<IssuedBook> activeIssuedBooks = issueDAO.getActiveIssuedBooksByStudent(studentId);

        // Fetch recently added books and popular books
        List<Book> recentBooks = bookDAO.getRecentlyAddedBooks(6);
        List<Book> popularBooks = bookDAO.getPopularBooks(4);

        request.setAttribute("totalBorrowed", totalBorrowed);
        request.setAttribute("currentlyIssued", currentlyIssued);
        request.setAttribute("returnedBooks", returnedBooks);
        request.setAttribute("overdueBooks", overdueBooks);
        request.setAttribute("activeIssuedBooks", activeIssuedBooks);
        request.setAttribute("recentBooks", recentBooks);
        request.setAttribute("popularBooks", popularBooks);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

    private void handleBooksCatalog(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");
        String category = request.getParameter("category");

        List<Book> booksList = bookDAO.searchBooks(query, category);

        request.setAttribute("booksList", booksList);
        request.setAttribute("searchQuery", query != null ? query : "");
        request.setAttribute("selectedCategory", category != null ? category : "All");

        request.getRequestDispatcher("/books.jsp").forward(request, response);
    }

    private void handleBookDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        try {
            int bookId = Integer.parseInt(idStr.trim());
            Book book = bookDAO.getBookById(bookId);

            if (book == null) {
                request.setAttribute("errorMessage", "Book not found!");
                request.getRequestDispatcher("/books.jsp").forward(request, response);
                return;
            }

            // Check if current logged in student has already issued this book
            boolean isIssued = false;
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("student") != null) {
                Student student = (Student) session.getAttribute("student");
                isIssued = issueDAO.isAlreadyIssued(bookId, student.getId());
            }

            request.setAttribute("book", book);
            request.setAttribute("isAlreadyIssued", isIssued);
            request.getRequestDispatcher("/book-details.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/books");
        }
    }
}

