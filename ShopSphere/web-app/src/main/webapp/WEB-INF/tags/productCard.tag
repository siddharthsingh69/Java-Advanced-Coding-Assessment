<%@ tag language="java" pageEncoding="UTF-8" %>
<%@ attribute name="product" required="true" type="com.shopsphere.model.Product" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="col-12 col-sm-6 col-md-4 col-lg-3 mb-4">
    <div class="card h-100 product-card">
        <!-- Image Area -->
        <div class="product-img-wrapper position-relative">
            <a href="${pageContext.request.contextPath}/product?id=${product.productId}">
                <img src="${product.imageUrl != null ? product.imageUrl : 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=500'}" alt="${product.name}" loading="lazy">
            </a>
            <c:if test="${product.discount > 0}">
                <span class="position-absolute top-0 start-0 m-2 badge badge-discount">
                    ${product.discount}% OFF
                </span>
            </c:if>
            <c:if test="${!product.inStock}">
                <span class="position-absolute top-0 end-0 m-2 badge bg-secondary">Out of Stock</span>
            </c:if>
        </div>

        <!-- Body -->
        <div class="card-body d-flex flex-column p-3">
            <div class="text-muted small mb-1">${product.brand != null ? product.brand : 'ShopSphere'}</div>
            <h6 class="card-title fw-bold mb-2 text-truncate" title="${product.name}">
                <a href="${pageContext.request.contextPath}/product?id=${product.productId}" class="text-decoration-none text-dark">
                    ${product.name}
                </a>
            </h6>

            <!-- Pricing -->
            <div class="mt-auto pt-2">
                <div class="d-flex align-items-baseline gap-2 mb-3">
                    <span class="fs-5 fw-bold text-dark">₹<fmt:formatNumber value="${product.finalPrice}" maxFractionDigits="2" minFractionDigits="2"/></span>
                    <c:if test="${product.discount > 0}">
                        <span class="text-muted text-decoration-line-through small">₹<fmt:formatNumber value="${product.price}" maxFractionDigits="2" minFractionDigits="2"/></span>
                    </c:if>
                </div>

                <!-- Add to cart -->
                <c:choose>
                    <c:when test="${product.inStock}">
                        <form action="${pageContext.request.contextPath}/cart" method="post" class="m-0">
                            <input type="hidden" name="action" value="add">
                            <input type="hidden" name="productId" value="${product.productId}">
                            <input type="hidden" name="quantity" value="1">
                            <button type="submit" class="btn btn-primary w-100 btn-sm d-flex align-items-center justify-content-center gap-2">
                                <i class="bi bi-cart-plus"></i> Add to Cart
                            </button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <button class="btn btn-light text-muted w-100 btn-sm" disabled>Unavailable</button>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</div>
