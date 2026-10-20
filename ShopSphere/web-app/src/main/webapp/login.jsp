<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="fragments/header.jsp">
    <jsp:param name="title" value="Sign In | ShopSphere"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp" />

<div class="row justify-content-center my-5">
    <div class="col-md-6 col-lg-5">
        <div class="card border-0 shadow-sm p-4 p-md-5">
            <div class="text-center mb-4">
                <i class="bi bi-shield-lock-fill text-primary display-4"></i>
                <h3 class="fw-bold mt-2">Welcome Back</h3>
                <p class="text-muted small">Sign in to manage your cart, orders, and wishlist</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger py-2 small" role="alert">
                    <i class="bi bi-exclamation-circle me-1"></i> ${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">
                <input type="hidden" name="redirect" value="${param.redirect}">

                <div class="mb-3">
                    <label class="form-label small fw-semibold">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                        <input type="email" id="emailInput" name="email" class="form-control" placeholder="name@example.com" value="${email != null ? email : ''}" required>
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label small fw-semibold">Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                        <input type="password" id="passwordInput" name="password" class="form-control" placeholder="••••••••" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                    Sign In <i class="bi bi-box-arrow-in-right ms-1"></i>
                </button>
            </form>

            <!-- Quick Demo Credentials for Viva / Testing -->
            <div class="mt-4 pt-3 border-top">
                <span class="small text-muted d-block text-center mb-2">Quick Viva / Demo Credentials:</span>
                <div class="d-flex gap-2">
                    <button type="button" class="btn btn-outline-secondary btn-sm w-50" onclick="fillCreds('siddharth@example.com', 'customer123')">
                        <i class="bi bi-person me-1"></i> Customer
                    </button>
                    <button type="button" class="btn btn-outline-danger btn-sm w-50" onclick="fillCreds('admin@shopsphere.com', 'admin123')">
                        <i class="bi bi-person-gear me-1"></i> Admin
                    </button>
                </div>
            </div>

            <div class="text-center mt-4">
                <span class="text-muted small">Don't have an account?</span>
                <a href="${pageContext.request.contextPath}/register.jsp" class="text-primary fw-semibold small text-decoration-none ms-1">Create Account</a>
            </div>
        </div>
    </div>
</div>

<script>
function fillCreds(email, pass) {
    document.getElementById('emailInput').value = email;
    document.getElementById('passwordInput').value = pass;
}
</script>

<jsp:include page="fragments/footer.jsp" />
