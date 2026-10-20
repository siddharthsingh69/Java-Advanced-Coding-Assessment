<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../fragments/header.jsp">
    <jsp:param name="title" value="Manage Orders | ShopSphere Admin"/>
</jsp:include>
<jsp:include page="../fragments/navbar.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-1"><i class="bi bi-receipt text-primary me-2"></i> Customer Orders</h3>
        <p class="text-muted small mb-0">Track payments, shipping, and update order statuses</p>
    </div>
</div>

<div class="card border-0 shadow-sm p-4">
    <div class="table-responsive">
        <table class="table align-middle mb-0">
            <thead class="table-light">
                <tr class="small text-uppercase text-muted">
                    <th>Order</th>
                    <th>Date</th>
                    <th>Customer</th>
                    <th>Amount</th>
                    <th>Payment</th>
                    <th>Status</th>
                    <th>Update Status</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="o" items="${orders}">
                    <tr>
                        <td class="fw-bold">
                            <a href="${pageContext.request.contextPath}/order-details?id=${o.orderId}" class="text-decoration-none">
                                #ORD-${o.orderId}
                            </a>
                        </td>
                        <td class="small text-muted"><fmt:formatDate value="${o.createdAt}" pattern="dd MMM yyyy, hh:mm a"/></td>
                        <td>
                            <div class="fw-semibold">${o.customerName}</div>
                            <span class="text-muted small">${o.customerEmail}</span>
                        </td>
                        <td class="fw-bold">₹<fmt:formatNumber value="${o.finalPayable}" maxFractionDigits="2"/></td>
                        <td>
                            <span class="badge bg-light text-dark border">${o.paymentMethod}</span>
                            <span class="badge ${o.paymentStatus == 'COMPLETED' ? 'bg-success' : 'bg-warning text-dark'}">${o.paymentStatus}</span>
                        </td>
                        <td>
                            <span class="badge bg-primary">${o.orderStatus}</span>
                        </td>
                        <td>
                            <form action="${pageContext.request.contextPath}/admin/orders" method="post" class="d-flex gap-1 m-0">
                                <input type="hidden" name="action" value="updateOrderStatus">
                                <input type="hidden" name="orderId" value="${o.orderId}">
                                <select name="orderStatus" class="form-select form-select-sm" style="width: 130px;">
                                    <option value="PENDING" ${o.orderStatus == 'PENDING' ? 'selected' : ''}>Pending</option>
                                    <option value="PROCESSING" ${o.orderStatus == 'PROCESSING' ? 'selected' : ''}>Processing</option>
                                    <option value="SHIPPED" ${o.orderStatus == 'SHIPPED' ? 'selected' : ''}>Shipped</option>
                                    <option value="DELIVERED" ${o.orderStatus == 'DELIVERED' ? 'selected' : ''}>Delivered</option>
                                    <option value="CANCELLED" ${o.orderStatus == 'CANCELLED' ? 'selected' : ''}>Cancelled</option>
                                </select>
                                <button type="submit" class="btn btn-outline-primary btn-sm" title="Save Status">
                                    <i class="bi bi-check2"></i>
                                </button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../fragments/footer.jsp" />
