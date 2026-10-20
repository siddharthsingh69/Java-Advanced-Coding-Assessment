<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../fragments/header.jsp">
    <jsp:param name="title" value="Customer Accounts | ShopSphere Admin"/>
</jsp:include>
<jsp:include page="../fragments/navbar.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-1"><i class="bi bi-people text-primary me-2"></i> Registered Customers</h3>
        <p class="text-muted small mb-0">List of verified registered customer profiles</p>
    </div>
</div>

<div class="card border-0 shadow-sm p-4">
    <div class="table-responsive">
        <table class="table align-middle mb-0">
            <thead class="table-light">
                <tr class="small text-uppercase text-muted">
                    <th>User ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Mobile</th>
                    <th>Status</th>
                    <th>Registered On</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="c" items="${customers}">
                    <tr>
                        <td class="text-muted">#USR-${c.userId}</td>
                        <td class="fw-bold text-dark">${c.name}</td>
                        <td>${c.email}</td>
                        <td>${c.mobile}</td>
                        <td>
                            <span class="badge ${c.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">${c.status}</span>
                        </td>
                        <td class="small text-muted"><fmt:formatDate value="${c.createdAt}" pattern="dd MMM yyyy, hh:mm a"/></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../fragments/footer.jsp" />
