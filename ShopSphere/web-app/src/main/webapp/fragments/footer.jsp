<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    </div>
</main>

<footer class="bg-white border-top py-5 mt-auto">
    <div class="container">
        <div class="row g-4">
            <div class="col-12 col-md-4">
                <h5 class="fw-bold text-primary mb-3"><i class="bi bi-bag-check-fill me-2"></i>ShopSphere</h5>
                <p class="text-muted small">
                    An advanced enterprise Java e-commerce system demonstrating Jakarta EE, Servlets, JSP, JSTL, JDBC, RMI, Java Sockets, and Swing.
                </p>
            </div>
            <div class="col-6 col-md-2">
                <h6 class="fw-bold mb-3">Shop</h6>
                <ul class="list-unstyled small text-muted">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/products" class="text-decoration-none text-muted">All Products</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/products?category=1" class="text-decoration-none text-muted">Electronics</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/products?category=2" class="text-decoration-none text-muted">Fashion</a></li>
                </ul>
            </div>
            <div class="col-6 col-md-2">
                <h6 class="fw-bold mb-3">Account</h6>
                <ul class="list-unstyled small text-muted">
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/login.jsp" class="text-decoration-none text-muted">Sign In</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/orders" class="text-decoration-none text-muted">Orders</a></li>
                    <li class="mb-2"><a href="${pageContext.request.contextPath}/cart" class="text-decoration-none text-muted">Cart</a></li>
                </ul>
            </div>
            <div class="col-12 col-md-4">
                <h6 class="fw-bold mb-3">Academic Project</h6>
                <p class="text-muted small">
                    RTU Advanced Java Capstone Project.<br>
                    <strong>Tech:</strong> Tomcat 11, JDK 21, MySQL 8, Jakarta EE 10.
                </p>
                <div class="d-flex gap-3 text-secondary fs-5">
                    <i class="bi bi-shield-check" title="Secure PreparedStatement JDBC"></i>
                    <i class="bi bi-cpu" title="Multi-threaded RMI & Sockets"></i>
                    <i class="bi bi-window" title="Java Swing Desktop Module"></i>
                </div>
            </div>
        </div>
        <hr class="my-4 text-muted">
        <div class="d-flex flex-wrap justify-content-between align-items-center small text-muted">
            <span>&copy; <%= java.time.Year.now() %> ShopSphere. All rights reserved.</span>
            <span>Developed for RTU Advanced Java Practical Examination.</span>
        </div>
    </div>
</footer>

<!-- Bootstrap 5 Bundle JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
