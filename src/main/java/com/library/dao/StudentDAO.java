package com.library.dao;

import com.library.model.Student;
import java.util.List;

public interface StudentDAO {
    boolean registerStudent(Student student);
    Student loginStudent(String email, String password);
    Student getStudentById(int id);
    List<Student> getAllStudents();
    int getTotalStudentsCount();
    boolean isEmailExists(String email);
    boolean isStudentIdExists(String studentId);
}

