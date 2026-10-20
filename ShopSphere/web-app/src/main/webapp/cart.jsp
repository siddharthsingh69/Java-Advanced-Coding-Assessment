<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="fragments/header.jsp">
    <jsp:param name="title" value="Shopping Cart | ShopSphere"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <h3 class="fw-bold mb-0"><i class="bi bi-cart3 text-primary me-2"></i> Shopping Cart</h3>
    <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-primary btn-sm">
        <i class="bi bi-arrow-left me-1"></i> Continue Shopping
    </a>
</div>

<c:choose>
    <c:when test="${empty cartItems}">
        <div class="card p-5 text-center border-0 shadow-sm rounded-4">
            <i class="bi bi-cart-x display-1 text-muted opacity-50 mb-3"></i>
            <h4 class="fw-bold">Your Cart is Empty</h4>
            <p class="text-muted small mb-4">Looks like you haven't added anything to your cart yet.</p>
            <div>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary px-4 py-2">Discover Products</a>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="row g-4">
            <!-- Items Table -->
            <div class="col-lg-8">
                <div class="card border-0 shadow-sm p-3">
                    <div class="table-responsive">
                        <table class="table align-middle mb-0">
                            <thead class="table-light">
                                <tr class="small text-uppercase text-muted">
                                    <th>Product</th>
                                    <th>Price</th>
                                    <th style="width: 140px;">Quantity</th>
                                    <th>Total</th>
                                    <th></th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${cartItems}">
                                    <tr>
                                        <td>
                                            <div class="d-flex align-items-center gap-3">
                                                <img src="${item.product.imageUrl != null ? item.product.imageUrl : 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=200'}" 
                                                     alt="${item.product.name}" class="rounded-3 object-fit-cover" width="60" height="60">
                                                <div>
                                                    <h6 class="fw-bold mb-0">
                                                        <a href="${pageContext.request.contextPath}/product?id=${item.productId}" class="text-decoration-none text-dark">
                                                            ${item.product.name}
                                                        </a>
                                                    </h6>
                                                    <span class="text-muted small">${item.product.brand}</span>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="fw-semibold">₹<fmt:formatNumber value="${item.product.finalPrice}" maxFractionDigits="2" minFractionDigits="2"/></span>
                                        </td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/cart" method="post" class="d-flex align-items-center gap-1 m-0">
                                                <input type="hidden" name="action" value="update">
                                                <input type="hidden" name="cartId" value="${item.cartId}">
                                                <input type="number" name="quantity" value="${item.quantity}" min="1" max="${item.product.stock}" 
                                                       class="form-control form-control-sm text-center" style="width: 70px;">
                                                <button type="submit" class="btn btn-light btn-sm border" title="Update Quantity">
                                                    <i class="bi bi-arrow-repeat"></i>
                                                </button>
                                            </form>
                                        </td>
                                        <td>
                                            <span class="fw-bold text-primary">₹<fmt:formatNumber value="${item.subtotal}" maxFractionDigits="2" minFractionDigits="2"/></span>
                                        </td>
                                        <td>
                                            <form action="${pageContext.request.contextPath}/cart" method="post" class="m-0">
                                                <input type="hidden" name="action" value="remove">
                                                <input type="hidden" name="cartId" value="${item.cartId}">
                                                <button type="submit" class="btn btn-outline-danger btn-sm border-0" title="Remove item">
                                                    <i class="bi bi-trash3"></i>
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Summary Card -->
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm p-4">
                    <h5 class="fw-bold mb-3">Order Summary</h5>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Subtotal (${cartItems.size()} items)</span>
                        <span class="fw-semibold">₹<fmt:formatNumber value="${cartTotal}" maxFractionDigits="2" minFractionDigits="2"/></span>
                    </div>
                    <div class="d-flex justify-content-between mb-3">
                        <span class="text-muted">Delivery</span>
                        <span class="text-success fw-semibold">FREE</span>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between align-items-baseline mb-4">
                        <span class="fs-5 fw-bold">Estimated Total</span>
                        <span class="fs-4 fw-bold text-primary">₹<fmt:formatNumber value="${cartTotal}" maxFractionDigits="2" minFractionDigits="2"/></span>
                    </div>

                    <a href="${pageContext.request.contextPath}/checkout" class="btn btn-primary w-100 py-2 fw-semibold d-flex align-items-center justify-content-center gap-2">
                        Proceed to Checkout <i class="bi bi-arrow-right"></i>
                    </a>
                </div>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="fragments/footer.jsp" />
