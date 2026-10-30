# 📚 3D Student Library Management System
**Advanced Java / J2EE & Three.js Web Application**

A full-stack, enterprise-grade, visually stunning 3D University Library Management System built strictly using **Core Java, Advanced Java (Jakarta EE 10 / Servlets 6.0, JSP 3.1), JDBC with PreparedStatement, MVC Architecture, DAO Design Pattern, MySQL 8.0, and Apache Tomcat 10.1**, with real-time 3D rendering powered by **Three.js**.

---

## 🌟 Key Highlights & Features

- **No ORM or Non-Java Frameworks**: Pure Core Java, Servlets, JSP, and raw JDBC PreparedStatements. No Python, Flask, Spring Boot, or Hibernate used.
- **Interactive 3D Library Environment (Three.js)**:
  - 3D multi-tier architectural bookshelf.
  - Realistic 3D Books with textured covers, spines, and page cores.
  - Floating and rotating 3D books animated via sinusoidal physics.
  - 1,200 floating knowledge energy motes (particle dust).
  - Mouse parallax camera movement & Raycasting hover interaction.
  - **Standalone 3D Book Viewer**: 360-degree mouse drag orbit inspection on book details page.
- **Futuristic Dark Navy / Purple / Cyan UI**:
  - Glassmorphism design (`backdrop-filter: blur(16px)`).
  - Glowing neon cyan borders and animated stat counters.
  - Fully responsive Bootstrap 5 layout.
- **Comprehensive Student Module**:
  - Registration with Student ID, Name, Email, Password, Department, Semester.
  - Secure authentication and session tracking.
  - Real-time dashboard metrics (Total Borrowed, Currently Issued, Returned, Overdue).
  - Book catalog browsing with keyword search and category filtering.
  - 1-Click Book Issuing (14-day default borrowing period with automatic due date computation).
  - Book return system with automated stock increment and borrowing history logging.
  - Active issues tracking with countdown of days remaining and overdue penalty calculation.
- **Robust Admin & Circulation Module**:
  - Dedicated secure Admin authentication portal.
  - Executive analytics dashboard (Unique titles, Total inventory copies, Registered students, Active loans, Overdue track).
  - Full CRUD Book Management (Add new volumes, edit metadata/inventory, delete books).
  - Registered students directory.
  - Circulation desk with filtered views (Active, Overdue, Returned Archive) and manual return override.

---

## 🏗️ Technology Stack

| Component | Technology | Version |
|---|---|---|
| **Language** | Java Standard Edition | Java 17 LTS |
| **Enterprise Standard** | Jakarta EE | Jakarta EE 10 |
| **Web Server / Servlet Container** | Apache Tomcat | 10.1.x (Servlet 6.0 / JSP 3.1) |
| **Database** | MySQL | 8.0+ |
| **Driver** | MySQL Connector/J | 8.3.0 |
| **Architecture** | Model-View-Controller (MVC) | DAO Design Pattern |
| **Query Mechanism** | JDBC `PreparedStatement` | Raw SQL with ACID Transactions |
| **Frontend UI** | HTML5, CSS3 (Glassmorphism), JavaScript | Bootstrap 5.3.2 |
| **3D Rendering** | Three.js | r128 |
| **Build Tool** | Apache Maven | 3.8+ |

---

## 📁 Project Directory Structure

```
StudentLibraryManagement/
├── src/main/java/
│   └── com/library/
│       ├── model/
│       │   ├── Student.java        # Student entity model
│       │   ├── Admin.java          # Administrator entity model
│       │   ├── Book.java           # Book catalog model
│       │   └── IssuedBook.java     # Issued book & loan record model
│       ├── dao/
│       │   ├── StudentDAO.java     # Student database contract
│       │   ├── AdminDAO.java       # Admin database contract
│       │   ├── BookDAO.java        # Book CRUD database contract
│       │   └── IssueDAO.java       # Circulation & loan operations contract
│       ├── dao/impl/
│       │   ├── StudentDAOImpl.java # Student JDBC implementation
│       │   ├── AdminDAOImpl.java   # Admin JDBC implementation
│       │   ├── BookDAOImpl.java    # Book JDBC implementation
│       │   └── IssueDAOImpl.java   # Circulation JDBC implementation
│       ├── controller/
│       │   ├── LoginServlet.java       # Handles student & admin authentication
│       │   ├── RegisterServlet.java    # Handles student account registration
│       │   ├── BookServlet.java        # Catalog, search, filters & dashboard
│       │   ├── IssueBookServlet.java   # Book issue logic & active books view
│       │   ├── ReturnBookServlet.java  # Book return & stock synchronization
│       │   ├── AdminServlet.java       # Admin CRUD & circulation control
│       │   └── LogoutServlet.java      # Session invalidation & sign out
│       └── util/
│           └── DBConnection.java       # Thread-safe JDBC Connection factory
├── src/main/webapp/
│   ├── css/
│   │   └── style.css               # Futuristic glassmorphism stylesheets
│   ├── js/
│   │   ├── three-scene.js          # Three.js 3D library background scene
│   │   ├── 3d-book-viewer.js       # Three.js 360-degree book inspector
│   │   └── main.js                 # UI counter animations & search filters
│   ├── images/
│   │   └── default-book.svg        # Local fallback vector book asset
│   ├── includes/
│   │   ├── header.jsp              # Common navigation & 3D canvas container
│   │   └── footer.jsp              # Common footer & Three.js script imports
│   ├── index.jsp                   # Landing page with 3D canvas & live stats
│   ├── login.jsp                   # Student sign in
│   ├── register.jsp                # Student registration
│   ├── dashboard.jsp               # Student dashboard & active loans
│   ├── books.jsp                   # Book catalog with search & category filters
│   ├── book-details.jsp            # Book details with 3D Book Viewer
│   ├── my-books.jsp                # Active borrowed books & return trigger
│   ├── history.jsp                 # Student loan history archive
│   ├── admin-login.jsp             # Librarian / Admin sign in
│   ├── admin-dashboard.jsp         # Admin analytics & operations console
│   ├── manage-books.jsp            # Admin CRUD books & stock inventory
│   ├── admin-students.jsp          # Admin registered student directory
│   ├── admin-issues.jsp            # Admin circulation management
│   └── WEB-INF/
│       └── web.xml                 # Jakarta EE 6.0 deployment descriptor
├── database.sql                    # Complete MySQL schema & initial seed data
├── pom.xml                         # Maven project dependencies & WAR build configuration
└── README.md                       # Comprehensive setup & architecture documentation
```

---

## 🗄️ Database Setup (MySQL 8.0)

1. Open your MySQL client (MySQL Workbench, MySQL Command Line Client, or phpMyAdmin).
2. Execute the included [`database.sql`](database.sql) script:
   ```sql
   source /path/to/database.sql;
   ```
   Or run directly via command line:
   ```bash
   mysql -u root -p < database.sql
   ```
3. This creates:
   - Database: `student_library_db`
   - Tables: `admins`, `students`, `books`, `issued_books`, `borrow_history`
   - Seed data with default admins, sample students, and 12+ academic textbooks across 8 categories.

### Configuring Database Credentials
Open [`src/main/java/com/library/util/DBConnection.java`](src/main/java/com/library/util/DBConnection.java):
```java
private static final String URL = "jdbc:mysql://localhost:3306/student_library_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8";
private static final String USER = "root";
private static final String PASSWORD = "root"; // Update to your MySQL root password
```
*(Note: If your MySQL has no password, `DBConnection.java` includes an automatic fallback to blank password `""`).*

---

## 🔑 Default Credentials

### Administrator Portal (`/admin-login`)
- **Username / Email**: `admin` or `admin@library.edu`
- **Password**: `admin123`
- *(Alternate Librarian: `librarian` / `lib2026`)*

### Sample Student Accounts (`/login`)
| Email | Password | Student ID | Department |
|---|---|---|---|
| `aarav.sharma@student.edu` | `student123` | `STU-2026-001` | Computer Science & Engineering |
| `sophia.chen@student.edu` | `student123` | `STU-2026-002` | AI & Data Science |
| `rohan.patel@student.edu` | `student123` | `STU-2026-003` | Information Technology |

*(You can also click **Register** to register your own custom student account).*

---

## 🚀 Building & Deploying to Apache Tomcat 10.1

### Step 1: Build the WAR with Maven
In the root directory of the project, run:
```bash
mvn clean package
```
This compiles the Java classes under `target/classes` and generates:
```
target/StudentLibraryManagement.war
```

### Step 2: Deploy to Apache Tomcat 10.1
> **Note**: Apache Tomcat **10.1+** is required because this project uses **Jakarta EE 10** (`jakarta.servlet.*`). Do not use Tomcat 9 or older (which used legacy `javax.servlet.*`).

#### Option A: Copying WAR to Tomcat `webapps/`
1. Copy `target/StudentLibraryManagement.war` into your Tomcat installation directory:
   ```
   <TOMCAT_HOME>/webapps/
   ```
2. Start Apache Tomcat:
   - On Windows: Run `<TOMCAT_HOME>\bin\startup.bat`
   - On Linux/macOS: Run `<TOMCAT_HOME>/bin/startup.sh`
3. Tomcat will automatically unpack the WAR and start the application.

#### Option B: Deploying via Eclipse / IntelliJ IDEA
1. Open the project as an **Existing Maven Project**.
2. Configure a new **Tomcat 10.1 Server** run configuration.
3. Add `StudentLibraryManagement` to the deployment artifacts and click **Run** or **Debug**.

---

## 🌐 Accessing the Application

Once Tomcat is running, open your web browser and navigate to:
```
http://localhost:8080/StudentLibraryManagement/
```
Or if deployed as the ROOT application:
```
http://localhost:8080/
```

---

## 🎓 Advanced Java & J2EE Concepts Demonstrated

1. **Jakarta Servlets 6.0 (`jakarta.servlet.http.HttpServlet`)**:
   - URL routing via `@WebServlet` annotations.
   - Request dispatching (`request.getRequestDispatcher().forward(request, response)`).
   - HTTP session management (`HttpSession`, session timeout, attribute binding).
   - Context path handling and HTTP method separation (`doGet` / `doPost`).
2. **JavaServer Pages (JSP 3.1 & JSTL 3.0)**:
   - Dynamic server-side page generation with expression language (`${...}`).
   - Core tag library (`<c:forEach>`, `<c:if>`, `<c:choose>`).
   - Modular page inclusion (`<jsp:include>`).
3. **JDBC PreparedStatement & ACID Transactions**:
   - Protection against SQL injection via parameterized queries.
   - Transaction control with `conn.setAutoCommit(false)`, `conn.commit()`, and `conn.rollback()` in book issue and return workflows.
   - Automatic quantity and available copies synchronization.
4. **Architectural Patterns**:
   - **MVC (Model-View-Controller)**: Separation of data models, business logic controllers, and presentation views.
   - **DAO (Data Access Object) Pattern**: Clear abstraction layer decoupling database queries from presentation controllers.
   - **Singleton / Connection Management**: Centralized resource management ensuring all statements, connections, and result sets are safely closed to prevent connection pool leaks.
5. **Modern 3D Web Graphics (Three.js)**:
   - GPU-accelerated WebGL rendering with custom shaders, procedural textures, ambient/point lighting, and raycaster mouse collision.

---

## 📜 License
Developed as an educational showcase project for Advanced Java & J2EE and Interactive Web Engineering. Free to adapt and use for academic submissions and demonstrations.

