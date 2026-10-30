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

@WebServlet(name = "IssueBookServlet", urlPatterns = {"/issue-book", "/my-books", "/history"})
public class IssueBookServlet extends HttpServlet {

    private final IssueDAO issueDAO = new IssueDAOImpl();
    private final BookDAO bookDAO = new BookDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        HttpSession session = request.getSession(false);
        Student student = (session != null) ? (Student) session.getAttribute("student") : null;

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int studentId = student.getId();

        if ("/my-books".equals(path)) {
            List<IssuedBook> activeBooks = issueDAO.getActiveIssuedBooksByStudent(studentId);
            request.setAttribute("activeBooks", activeBooks);
            request.getRequestDispatcher("/my-books.jsp").forward(request, response);
        } else if ("/history".equals(path)) {
            List<IssuedBook> historyBooks = issueDAO.getAllHistoryByStudent(studentId);
            request.setAttribute("historyBooks", historyBooks);
            request.getRequestDispatcher("/history.jsp").forward(request, response);
        } else {
            response.sendRedirect(request.getContextPath() + "/books");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Student student = (session != null) ? (Student) session.getAttribute("student") : null;

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String bookIdStr = request.getParameter("bookId");
        String daysStr = request.getParameter("days");

        if (bookIdStr == null || bookIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Invalid book selection!");
            response.sendRedirect(request.getContextPath() + "/books");
            return;
        }

        try {
            int bookId = Integer.parseInt(bookIdStr.trim());
            int days = 14; // Default borrowing period: 14 days
            if (daysStr != null && !daysStr.trim().isEmpty()) {
                try {
                    days = Integer.parseInt(daysStr.trim());
                } catch (NumberFormatException ignored) {}
            }

            // 1. Verify book exists and has available copies
            Book book = bookDAO.getBookById(bookId);
            if (book == null) {
                request.getSession().setAttribute("errorMessage", "Book not found!");
                response.sendRedirect(request.getContextPath() + "/books");
                return;
            }

            if (book.getAvailableCopies() <= 0) {
                request.getSession().setAttribute("errorMessage", "Sorry, '" + book.getTitle() + "' is currently out of stock!");
                response.sendRedirect(request.getContextPath() + "/book-details?id=" + bookId);
                return;
            }

            // 2. Prevent issuing duplicate active book
            if (issueDAO.isAlreadyIssued(bookId, student.getId())) {
                request.getSession().setAttribute("errorMessage", "You have already issued this book! Please return your existing copy first.");
                response.sendRedirect(request.getContextPath() + "/my-books");
                return;
            }

            // 3. Issue the book
            boolean success = issueDAO.issueBook(bookId, student.getId(), days);

            if (success) {
                request.getSession().setAttribute("successMessage", "Book '" + book.getTitle() + "' successfully issued for " + days + " days!");
                response.sendRedirect(request.getContextPath() + "/my-books");
            } else {
                request.getSession().setAttribute("errorMessage", "Unable to issue book. Please try again.");
                response.sendRedirect(request.getContextPath() + "/book-details?id=" + bookId);
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/books");
        }
    }
}

