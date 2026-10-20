<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="fragments/header.jsp">
    <jsp:param name="title" value="My Orders | ShopSphere"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp" />

<div class="mb-4">
    <h3 class="fw-bold mb-1"><i class="bi bi-box-seam text-primary me-2"></i> My Orders</h3>
    <p class="text-muted small">View your past orders, delivery status, and order invoices</p>
</div>

<c:choose>
    <c:when test="${empty orders}">
        <div class="card p-5 text-center border-0 shadow-sm rounded-4">
            <i class="bi bi-box2 display-1 text-muted opacity-50 mb-3"></i>
            <h4 class="fw-bold">No Orders Placed Yet</h4>
            <p class="text-muted small mb-4">You have not completed any purchases with us yet.</p>
            <div>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-primary px-4 py-2">Start Shopping</a>
            </div>
        </div>
    </c:when>
    <c:otherwise>
        <div class="card border-0 shadow-sm">
            <div class="table-responsive">
                <table class="table align-middle mb-0">
                    <thead class="table-light">
                        <tr class="small text-uppercase text-muted">
                            <th>Order ID</th>
                            <th>Date</th>
                            <th>Total Amount</th>
                            <th>Payment</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="o" items="${orders}">
                            <tr>
                                <td>
                                    <span class="fw-bold text-dark">#ORD-${o.orderId}</span>
                                </td>
                                <td class="small text-muted">
                                    <fmt:formatDate value="${o.createdAt}" pattern="dd MMM yyyy, hh:mm a"/>
                                </td>
                                <td>
                                    <span class="fw-bold text-dark">₹<fmt:formatNumber value="${o.finalPayable}" maxFractionDigits="2" minFractionDigits="2"/></span>
                                </td>
                                <td>
                                    <span class="badge bg-light text-dark border">${o.paymentMethod}</span>
                                    <c:choose>
                                        <c:when test="${o.paymentStatus == 'COMPLETED'}">
                                            <span class="badge bg-success-subtle text-success">Paid</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning-subtle text-warning-emphasis">Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${o.orderStatus == 'DELIVERED'}">
                                            <span class="badge bg-success">Delivered</span>
                                        </c:when>
                                        <c:when test="${o.orderStatus == 'SHIPPED'}">
                                            <span class="badge bg-info text-dark">Shipped</span>
                                        </c:when>
                                        <c:when test="${o.orderStatus == 'PROCESSING'}">
                                            <span class="badge bg-primary">Processing</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/order-details?id=${o.orderId}" class="btn btn-outline-primary btn-sm">
                                        View Details
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:otherwise>
</c:choose>

<jsp:include page="fragments/footer.jsp" />
