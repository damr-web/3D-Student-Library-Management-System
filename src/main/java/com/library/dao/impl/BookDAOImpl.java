package com.library.dao.impl;

import com.library.dao.BookDAO;
import com.library.model.Book;
import com.library.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookDAOImpl implements BookDAO {

    @Override
    public boolean addBook(Book book) {
        String sql = "INSERT INTO books (title, author, category, isbn, publisher, quantity, available_copies, cover_image, description) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getAuthor());
            ps.setString(3, book.getCategory());
            ps.setString(4, book.getIsbn());
            ps.setString(5, book.getPublisher());
            ps.setInt(6, book.getQuantity());
            ps.setInt(7, book.getAvailableCopies());
            ps.setString(8, book.getCoverImage());
            ps.setString(9, book.getDescription());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    @Override
    public boolean updateBook(Book book) {
        String sql = "UPDATE books SET title = ?, author = ?, category = ?, isbn = ?, publisher = ?, quantity = ?, available_copies = ?, cover_image = ?, description = ? WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, book.getTitle());
            ps.setString(2, book.getAuthor());
            ps.setString(3, book.getCategory());
            ps.setString(4, book.getIsbn());
            ps.setString(5, book.getPublisher());
            ps.setInt(6, book.getQuantity());
            ps.setInt(7, book.getAvailableCopies());
            ps.setString(8, book.getCoverImage());
            ps.setString(9, book.getDescription());
            ps.setInt(10, book.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    @Override
    public boolean deleteBook(int id) {
        String sql = "DELETE FROM books WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    @Override
    public Book getBookById(int id) {
        String sql = "SELECT * FROM books WHERE id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToBook(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return null;
    }

    @Override
    public List<Book> getAllBooks() {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY id DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    @Override
    public List<Book> searchBooks(String query, String category) {
        List<Book> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM books WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (query != null && !query.trim().isEmpty()) {
            sql.append("AND (LOWER(title) LIKE ? OR LOWER(author) LIKE ? OR LOWER(isbn) LIKE ? OR LOWER(publisher) LIKE ?) ");
            String q = "%" + query.trim().toLowerCase() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
            params.add(q);
        }

        if (category != null && !category.trim().isEmpty() && !category.equalsIgnoreCase("All")) {
            sql.append("AND category = ? ");
            params.add(category.trim());
        }

        sql.append("ORDER BY id DESC");

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    @Override
    public List<Book> getRecentlyAddedBooks(int limit) {
        List<Book> list = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY created_at DESC, id DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    @Override
    public List<Book> getPopularBooks(int limit) {
        List<Book> list = new ArrayList<>();
        // Order by count of borrows in issued_books / borrow_history, falling back to quantity-available
        String sql = "SELECT b.*, COALESCE(sub.issue_count, 0) as borrow_cnt " +
                     "FROM books b " +
                     "LEFT JOIN (SELECT book_id, COUNT(*) as issue_count FROM issued_books GROUP BY book_id) sub " +
                     "ON b.id = sub.book_id " +
                     "ORDER BY borrow_cnt DESC, b.id ASC LIMIT ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next()) {
                list.add(mapResultSetToBook(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            DBConnection.close(rs, ps, conn);
        }
        return list;
    }

    @Override
    public int getTotalBooksCount() {
        String sql = "SELECT COUNT(*) FROM books";
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
    public int getTotalCopiesCount() {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM books";
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
    public boolean decrementAvailableCopies(int bookId) {
        String sql = "UPDATE books SET available_copies = available_copies - 1 WHERE id = ? AND available_copies > 0";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    @Override
    public boolean incrementAvailableCopies(int bookId) {
        String sql = "UPDATE books SET available_copies = available_copies + 1 WHERE id = ? AND available_copies < quantity";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBConnection.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, bookId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        } finally {
            DBConnection.close(ps, conn);
        }
    }

    private Book mapResultSetToBook(ResultSet rs) throws SQLException {
        Book b = new Book();
        b.setId(rs.getInt("id"));
        b.setTitle(rs.getString("title"));
        b.setAuthor(rs.getString("author"));
        b.setCategory(rs.getString("category"));
        b.setIsbn(rs.getString("isbn"));
        b.setPublisher(rs.getString("publisher"));
        b.setQuantity(rs.getInt("quantity"));
        b.setAvailableCopies(rs.getInt("available_copies"));
        b.setCoverImage(rs.getString("cover_image"));
        b.setDescription(rs.getString("description"));
        b.setCreatedAt(rs.getTimestamp("created_at"));
        return b;
    }
}

