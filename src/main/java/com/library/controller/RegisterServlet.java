package com.library.controller;

import com.library.dao.StudentDAO;
import com.library.dao.impl.StudentDAOImpl;
import com.library.model.Student;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private final StudentDAO studentDAO = new StudentDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String studentId = request.getParameter("studentId");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String department = request.getParameter("department");
        String semester = request.getParameter("semester");

        // Basic validation
        if (studentId == null || studentId.trim().isEmpty() ||
            name == null || name.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            department == null || department.trim().isEmpty() ||
            semester == null || semester.trim().isEmpty()) {

            request.setAttribute("errorMessage", "All registration fields are mandatory!");
            preserveFormFields(request, studentId, name, email, department, semester);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        studentId = studentId.trim();
        email = email.trim();

        // Check if student ID already registered
        if (studentDAO.isStudentIdExists(studentId)) {
            request.setAttribute("errorMessage", "Student ID '" + studentId + "' is already registered! Please log in.");
            preserveFormFields(request, studentId, name, email, department, semester);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Check if email already registered
        if (studentDAO.isEmailExists(email)) {
            request.setAttribute("errorMessage", "Email address '" + email + "' is already in use!");
            preserveFormFields(request, studentId, name, email, department, semester);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Create and register new student
        Student student = new Student(studentId, name.trim(), email, password.trim(), department.trim(), semester.trim());
        boolean success = studentDAO.registerStudent(student);

        if (success) {
            request.setAttribute("successMessage", "Account created successfully! You can now log in.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("errorMessage", "Registration failed due to a database error. Please try again.");
            preserveFormFields(request, studentId, name, email, department, semester);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void preserveFormFields(HttpServletRequest req, String studentId, String name, String email, String department, String semester) {
        req.setAttribute("studentIdVal", studentId);
        req.setAttribute("nameVal", name);
        req.setAttribute("emailVal", email);
        req.setAttribute("departmentVal", department);
        req.setAttribute("semesterVal", semester);
    }
}

