<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>

<jsp:include page="fragments/header.jsp">
    <jsp:param name="title" value="${product.name} | ShopSphere"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp" />

<nav aria-label="breadcrumb" class="mb-4">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-decoration-none">Home</a></li>
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products" class="text-decoration-none">Products</a></li>
        <li class="breadcrumb-item active" aria-current="page">${product.name}</li>
    </ol>
</nav>

<div class="card border-0 shadow-sm p-4 mb-5">
    <div class="row g-5">
        <!-- Product Image -->
        <div class="col-md-5">
            <div class="rounded-4 overflow-hidden border bg-light text-center" style="max-height: 420px;">
                <img src="${product.imageUrl != null ? product.imageUrl : 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=600'}" 
                     alt="${product.name}" class="img-fluid object-fit-cover w-100" style="max-height: 420px;">
            </div>
        </div>

        <!-- Product Summary -->
        <div class="col-md-7 d-flex flex-column">
            <div class="text-muted text-uppercase fw-semibold small mb-1">${product.brand} &bull; ${product.categoryName}</div>
            <h2 class="fw-bold mb-3">${product.name}</h2>

            <!-- Pricing -->
            <div class="d-flex align-items-baseline gap-3 mb-3">
                <span class="display-6 fw-bold text-primary">₹<fmt:formatNumber value="${product.finalPrice}" maxFractionDigits="2" minFractionDigits="2"/></span>
                <c:if test="${product.discount > 0}">
                    <span class="fs-5 text-muted text-decoration-line-through">₹<fmt:formatNumber value="${product.price}" maxFractionDigits="2" minFractionDigits="2"/></span>
                    <span class="badge badge-discount fs-6">${product.discount}% OFF</span>
                </c:if>
            </div>

            <!-- Stock status -->
            <div class="mb-4">
                <c:choose>
                    <c:when test="${product.inStock}">
                        <span class="badge bg-success-subtle text-success border border-success-subtle px-3 py-2 rounded-pill fw-semibold">
                            <i class="bi bi-check2-circle me-1"></i> In Stock (${product.stock} units available)
                        </span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-danger-subtle text-danger border border-danger-subtle px-3 py-2 rounded-pill fw-semibold">
                            <i class="bi bi-x-circle me-1"></i> Currently Out of Stock
                        </span>
                    </c:otherwise>
                </c:choose>
            </div>

            <p class="text-secondary mb-4 leading-relaxed">${product.description}</p>

            <!-- Add to Cart Form -->
            <div class="mt-auto pt-3 border-top">
                <c:choose>
                    <c:when test="${product.inStock}">
                        <form action="${pageContext.request.contextPath}/cart" method="post" class="row g-3 align-items-center">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.productId}">
                            <div class="col-auto">
                                <label for="quantitySelect" class="form-label mb-0 fw-semibold">Quantity:</label>
                            </div>
                            <div class="col-auto">
                                <select name="quantity" id="quantitySelect" class="form-select form-select-sm" style="width: 80px;">
                                    <c:forEach begin="1" end="${product.stock > 5 ? 5 : product.stock}" var="q">
                                        <option value="${q}">${q}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col">
                                <button type="submit" class="btn btn-primary px-4 py-2 d-flex align-items-center justify-content-center gap-2">
                                    <i class="bi bi-cart-plus-fill fs-5"></i> Add to Cart
                                </button>
                            </div>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-secondary px-4 py-2" disabled>Out of Stock</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>

<!-- Customer Reviews Section -->
<div class="row g-4 mb-5">
    <div class="col-lg-7">
        <h4 class="fw-bold mb-4">Customer Reviews (${reviews.size()})</h4>
        <c:choose>
            <c:when test="${empty reviews}">
                <div class="card p-4 border-0 shadow-sm text-center text-muted">
                    <p class="mb-0">No reviews yet for this product. Be the first to share your thoughts!</p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="d-flex flex-column gap-3">
                    <c:forEach var="rev" items="${reviews}">
                        <div class="card p-3 border-0 shadow-sm">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="fw-bold text-dark"><i class="bi bi-person-circle me-1 text-primary"></i> ${rev.userName}</span>
                                <tags:rating score="${rev.rating}" />
                            </div>
                            <p class="text-secondary small mb-1">${rev.reviewText}</p>
                            <span class="text-muted" style="font-size: 0.75rem;"><fmt:formatDate value="${rev.createdAt}" pattern="dd MMM yyyy, hh:mm a"/></span>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Submit Review Form -->
    <div class="col-lg-5">
        <div class="card p-4 border-0 shadow-sm">
            <h5 class="fw-bold mb-3">Write a Review</h5>
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <form action="${pageContext.request.contextPath}/product" method="post">
                        <input type="hidden" name="productId" value="${product.productId}">
                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Rating</label>
                            <select name="rating" class="form-select" required>
                                <option value="5">★★★★★ - Excellent (5/5)</option>
                                <option value="4">★★★★☆ - Very Good (4/5)</option>
                                <option value="3">★★★☆☆ - Average (3/5)</option>
                                <option value="2">★★☆☆☆ - Poor (2/5)</option>
                                <option value="1">★☆☆☆☆ - Terrible (1/5)</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-semibold small">Your Experience</label>
                            <textarea name="reviewText" rows="3" class="form-control" placeholder="What did you like or dislike about this product?" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary btn-sm w-100">Submit Review</button>
                    </form>
                </c:when>
                <c:otherwise>
                    <p class="text-muted small">Please <a href="${pageContext.request.contextPath}/login.jsp" class="text-primary fw-semibold">sign in</a> to leave a review.</p>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
