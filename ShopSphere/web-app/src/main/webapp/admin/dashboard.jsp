<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../fragments/header.jsp">
    <jsp:param name="title" value="Admin Dashboard | ShopSphere"/>
</jsp:include>
<jsp:include page="../fragments/navbar.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-1"><i class="bi bi-speedometer2 text-primary me-2"></i> Admin Dashboard</h3>
        <p class="text-muted small mb-0">Overview of store activity, product inventory, and customer orders</p>
    </div>
    <div class="d-flex gap-2">
        <a href="${pageContext.request.contextPath}/admin/products" class="btn btn-primary btn-sm">
            <i class="bi bi-box-seam me-1"></i> Manage Products
        </a>
        <a href="${pageContext.request.contextPath}/admin/orders" class="btn btn-outline-primary btn-sm">
            <i class="bi bi-receipt me-1"></i> View Orders
        </a>
    </div>
</div>

<!-- KPI Cards -->
<div class="row g-3 mb-4">
    <div class="col-sm-6 col-lg-3">
        <div class="card p-3 border-0 shadow-sm bg-white">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <span class="text-muted small text-uppercase fw-semibold">Total Revenue</span>
                    <h3 class="fw-bold text-dark mt-1 mb-0">₹<fmt:formatNumber value="${totalRevenue}" maxFractionDigits="2" minFractionDigits="2"/></h3>
                </div>
                <div class="p-3 bg-primary-subtle text-primary rounded-3 fs-3">
                    <i class="bi bi-currency-rupee"></i>
                </div>
            </div>
        </div>
    </div>

    <div class="col-sm-6 col-lg-3">
        <div class="card p-3 border-0 shadow-sm bg-white">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <span class="text-muted small text-uppercase fw-semibold">Total Orders</span>
                    <h3 class="fw-bold text-dark mt-1 mb-0">${totalOrders}</h3>
                </div>
                <div class="p-3 bg-info-subtle text-info rounded-3 fs-3">
                    <i class="bi bi-cart-check"></i>
                </div>
            </div>
        </div>
    </div>

    <div class="col-sm-6 col-lg-3">
        <div class="card p-3 border-0 shadow-sm bg-white">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <span class="text-muted small text-uppercase fw-semibold">Products</span>
                    <h3 class="fw-bold text-dark mt-1 mb-0">${totalProducts}</h3>
                </div>
                <div class="p-3 bg-success-subtle text-success rounded-3 fs-3">
                    <i class="bi bi-box"></i>
                </div>
            </div>
        </div>
    </div>

    <div class="col-sm-6 col-lg-3">
        <div class="card p-3 border-0 shadow-sm bg-white">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <span class="text-muted small text-uppercase fw-semibold">Low Stock Items</span>
                    <h3 class="fw-bold text-danger mt-1 mb-0">${lowStockCount}</h3>
                </div>
                <div class="p-3 bg-danger-subtle text-danger rounded-3 fs-3">
                    <i class="bi bi-exclamation-triangle"></i>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- Recent Orders Table -->
<div class="card border-0 shadow-sm p-4 mb-4">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="fw-bold mb-0">Recent Customer Orders</h5>
        <a href="${pageContext.request.contextPath}/admin/orders" class="small text-primary text-decoration-none">View All Orders</a>
    </div>

    <div class="table-responsive">
        <table class="table align-middle mb-0">
            <thead class="table-light">
                <tr class="small text-uppercase text-muted">
                    <th>Order</th>
                    <th>Customer</th>
                    <th>Total</th>
                    <th>Payment</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="o" items="${recentOrders}">
                    <tr>
                        <td class="fw-bold text-dark">#ORD-${o.orderId}</td>
                        <td>
                            <div class="fw-semibold">${o.customerName}</div>
                            <span class="text-muted small">${o.customerEmail}</span>
                        </td>
                        <td class="fw-bold">₹<fmt:formatNumber value="${o.finalPayable}" maxFractionDigits="2"/></td>
                        <td>
                            <span class="badge bg-light text-dark border">${o.paymentMethod}</span>
                        </td>
                        <td>
                            <span class="badge bg-primary">${o.orderStatus}</span>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/order-details?id=${o.orderId}" class="btn btn-outline-primary btn-sm">Inspect</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../fragments/footer.jsp" />
