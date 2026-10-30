package com.library.dao.impl;

import com.library.dao.AdminDAO;
import com.library.model.Admin;
import com.library.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class AdminDAOImpl implements AdminDAO {

    @Override
    public Admin loginAdmin(String username, String password) {
        String sql = "SELECT * FROM admins WHERE (username = ? OR email = ?) AND password = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, username);
            ps.setString(3, password);
            rs = ps.executeQuery();
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password"));
                admin.setName(rs.getString("name"));
                admin.setEmail(rs.getString("email"));
                admin.setCreatedAt(rs.getTimestamp("created_at"));
                return admin;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    @Override
    public Admin getAdminById(int id) {
        String sql = "SELECT * FROM admins WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                Admin admin = new Admin();
                admin.setId(rs.getInt("id"));
                admin.setUsername(rs.getString("username"));
                admin.setPassword(rs.getString("password"));
                admin.setName(rs.getString("name"));
                admin.setEmail(rs.getString("email"));
                admin.setCreatedAt(rs.getTimestamp("created_at"));
                return admin;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }
}

