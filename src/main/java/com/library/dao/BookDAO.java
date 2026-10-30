package com.library.dao;

import com.library.model.Book;
import java.util.List;

public interface BookDAO {
    boolean addBook(Book book);
    boolean updateBook(Book book);
    boolean deleteBook(int id);
    Book getBookById(int id);
    List<Book> getAllBooks();
    List<Book> searchBooks(String query, String category);
    List<Book> getRecentlyAddedBooks(int limit);
    List<Book> getPopularBooks(int limit);
    int getTotalBooksCount();
    int getTotalCopiesCount();
    boolean decrementAvailableCopies(int bookId);
    boolean incrementAvailableCopies(int bookId);
}

