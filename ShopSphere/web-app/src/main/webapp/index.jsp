<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<jsp:include page="fragments/header.jsp">
    <jsp:param name="title" value="ShopSphere | Next-Gen E-Commerce"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp" />

<!-- Hero Banner -->
<div class="p-5 mb-5 rounded-4 text-white position-relative overflow-hidden shadow" 
     style="background: linear-gradient(135deg, #1e1b4b 0%, #312e81 40%, #4338ca 100%);">
    <div class="row align-items-center">
        <div class="col-lg-7 py-3">
            <span class="badge bg-primary-subtle text-primary-emphasis px-3 py-2 rounded-pill fw-semibold mb-3">
                <i class="bi bi-stars me-1"></i> RTU Advanced Java Capstone Project
            </span>
            <h1 class="display-4 fw-extrabold mb-3" style="letter-spacing: -1px;">
                Experience Modern Shopping Powered by Java
            </h1>
            <p class="lead text-light opacity-75 mb-4">
                Explore high-performance enterprise architecture: Jakarta Servlets, Custom Tags, RMI, Sockets, and Swing Administration.
            </p>
            <div class="d-flex gap-3">
                <a href="${pageContext.request.contextPath}/products" class="btn btn-light btn-lg px-4 fw-bold text-primary">
                    Shop Catalog <i class="bi bi-arrow-right ms-2"></i>
                </a>
                <a href="#categories" class="btn btn-outline-light btn-lg px-4">
                    Explore Categories
                </a>
            </div>
        </div>
        <div class="col-lg-5 d-none d-lg-block text-center">
            <i class="bi bi-bag-heart-fill display-1 text-warning opacity-75"></i>
        </div>
    </div>
</div>

<!-- Category Showcase -->
<div id="categories" class="mb-5">
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <h3 class="fw-bold mb-1">Shop by Category</h3>
            <p class="text-muted small mb-0">Select a department to view curated collections</p>
        </div>
        <a href="${pageContext.request.contextPath}/products" class="text-primary text-decoration-none fw-semibold small">
            View All <i class="bi bi-chevron-right"></i>
        </a>
    </div>

    <div class="row g-3">
        <c:forEach var="cat" items="${categories}">
            <div class="col-6 col-md-3">
                <a href="${pageContext.request.contextPath}/products?category=${cat.categoryId}" class="text-decoration-none">
                    <div class="card p-3 text-center border-0 bg-white h-100 shadow-sm hover-elevate">
                        <div class="fs-1 text-primary mb-2">
                            <c:choose>
                                <c:when test="${cat.name == 'Electronics'}"><i class="bi bi-laptop"></i></c:when>
                                <c:when test="${cat.name == 'Fashion'}"><i class="bi bi-handbag"></i></c:when>
                                <c:when test="${cat.name == 'Home & Kitchen'}"><i class="bi bi-cup-hot"></i></c:when>
                                <c:when test="${cat.name == 'Books & Stationery'}"><i class="bi bi-journal-bookmark"></i></c:when>
                                <c:otherwise><i class="bi bi-grid"></i></c:otherwise>
                            </c:choose>
                        </div>
                        <h6 class="fw-bold text-dark mb-1">${cat.name}</h6>
                        <span class="text-muted small text-truncate">${cat.description}</span>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>
</div>

<!-- Featured Products -->
<div class="mb-5">
    <div class="d-flex justify-content-between align-items-end mb-4">
        <div>
            <h3 class="fw-bold mb-1">Featured Products</h3>
            <p class="text-muted small mb-0">Handpicked top deals and trending selections</p>
        </div>
        <a href="${pageContext.request.contextPath}/products" class="text-primary text-decoration-none fw-semibold small">
            See More <i class="bi bi-chevron-right"></i>
        </a>
    </div>

    <div class="row">
        <c:forEach var="product" items="${featuredProducts}">
            <tags:productCard product="${product}" />
        </c:forEach>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
