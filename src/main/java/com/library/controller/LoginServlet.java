package com.library.controller;

import com.library.dao.AdminDAO;
import com.library.dao.StudentDAO;
import com.library.dao.impl.AdminDAOImpl;
import com.library.dao.impl.StudentDAOImpl;
import com.library.model.Admin;
import com.library.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "LoginServlet", urlPatterns = {"/login", "/admin-login"})
public class LoginServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAOImpl();
    private final AdminDAO adminDAO = new AdminDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/admin-login".equals(path)) {
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();
        String role = request.getParameter("role");

        if ("/admin-login".equals(path) || "admin".equalsIgnoreCase(role)) {
            handleAdminLogin(request, response);
        } else {
            handleStudentLogin(request, response);
        }
    }

    private void handleStudentLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Email and Password are required!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        Student student = studentDAO.loginStudent(email.trim(), password.trim());
        if (student != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("student", student);
            session.setAttribute("userRole", "STUDENT");
            session.setAttribute("userName", student.getName());
            session.setAttribute("studentId", student.getId());
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("errorMessage", "Invalid student email or password. Please try again.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void handleAdminLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Username and Password are required!");
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
            return;
        }

        Admin admin = adminDAO.loginAdmin(username.trim(), password.trim());
        if (admin != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("admin", admin);
            session.setAttribute("userRole", "ADMIN");
            session.setAttribute("adminName", admin.getName());
            session.setAttribute("adminId", admin.getId());
            response.sendRedirect(request.getContextPath() + "/admin-dashboard");
        } else {
            request.setAttribute("errorMessage", "Invalid administrator credentials. Access denied.");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/admin-login.jsp").forward(request, response);
        }
    }
}

