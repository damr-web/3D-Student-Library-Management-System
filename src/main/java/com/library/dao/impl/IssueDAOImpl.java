package com.library.dao.impl;

import com.library.dao.IssueDAO;
import com.library.model.IssuedBook;
import com.library.util.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class IssueDAOImpl implements IssueDAO {

    @Override
    public boolean issueBook(int bookId, int studentId, int days) {
        if (days <= 0) {
            days = 14; // Default borrowing period: 14 days
        }

        Connection conn = null;
        PreparedStatement psCheck = null;
        PreparedStatement psIssue = null;
        PreparedStatement psUpdateBook = null;
        ResultSet rsCheck = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin transaction

            // 1. Check if book has available copies
            String checkSql = "SELECT available_copies FROM books WHERE id = ? FOR UPDATE";
            psCheck = conn.prepareStatement(checkSql);
            psCheck.setInt(1, bookId);
            rsCheck = psCheck.executeQuery();

            if (!rsCheck.next() || rsCheck.getInt("available_copies") <= 0) {
                conn.rollback();
                return false;
            }

            // 2. Insert into issued_books
            LocalDate today = LocalDate.now();
            LocalDate dueDate = today.plusDays(days);

            String issueSql = "INSERT INTO issued_books (book_id, student_id, issue_date, due_date, status, fine) VALUES (?, ?, ?, ?, 'ISSUED', 0.00)";
            psIssue = conn.prepareStatement(issueSql);
            psIssue.setInt(1, bookId);
            psIssue.setInt(2, studentId);
            psIssue.setDate(3, Date.valueOf(today));
            psIssue.setDate(4, Date.valueOf(dueDate));
            int rowsIssued = psIssue.executeUpdate();

            // 3. Decrement available copies
            String updateSql = "UPDATE books SET available_copies = available_copies - 1 WHERE id = ?";
            psUpdateBook = conn.prepareStatement(updateSql);
            psUpdateBook.setInt(1, bookId);
            int rowsUpdated = psUpdateBook.executeUpdate();

            if (rowsIssued > 0 && rowsUpdated > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(rsCheck, psCheck, psIssue, psUpdateBook, conn);
        }
    }

    @Override
    public boolean returnBook(int issueId, int bookId, int studentId) {
        Connection conn = null;
        PreparedStatement psUpdateIssue = null;
        PreparedStatement psHistory = null;
        PreparedStatement psUpdateBook = null;
        PreparedStatement psGetIssue = null;
        ResultSet rs = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin transaction

            // Fetch issue record to get issue_date
            String getSql = "SELECT * FROM issued_books WHERE id = ? AND status != 'RETURNED'";
            psGetIssue = conn.prepareStatement(getSql);
            psGetIssue.setInt(1, issueId);
            rs = psGetIssue.executeQuery();

            if (!rs.next()) {
                conn.rollback();
                return false;
            }

            Date issueDate = rs.getDate("issue_date");
            LocalDate returnDateLocal = LocalDate.now();
            Date returnDate = Date.valueOf(returnDateLocal);

            // 1. Update issued_books
            String updateIssueSql = "UPDATE issued_books SET return_date = ?, status = 'RETURNED' WHERE id = ?";
            psUpdateIssue = conn.prepareStatement(updateIssueSql);
            psUpdateIssue.setDate(1, returnDate);
            psUpdateIssue.setInt(2, issueId);
            int rowsUpdated = psUpdateIssue.executeUpdate();

            // 2. Insert into borrow_history
            String historySql = "INSERT INTO borrow_history (issue_id, book_id, student_id, issue_date, return_date, status) VALUES (?, ?, ?, ?, ?, 'RETURNED')";
            psHistory = conn.prepareStatement(historySql);
            psHistory.setInt(1, issueId);
            psHistory.setInt(2, bookId);
            psHistory.setInt(3, studentId);
            psHistory.setDate(4, issueDate);
            psHistory.setDate(5, returnDate);
            psHistory.executeUpdate();

            // 3. Increment book available copies
            String updateBookSql = "UPDATE books SET available_copies = available_copies + 1 WHERE id = ?";
            psUpdateBook = conn.prepareStatement(updateBookSql);
            psUpdateBook.setInt(1, bookId);
            psUpdateBook.executeUpdate();

            if (rowsUpdated > 0) {
                conn.commit();
                return true;
            } else {
                conn.rollback();
                return false;
            }

        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(rs, psGetIssue, psUpdateIssue, psHistory, psUpdateBook, conn);
        }
    }

    @Override
    public List<IssuedBook> getActiveIssuedBooksByStudent(int studentId) {
        String sql = "SELECT ib.*, b.title, b.author, b.category, b.cover_image, s.name as student_name, s.student_id as student_id_str, s.department " +
                     "FROM issued_books ib " +
                     "JOIN books b ON ib.book_id = b.id " +
                     "JOIN students s ON ib.student_id = s.id " +
                     "WHERE ib.student_id = ? AND ib.status != 'RETURNED' " +
                     "ORDER BY ib.due_date ASC";
        return fetchIssuedBooksList(sql, studentId);
    }

    @Override
    public List<IssuedBook> getAllHistoryByStudent(int studentId) {
        String sql = "SELECT ib.*, b.title, b.author, b.category, b.cover_image, s.name as student_name, s.student_id as student_id_str, s.department " +
                     "FROM issued_books ib " +
                     "JOIN books b ON ib.book_id = b.id " +
                     "JOIN students s ON ib.student_id = s.id " +
                     "WHERE ib.student_id = ? " +
                     "ORDER BY ib.id DESC";
        return fetchIssuedBooksList(sql, studentId);
    }

    @Override
    public List<IssuedBook> getAllActiveIssuedBooks() {
        String sql = "SELECT ib.*, b.title, b.author, b.category, b.cover_image, s.name as student_name, s.student_id as student_id_str, s.department " +
                     "FROM issued_books ib " +
                     "JOIN books b ON ib.book_id = b.id " +
                     "JOIN students s ON ib.student_id = s.id " +
                     "WHERE ib.status != 'RETURNED' " +
                     "ORDER BY ib.due_date ASC";
        return fetchIssuedBooksList(sql, null);
    }

    @Override
    public List<IssuedBook> getAllReturnedBooks() {
        String sql = "SELECT ib.*, b.title, b.author, b.category, b.cover_image, s.name as student_name, s.student_id as student_id_str, s.department " +
                     "FROM issued_books ib " +
                     "JOIN books b ON ib.book_id = b.id " +
                     "JOIN students s ON ib.student_id = s.id " +
                     "WHERE ib.status = 'RETURNED' " +
                     "ORDER BY ib.return_date DESC";
        return fetchIssuedBooksList(sql, null);
    }

    @Override
    public List<IssuedBook> getOverdueBooks() {
        String sql = "SELECT ib.*, b.title, b.author, b.category, b.cover_image, s.name as student_name, s.student_id as student_id_str, s.department " +
                     "FROM issued_books ib " +
                     "JOIN books b ON ib.book_id = b.id " +
                     "JOIN students s ON ib.student_id = s.id " +
                     "WHERE ib.status != 'RETURNED' AND ib.due_date < CURDATE() " +
                     "ORDER BY ib.due_date ASC";
        return fetchIssuedBooksList(sql, null);
    }

    @Override
    public int getTotalIssuedCount() {
        return getCount("SELECT COUNT(*) FROM issued_books");
    }

    @Override
    public int getActiveIssuedCount() {
        return getCount("SELECT COUNT(*) FROM issued_books WHERE status != 'RETURNED'");
    }

    @Override
    public int getReturnedCount() {
        return getCount("SELECT COUNT(*) FROM issued_books WHERE status = 'RETURNED'");
    }

    @Override
    public int getOverdueCount() {
        return getCount("SELECT COUNT(*) FROM issued_books WHERE status != 'RETURNED' AND due_date < CURDATE()");
    }

    @Override
    public int getStudentBorrowedCount(int studentId) {
        return getCount("SELECT COUNT(*) FROM issued_books WHERE student_id = ?", studentId);
    }

    @Override
    public int getStudentActiveCount(int studentId) {
        return getCount("SELECT COUNT(*) FROM issued_books WHERE student_id = ? AND status != 'RETURNED'", studentId);
    }

    @Override
    public int getStudentReturnedCount(int studentId) {
        return getCount("SELECT COUNT(*) FROM issued_books WHERE student_id = ? AND status = 'RETURNED'", studentId);
    }

    @Override
    public int getStudentOverdueCount(int studentId) {
        return getCount("SELECT COUNT(*) FROM issued_books WHERE student_id = ? AND status != 'RETURNED' AND due_date < CURDATE()", studentId);
    }

    @Override
    public boolean isAlreadyIssued(int bookId, int studentId) {
        String sql = "SELECT id FROM issued_books WHERE book_id = ? AND student_id = ? AND status != 'RETURNED'";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookId);
            ps.setInt(2, studentId);
            rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(rs, ps, conn);
        }
    }

    private List<IssuedBook> fetchIssuedBooksList(String sql, Integer param) {
        List<IssuedBook> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            if (param != null) {
                ps.setInt(1, param);
            }
            rs = ps.executeQuery();
            LocalDate today = LocalDate.now();

            while (rs.next()) {
                IssuedBook ib = new IssuedBook();
                ib.setId(rs.getInt("id"));
                ib.setBookId(rs.getInt("book_id"));
                ib.setStudentId(rs.getInt("student_id"));
                ib.setIssueDate(rs.getDate("issue_date"));
                ib.setDueDate(rs.getDate("due_date"));
                ib.setReturnDate(rs.getDate("return_date"));
                ib.setStatus(rs.getString("status"));
                ib.setFine(rs.getBigDecimal("fine"));
                ib.setCreatedAt(rs.getTimestamp("created_at"));

                ib.setBookTitle(rs.getString("title"));
                ib.setBookAuthor(rs.getString("author"));
                ib.setBookCategory(rs.getString("category"));
                ib.setBookCover(rs.getString("cover_image"));
                ib.setStudentName(rs.getString("student_name"));
                ib.setStudentIdStr(rs.getString("student_id_str"));
                ib.setStudentDept(rs.getString("department"));

                // Calculate days remaining and overdue status
                if (ib.getDueDate() != null) {
                    LocalDate due = ib.getDueDate().toLocalDate();
                    long diff = ChronoUnit.DAYS.between(today, due);
                    ib.setDaysRemaining(diff);
                    if (diff < 0 && !"RETURNED".equalsIgnoreCase(ib.getStatus())) {
                        ib.setOverdue(true);
                        ib.setStatus("OVERDUE");
                        // Calculate overdue fine (e.g., $1.00 / 5 INR per day overdue)
                        long overdueDays = Math.abs(diff);
                        ib.setFine(BigDecimal.valueOf(overdueDays * 5.00));
                    } else {
                        ib.setOverdue(false);
                    }
                }

                list.add(ib);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    private int getCount(String sql, Object... params) {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
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
}

