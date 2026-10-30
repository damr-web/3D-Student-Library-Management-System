package com.library.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection provides centralized and robust JDBC database connectivity
 * for MySQL 8.0+ using the standard MySQL Connector/J driver.
 */
public class DBConnection {

    private static final String URL = "jdbc:mysql://localhost:3306/student_library_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
    private static final String USER = "root";
    private static final String PASSWORD = "Darshan@123";

    static {
        try {
            // Load MySQL 8+ JDBC Driver explicitly
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println("CRITICAL: MySQL JDBC Driver not found in classpath!");
            e.printStackTrace();
        }
    }

    /**
     * Obtains a new database connection.
     * @return Connection object
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        try {
            return DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (SQLException e) {
            // Fallback attempt with empty password if default "root" fails
            try {
                return DriverManager.getConnection(URL, USER, "");
            } catch (SQLException fallbackEx) {
                System.err.println("Database Connection Failed: " + e.getMessage());
                throw e;
            }
        }
    }

    /**
     * Safely closes open AutoCloseable resources (Connection, Statement, ResultSet).
     * @param closeables AutoCloseable resources to close
     */
    public static void close(AutoCloseable... closeables) {
        for (AutoCloseable c : closeables) {
            if (c != null) {
                try {
                    c.close();
                } catch (Exception e) {
                    // Suppress close exceptions to avoid masking primary exceptions
                }
            }
        }
    }
}

