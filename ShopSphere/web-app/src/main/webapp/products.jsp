<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<jsp:include page="fragments/header.jsp">
    <jsp:param name="title" value="ShopSphere | Products Catalog"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp" />

<div class="row g-4">
    <!-- Left Filter Sidebar -->
    <div class="col-lg-3">
        <div class="card p-3 bg-white border-0 shadow-sm sticky-top" style="top: 90px;">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold mb-0"><i class="bi bi-funnel me-1 text-primary"></i> Filters</h5>
                <a href="${pageContext.request.contextPath}/products" class="text-decoration-none small text-muted">Clear All</a>
            </div>

            <form action="${pageContext.request.contextPath}/products" method="get">
                <input type="hidden" name="q" value="${searchQuery}">

                <!-- Category list -->
                <div class="mb-4">
                    <label class="form-label fw-semibold small text-uppercase text-muted">Categories</label>
                    <div class="list-group list-group-flush small">
                        <a href="${pageContext.request.contextPath}/products?q=${searchQuery}&sort=${selectedSort}" 
                           class="list-group-item list-group-item-action ${empty selectedCategory ? 'active fw-bold' : ''}">
                            All Departments
                        </a>
                        <c:forEach var="cat" items="${categories}">
                            <a href="${pageContext.request.contextPath}/products?category=${cat.categoryId}&q=${searchQuery}&sort=${selectedSort}" 
                               class="list-group-item list-group-item-action ${selectedCategory == cat.categoryId ? 'active fw-bold' : ''}">
                                ${cat.name}
                            </a>
                        </c:forEach>
                    </div>
                </div>

                <!-- Sort Order -->
                <div class="mb-3">
                    <label class="form-label fw-semibold small text-uppercase text-muted">Sort By</label>
                    <c:if test="${not empty selectedCategory}">
                        <input type="hidden" name="category" value="${selectedCategory}">
                    </c:if>
                    <select name="sort" class="form-select form-select-sm" onchange="this.form.submit()">
                        <option value="newest" ${selectedSort == 'newest' ? 'selected' : ''}>Newest Arrivals</option>
                        <option value="price_asc" ${selectedSort == 'price_asc' ? 'selected' : ''}>Price: Low to High</option>
                        <option value="price_desc" ${selectedSort == 'price_desc' ? 'selected' : ''}>Price: High to Low</option>
                        <option value="name_asc" ${selectedSort == 'name_asc' ? 'selected' : ''}>Name: A to Z</option>
                    </select>
                </div>
            </form>
        </div>
    </div>

    <!-- Main Products Area -->
    <div class="col-lg-9">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <div>
                <h4 class="fw-bold mb-1">
                    <c:choose>
                        <c:when test="${not empty searchQuery}">Search results for "${searchQuery}"</c:when>
                        <c:otherwise>All Products</c:otherwise>
                    </c:choose>
                </h4>
                <p class="text-muted small mb-0">Showing ${products.size()} available items</p>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty products}">
                <div class="text-center py-5 bg-white rounded-4 shadow-sm">
                    <i class="bi bi-search display-1 text-muted opacity-50 mb-3"></i>
                    <h5 class="fw-bold">No Products Found</h5>
                    <p class="text-muted small mb-3">Try adjusting your category or search query.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary btn-sm">Reset Filters</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach var="p" items="${products}">
                        <tags:productCard product="${p}" />
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
