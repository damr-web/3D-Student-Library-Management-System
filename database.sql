-- ====================================================================
-- Database: student_library_db
-- Description: 3D Student Library Management System Database Schema
-- Technology: MySQL 8.0+
-- ====================================================================

DROP DATABASE IF EXISTS student_library_db;
CREATE DATABASE student_library_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE student_library_db;

-- --------------------------------------------------------------------
-- 1. Table: admins
-- --------------------------------------------------------------------
CREATE TABLE admins (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 2. Table: students
-- --------------------------------------------------------------------
CREATE TABLE students (
    id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    department VARCHAR(100) NOT NULL,
    semester VARCHAR(20) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 3. Table: books
-- --------------------------------------------------------------------
CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    author VARCHAR(150) NOT NULL,
    category VARCHAR(80) NOT NULL,
    isbn VARCHAR(50) NOT NULL UNIQUE,
    publisher VARCHAR(150) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    cover_image VARCHAR(255) DEFAULT 'default-book.png',
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT chk_quantity CHECK (quantity >= 0),
    CONSTRAINT chk_available CHECK (available_copies >= 0 AND available_copies <= quantity)
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 4. Table: issued_books
-- --------------------------------------------------------------------
CREATE TABLE issued_books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    student_id INT NOT NULL,
    issue_date DATE NOT NULL,
    due_date DATE NOT NULL,
    return_date DATE DEFAULT NULL,
    status ENUM('ISSUED', 'RETURNED', 'OVERDUE') NOT NULL DEFAULT 'ISSUED',
    fine DECIMAL(8,2) DEFAULT 0.00,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- --------------------------------------------------------------------
-- 5. Table: borrow_history
-- --------------------------------------------------------------------
CREATE TABLE borrow_history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    issue_id INT NOT NULL,
    book_id INT NOT NULL,
    student_id INT NOT NULL,
    issue_date DATE NOT NULL,
    return_date DATE NOT NULL,
    status VARCHAR(50) NOT NULL DEFAULT 'RETURNED',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES students(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- ====================================================================
-- SEED DATA
-- ====================================================================

-- Default Admins
INSERT INTO admins (username, password, name, email) VALUES
('admin', 'admin123', 'Library Administrator', 'admin@library.edu'),
('librarian', 'lib2026', 'Senior Librarian Alex', 'alex.librarian@library.edu');

-- Sample Students
INSERT INTO students (student_id, name, email, password, department, semester) VALUES
('STU-2026-001', 'Aarav Sharma', 'aarav.sharma@student.edu', 'student123', 'Computer Science & Engineering', '6th'),
('STU-2026-002', 'Sophia Chen', 'sophia.chen@student.edu', 'student123', 'Artificial Intelligence & Data Science', '4th'),
('STU-2026-003', 'Rohan Patel', 'rohan.patel@student.edu', 'student123', 'Information Technology', '8th'),
('STU-2026-004', 'Emma Watson', 'emma.watson@student.edu', 'student123', 'Electronics & Communication', '5th');

-- Sample Books Across All Categories
INSERT INTO books (title, author, category, isbn, publisher, quantity, available_copies, cover_image, description) VALUES
('Clean Code: A Handbook of Agile Software Craftsmanship', 'Robert C. Martin', 'Programming', '978-0132350884', 'Prentice Hall', 6, 5, 'https://images.unsplash.com/photo-1532012164546-f432f2e3777a?w=400', 'Even bad code can function. But if code isn''t clean, it can bring a development organization to its knees. Learn how to write agile, maintainable code.'),
('Artificial Intelligence: A Modern Approach', 'Stuart Russell and Peter Norvig', 'Artificial Intelligence', '978-0136042594', 'Pearson', 5, 4, 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?w=400', 'The long-anticipated revision of this best-selling comprehensive introduction to Artificial Intelligence and machine learning paradigms.'),
('Introduction to Algorithms (CLRS)', 'Thomas H. Cormen, Charles E. Leiserson', 'Computer Science', '978-0262033848', 'MIT Press', 8, 7, 'https://images.unsplash.com/photo-1516979187457-637abb4f9353?w=400', 'A comprehensive textbook covering broad spectrums of algorithms in depth, yet making their design and analysis accessible to all levels.'),
('Computer Networking: A Top-Down Approach', 'James F. Kurose, Keith W. Ross', 'Networking', '978-0133594140', 'Pearson', 5, 4, 'https://images.unsplash.com/photo-1544716278-ca5e3f4abd8c?w=400', 'Focuses on the Internet and modern networking architectures with a top-down approach through application layers down to physical transmission.'),
('Database System Concepts (7th Edition)', 'Abraham Silberschatz, Henry F. Korth', 'Database Management', '978-0078022159', 'McGraw-Hill', 7, 6, 'https://images.unsplash.com/photo-1507842229451-9f798e4f55ef?w=400', 'Fundamental concepts of database management, relational algebra, SQL optimization, transactions, and distributed modern DB architectures.'),
('Discrete Mathematics and Its Applications', 'Kenneth H. Rosen', 'Mathematics', '978-0073383095', 'McGraw-Hill', 4, 4, 'https://images.unsplash.com/photo-1509228468518-180dd4864904?w=400', 'Essential mathematical structures, proofs, combinatorics, graph theory, and discrete probability tailored for computer science students.'),
('A Brief History of Time', 'Stephen Hawking', 'Science', '978-0553380163', 'Bantam Books', 5, 5, 'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=400', 'A landmark volume in science writing exploring black holes, expanding universe, quantum physics, and cosmology.'),
('Cosmos', 'Carl Sagan', 'Science', '978-0345331359', 'Ballantine Books', 4, 3, 'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=400', 'The story of cosmic evolution, science and civilization, exploring the vast universe and our unique place within it.'),
('The Pragmatic Programmer: Your Journey To Mastery', 'David Thomas, Andrew Hunt', 'Programming', '978-0135957059', 'Addison-Wesley', 6, 6, 'https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=400', 'One of the most significant books on software engineering, covering career development, architectural principles, and craftsmanship.'),
('Deep Learning', 'Ian Goodfellow, Yoshua Bengio, Aaron Courville', 'Artificial Intelligence', '978-0262035613', 'MIT Press', 5, 5, 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=400', 'A comprehensive resource on mathematical foundations, deep feedforward networks, regularization, convolutional networks, and generative models.'),
('General Knowledge 2026 Manual', 'Dr. Manish Rannjan', 'General Knowledge', '978-9351762118', 'Prabhat Prakashan', 10, 9, 'https://images.unsplash.com/photo-1497633762265-9d179a990aa6?w=400', 'A comprehensive compendium covering Indian and World history, geography, economy, scientific discoveries, and international organizations.'),
('Design Patterns: Elements of Reusable Object-Oriented Software', 'Erich Gamma, Richard Helm, Ralph Johnson, John Vlissides', 'Programming', '978-0201633610', 'Addison-Wesley', 4, 3, 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?w=400', 'Captures a wealth of experience about the design of object-oriented software. 23 classic software design patterns explained with rigor.');

-- Sample Issued Books
INSERT INTO issued_books (book_id, student_id, issue_date, due_date, return_date, status, fine) VALUES
(1, 1, DATE_SUB(CURDATE(), INTERVAL 5 DAY), DATE_ADD(CURDATE(), INTERVAL 9 DAY), NULL, 'ISSUED', 0.00),
(2, 1, DATE_SUB(CURDATE(), INTERVAL 18 DAY), DATE_SUB(CURDATE(), INTERVAL 4 DAY), NULL, 'OVERDUE', 20.00),
(4, 2, DATE_SUB(CURDATE(), INTERVAL 2 DAY), DATE_ADD(CURDATE(), INTERVAL 12 DAY), NULL, 'ISSUED', 0.00),
(5, 3, DATE_SUB(CURDATE(), INTERVAL 20 DAY), DATE_SUB(CURDATE(), INTERVAL 6 DAY), CURDATE(), 'RETURNED', 0.00);

-- Sample Borrow History
INSERT INTO borrow_history (issue_id, book_id, student_id, issue_date, return_date, status) VALUES
(4, 5, 3, DATE_SUB(CURDATE(), INTERVAL 20 DAY), CURDATE(), 'RETURNED');

