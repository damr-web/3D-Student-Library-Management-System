<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    <!-- Futuristic Footer -->
    <footer class="footer-futuristic mt-auto">
        <div class="container">
            <div class="row align-items-center g-3">
                <div class="col-md-6 text-center text-md-start">
                    <div class="d-flex align-items-center justify-content-center justify-content-md-start gap-2 mb-1">
                        <i class="fa-solid fa-cube text-cyan" style="color: var(--primary-cyan);"></i>
                        <span class="fw-bold text-white">STUDENT LIBRARY MANAGEMENT SYSTEM</span>
                    </div>
                    <p class="text-secondary small mb-0">Explore. Read. Learn. Grow. &mdash; Powered by Advanced Java, Servlets, JSP & Three.js</p>
                </div>
                <div class="col-md-6 text-center text-md-end">
                    <div class="d-flex justify-content-center justify-content-md-end gap-3 mb-2">
                        <a href="${pageContext.request.contextPath}/books" class="text-secondary text-decoration-none small hover-cyan">Catalog</a>
                        <span class="text-muted">&bull;</span>
                        <a href="${pageContext.request.contextPath}/login" class="text-secondary text-decoration-none small hover-cyan">Student Portal</a>
                        <span class="text-muted">&bull;</span>
                        <a href="${pageContext.request.contextPath}/admin-login" class="text-secondary text-decoration-none small hover-cyan">Admin Console</a>
                    </div>
                    <span class="badge bg-dark border border-secondary text-secondary small">
                        <i class="fa-solid fa-code"></i> Java 17 &bull; Jakarta EE &bull; MySQL 8.0 &bull; Apache Tomcat 10.1
                    </span>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap 5 JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Main UI Interactivity -->
    <script src="${pageContext.request.contextPath}/js/main.js"></script>

    <!-- 3D Three.js Interactive Scene -->
    <script src="${pageContext.request.contextPath}/js/three-scene.js"></script>
</body>
</html>

