package com.library.dao.impl;

import com.library.dao.StudentDAO;
import com.library.model.Student;
import com.library.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class StudentDAOImpl implements StudentDAO {

    @Override
    public boolean registerStudent(Student student) {
        String sql = "INSERT INTO students (student_id, name, email, password, department, semester) VALUES (?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, student.getStudentId());
            ps.setString(2, student.getName());
            ps.setString(3, student.getEmail());
            ps.setString(4, student.getPassword());
            ps.setString(5, student.getDepartment());
            ps.setString(6, student.getSemester());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    @Override
    public Student loginStudent(String email, String password) {
        String sql = "SELECT * FROM students WHERE email = ? AND password = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToStudent(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    @Override
    public Student getStudentById(int id) {
        String sql = "SELECT * FROM students WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToStudent(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    @Override
    public List<Student> getAllStudents() {
        List<Student> list = new ArrayList<>();
        String sql = "SELECT * FROM students ORDER BY id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToStudent(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    @Override
    public int getTotalStudentsCount() {
        String sql = "SELECT COUNT(*) FROM students";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return 0;
    }

    @Override
    public boolean isEmailExists(String email) {
        String sql = "SELECT id FROM students WHERE email = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(rs, ps, conn);
        }
    }

    @Override
    public boolean isStudentIdExists(String studentId) {
        String sql = "SELECT id FROM students WHERE student_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, studentId);
            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(rs, ps, conn);
        }
    }

    private Student mapResultSetToStudent(ResultSet rs) throws SQLException {
        Student s = new Student();
        s.setId(rs.getInt("id"));
        s.setStudentId(rs.getString("student_id"));
        s.setName(rs.getString("name"));
        s.setEmail(rs.getString("email"));
        s.setPassword(rs.getString("password"));
        s.setDepartment(rs.getString("department"));
        s.setSemester(rs.getString("semester"));
        s.setCreatedAt(rs.getTimestamp("created_at"));
        return s;
    }
}

