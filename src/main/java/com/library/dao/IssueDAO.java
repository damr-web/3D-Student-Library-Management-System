package com.library.dao;

import com.library.model.IssuedBook;
import java.util.List;

public interface IssueDAO {
    boolean issueBook(int bookId, int studentId, int days);
    boolean returnBook(int issueId, int bookId, int studentId);
    List<IssuedBook> getActiveIssuedBooksByStudent(int studentId);
    List<IssuedBook> getAllHistoryByStudent(int studentId);
    List<IssuedBook> getAllActiveIssuedBooks();
    List<IssuedBook> getAllReturnedBooks();
    List<IssuedBook> getOverdueBooks();
    int getTotalIssuedCount();
    int getActiveIssuedCount();
    int getReturnedCount();
    int getOverdueCount();
    int getStudentBorrowedCount(int studentId);
    int getStudentActiveCount(int studentId);
    int getStudentReturnedCount(int studentId);
    int getStudentOverdueCount(int studentId);
    boolean isAlreadyIssued(int bookId, int studentId);
}

