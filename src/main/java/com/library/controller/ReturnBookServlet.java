package com.library.controller;

import com.library.dao.IssueDAO;
import com.library.dao.impl.IssueDAOImpl;
import com.library.model.Admin;
import com.library.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "ReturnBookServlet", urlPatterns = {"/return-book"})
public class ReturnBookServlet extends HttpServlet {

    private final IssueDAO issueDAO = new IssueDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Student student = (session != null) ? (Student) session.getAttribute("student") : null;
        Admin admin = (session != null) ? (Admin) session.getAttribute("admin") : null;

        if (student == null && admin == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String issueIdStr = request.getParameter("issueId");
        String bookIdStr = request.getParameter("bookId");
        String studentIdStr = request.getParameter("studentId");

        if (issueIdStr == null || bookIdStr == null) {
            response.sendRedirect(request.getContextPath() + (student != null ? "/my-books" : "/admin-issues"));
            return;
        }

        try {
            int issueId = Integer.parseInt(issueIdStr.trim());
            int bookId = Integer.parseInt(bookIdStr.trim());
            int targetStudentId = (student != null) ? student.getId() : Integer.parseInt(studentIdStr.trim());

            boolean success = issueDAO.returnBook(issueId, bookId, targetStudentId);

            if (success) {
                if (student != null) {
                    session.setAttribute("successMessage", "Book successfully returned! Thank you.");
                    response.sendRedirect(request.getContextPath() + "/my-books");
                } else {
                    session.setAttribute("successMessage", "Book return processed successfully.");
                    response.sendRedirect(request.getContextPath() + "/admin-issues");
                }
            } else {
                if (student != null) {
                    session.setAttribute("errorMessage", "Failed to process book return. Please contact the librarian.");
                    response.sendRedirect(request.getContextPath() + "/my-books");
                } else {
                    session.setAttribute("errorMessage", "Failed to process book return.");
                    response.sendRedirect(request.getContextPath() + "/admin-issues");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + (student != null ? "/my-books" : "/admin-issues"));
        }
    }
}

