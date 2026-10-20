<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<jsp:include page="fragments/header.jsp">
    <jsp:param name="title" value="Create Account | ShopSphere"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp" />

<div class="row justify-content-center my-5">
    <div class="col-md-6 col-lg-5">
        <div class="card border-0 shadow-sm p-4 p-md-5">
            <div class="text-center mb-4">
                <i class="bi bi-person-plus-fill text-primary display-4"></i>
                <h3 class="fw-bold mt-2">Create Account</h3>
                <p class="text-muted small">Join ShopSphere to discover amazing products and deals</p>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger py-2 small" role="alert">
                    <i class="bi bi-exclamation-circle me-1"></i> ${errorMessage}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/register" method="post">
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Full Name</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-person"></i></span>
                        <input type="text" name="name" class="form-control" placeholder="Saumitra Matta" value="${name != null ? name : ''}" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold">Email Address</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-envelope"></i></span>
                        <input type="email" name="email" class="form-control" placeholder="saumitra@example.com" value="${email != null ? email : ''}" required>
                    </div>
                </div>

                <div class="mb-3">
                    <label class="form-label small fw-semibold">Mobile Number</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-telephone"></i></span>
                        <input type="tel" name="mobile" class="form-control" placeholder="9876543210" value="${mobile != null ? mobile : ''}">
                    </div>
                </div>

                <div class="mb-4">
                    <label class="form-label small fw-semibold">Password</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light"><i class="bi bi-lock"></i></span>
                        <input type="password" name="password" class="form-control" placeholder="Minimum 6 characters" minlength="6" required>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                    Register Now <i class="bi bi-arrow-right ms-1"></i>
                </button>
            </form>

            <div class="text-center mt-4">
                <span class="text-muted small">Already have an account?</span>
                <a href="${pageContext.request.contextPath}/login.jsp" class="text-primary fw-semibold small text-decoration-none ms-1">Sign In</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
