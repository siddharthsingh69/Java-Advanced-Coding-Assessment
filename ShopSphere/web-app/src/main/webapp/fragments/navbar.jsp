<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<nav class="navbar navbar-expand-lg navbar-light bg-white border-bottom sticky-top py-3">
    <div class="container">
        <!-- Brand -->
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/home">
            <i class="bi bi-bag-check-fill fs-3 text-primary"></i>
            <span>Shop<b>Sphere</b></span>
        </a>

        <!-- Mobile Toggler -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarMain">
            <!-- Search Form -->
            <form class="d-flex mx-auto my-2 my-lg-0 col-12 col-lg-5" action="${pageContext.request.contextPath}/products" method="get">
                <div class="input-group">
                    <input class="form-control rounded-start-pill border-end-0 ps-3" type="search" name="q" placeholder="Search gadgets, fashion, books..." value="${param.q}">
                    <button class="btn btn-outline-secondary rounded-end-pill border-start-0 pe-3" type="submit">
                        <i class="bi bi-search text-primary"></i>
                    </button>
                </div>
            </form>

            <!-- Navigation Links -->
            <ul class="navbar-nav align-items-lg-center gap-2 ms-auto">
                <li class="nav-item">
                    <a class="nav-link fw-semibold" href="${pageContext.request.contextPath}/products">All Products</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link fw-semibold text-indigo" href="${pageContext.request.contextPath}/syllabus-demo">
                        <i class="bi bi-mortarboard me-1 text-primary"></i>Syllabus Demo
                    </a>
                </li>

                <!-- Language Switcher -->
                <li class="nav-item d-flex align-items-center gap-1 border rounded-pill px-2 py-1 bg-light">
                    <a href="${pageContext.request.contextPath}/language?lang=en" 
                       class="badge ${sessionScope.lang == 'hi' ? 'bg-transparent text-muted' : 'bg-primary text-white'} text-decoration-none">
                       EN
                    </a>
                    <a href="${pageContext.request.contextPath}/language?lang=hi" 
                       class="badge ${sessionScope.lang == 'hi' ? 'bg-primary text-white' : 'bg-transparent text-muted'} text-decoration-none">
                       HI
                    </a>
                </li>

                <!-- Customer / Session area -->
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <!-- Cart Icon -->
                        <li class="nav-item">
                            <a class="nav-link position-relative p-2" href="${pageContext.request.contextPath}/cart" title="Shopping Cart">
                                <i class="bi bi-cart3 fs-5"></i>
                                <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger cart-badge">
                                    ${sessionScope.cartCount != null ? sessionScope.cartCount : 0}
                                </span>
                            </a>
                        </li>

                        <!-- User Dropdown -->
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle fw-semibold d-flex align-items-center gap-1" href="#" id="userMenu" role="button" data-bs-toggle="dropdown">
                                <i class="bi bi-person-circle fs-5 text-primary"></i>
                                <span>${sessionScope.user.name}</span>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow border-0 mt-2">
                                <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/orders"><i class="bi bi-box-seam me-2 text-primary"></i>My Orders</a></li>
                                <c:if test="${sessionScope.user.admin}">
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item py-2 text-danger fw-semibold" href="${pageContext.request.contextPath}/admin/dashboard"><i class="bi bi-speedometer2 me-2"></i>Admin Dashboard</a></li>
                                </c:if>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item py-2 text-muted" href="${pageContext.request.contextPath}/logout"><i class="bi bi-box-arrow-right me-2"></i>Logout</a></li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="btn btn-outline-primary fw-semibold px-3 py-1" href="${pageContext.request.contextPath}/login.jsp">Sign In</a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-primary fw-semibold px-3 py-1" href="${pageContext.request.contextPath}/register.jsp">Register</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>

<main class="py-4">
    <div class="container">
        <!-- Global Feedback Messages -->
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle-fill me-2"></i>
                <c:choose>
                    <c:when test="${param.error == 'auth_required'}">Please log in to proceed with your request.</c:when>
                    <c:when test="${param.error == 'admin_required'}">Access denied. Administrator privileges required.</c:when>
                    <c:otherwise>${param.error}</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <c:if test="${not empty param.success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle-fill me-2"></i>
                <c:choose>
                    <c:when test="${param.success == 'registered'}">Account created successfully! Please sign in.</c:when>
                    <c:when test="${param.success == 'placed'}">Your order has been placed successfully!</c:when>
                    <c:otherwise>Action completed successfully.</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
