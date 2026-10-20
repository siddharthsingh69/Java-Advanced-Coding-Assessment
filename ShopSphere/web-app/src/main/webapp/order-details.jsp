<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="fragments/header.jsp">
    <jsp:param name="title" value="Order #ORD-${order.orderId} Details | ShopSphere"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp" />

<nav aria-label="breadcrumb" class="mb-4">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/orders" class="text-decoration-none">My Orders</a></li>
        <li class="breadcrumb-item active">Order #ORD-${order.orderId}</li>
    </ol>
</nav>

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-1">Order #ORD-${order.orderId}</h3>
        <p class="text-muted small mb-0">Placed on <fmt:formatDate value="${order.createdAt}" pattern="dd MMMM yyyy, hh:mm a"/></p>
    </div>
    <span class="badge bg-primary fs-6 px-3 py-2">${order.orderStatus}</span>
</div>

<div class="row g-4 mb-5">
    <div class="col-lg-8">
        <!-- Order Items -->
        <div class="card border-0 shadow-sm p-4 mb-4">
            <h5 class="fw-bold mb-3">Items in This Order</h5>
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="table-light">
                        <tr class="small text-uppercase text-muted">
                            <th>Item</th>
                            <th>Unit Price</th>
                            <th>Qty</th>
                            <th class="text-end">Total</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${order.items}">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center gap-3">
                                        <img src="${item.product.imageUrl != null ? item.product.imageUrl : 'https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=200'}" 
                                             alt="${item.product.name}" class="rounded-3 object-fit-cover" width="50" height="50">
                                        <div>
                                            <h6 class="fw-bold mb-0">${item.product.name}</h6>
                                            <span class="text-muted small">${item.product.brand}</span>
                                        </div>
                                    </div>
                                </td>
                                <td>₹<fmt:formatNumber value="${item.price}" maxFractionDigits="2" minFractionDigits="2"/></td>
                                <td>${item.quantity}</td>
                                <td class="text-end fw-bold">₹<fmt:formatNumber value="${item.subtotal}" maxFractionDigits="2" minFractionDigits="2"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Order Timeline -->
        <div class="card border-0 shadow-sm p-4">
            <h5 class="fw-bold mb-3">Delivery Tracking</h5>
            <div class="d-flex justify-content-between text-center position-relative my-3">
                <div class="d-flex flex-column align-items-center">
                    <div class="btn btn-primary rounded-circle mb-2" style="width: 40px; height: 40px; padding: 6px;">
                        <i class="bi bi-check-lg"></i>
                    </div>
                    <span class="small fw-semibold">Order Placed</span>
                </div>
                <div class="d-flex flex-column align-items-center">
                    <div class="btn ${order.orderStatus == 'PROCESSING' || order.orderStatus == 'SHIPPED' || order.orderStatus == 'DELIVERED' ? 'btn-primary' : 'btn-light border'} rounded-circle mb-2" style="width: 40px; height: 40px; padding: 6px;">
                        <i class="bi bi-box-seam"></i>
                    </div>
                    <span class="small fw-semibold">Processing</span>
                </div>
                <div class="d-flex flex-column align-items-center">
                    <div class="btn ${order.orderStatus == 'SHIPPED' || order.orderStatus == 'DELIVERED' ? 'btn-primary' : 'btn-light border'} rounded-circle mb-2" style="width: 40px; height: 40px; padding: 6px;">
                        <i class="bi bi-truck"></i>
                    </div>
                    <span class="small fw-semibold">Shipped</span>
                </div>
                <div class="d-flex flex-column align-items-center">
                    <div class="btn ${order.orderStatus == 'DELIVERED' ? 'btn-success' : 'btn-light border'} rounded-circle mb-2" style="width: 40px; height: 40px; padding: 6px;">
                        <i class="bi bi-house-check"></i>
                    </div>
                    <span class="small fw-semibold">Delivered</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Right Side Details -->
    <div class="col-lg-4">
        <!-- Delivery Address -->
        <div class="card border-0 shadow-sm p-4 mb-4">
            <h5 class="fw-bold mb-3"><i class="bi bi-geo-alt text-primary me-2"></i>Delivery Address</h5>
            <c:choose>
                <c:when test="${not empty order.address}">
                    <p class="mb-1 fw-bold text-dark">${order.customerName}</p>
                    <p class="text-secondary small mb-1">${order.address.addressLine}</p>
                    <p class="text-secondary small mb-0">${order.address.city}, ${order.address.state} - ${order.address.pincode}</p>
                    <span class="badge bg-light text-dark border mt-2">${order.address.addressType}</span>
                </c:when>
                <c:otherwise>
                    <p class="text-muted small mb-0">Standard address on file.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Payment and Total -->
        <div class="card border-0 shadow-sm p-4">
            <h5 class="fw-bold mb-3">Payment Summary</h5>
            <div class="d-flex justify-content-between mb-2">
                <span class="text-muted">Payment Method</span>
                <span class="fw-semibold">${order.paymentMethod}</span>
            </div>
            <div class="d-flex justify-content-between mb-2">
                <span class="text-muted">Payment Status</span>
                <span class="fw-semibold text-success">${order.paymentStatus}</span>
            </div>
            <div class="d-flex justify-content-between mb-2">
                <span class="text-muted">Items Subtotal</span>
                <span class="fw-semibold">₹<fmt:formatNumber value="${order.totalAmount}" maxFractionDigits="2"/></span>
            </div>
            <c:if test="${order.discount > 0}">
                <div class="d-flex justify-content-between mb-2 text-success">
                    <span>Discount</span>
                    <span>- ₹<fmt:formatNumber value="${order.discount}" maxFractionDigits="2"/></span>
                </div>
            </c:if>
            <div class="d-flex justify-content-between mb-3">
                <span class="text-muted">Shipping</span>
                <span class="text-success fw-semibold">FREE</span>
            </div>
            <hr>
            <div class="d-flex justify-content-between align-items-baseline">
                <span class="fs-5 fw-bold">Total Paid</span>
                <span class="fs-4 fw-bold text-primary">₹<fmt:formatNumber value="${order.finalPayable}" maxFractionDigits="2"/></span>
            </div>
        </div>
    </div>
</div>

<jsp:include page="fragments/footer.jsp" />
