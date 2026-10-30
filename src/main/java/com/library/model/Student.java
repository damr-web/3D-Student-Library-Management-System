package com.library.model;

import java.io.Serializable;
import java.sql.Timestamp;

public class Student implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String studentId;
    private String name;
    private String email;
    private String password;
    private String department;
    private String semester;
    private Timestamp createdAt;

    public Student() {}

    public Student(String studentId, String name, String email, String password, String department, String semester) {
        this.studentId = studentId;
        this.name = name;
        this.email = email;
        this.password = password;
        this.department = department;
        this.semester = semester;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStudentId() {
        return studentId;
    }

    public void setStudentId(String studentId) {
        this.studentId = studentId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getDepartment() {
        return department;
    }

    public void setDepartment(String department) {
        this.department = department;
    }

    public String getSemester() {
        return semester;
    }

    public void setSemester(String semester) {
        this.semester = semester;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}

