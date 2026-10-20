<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="../fragments/header.jsp">
    <jsp:param name="title" value="Manage Products | ShopSphere Admin"/>
</jsp:include>
<jsp:include page="../fragments/navbar.jsp" />

<div class="d-flex justify-content-between align-items-center mb-4">
    <div>
        <h3 class="fw-bold mb-1"><i class="bi bi-box-seam text-primary me-2"></i> Product Inventory</h3>
        <p class="text-muted small mb-0">Create, edit, or adjust inventory and pricing</p>
    </div>
    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addProductModal">
        <i class="bi bi-plus-lg me-1"></i> Add New Product
    </button>
</div>

<div class="card border-0 shadow-sm p-4">
    <div class="table-responsive">
        <table class="table align-middle mb-0">
            <thead class="table-light">
                <tr class="small text-uppercase text-muted">
                    <th>ID</th>
                    <th>Product</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Discount</th>
                    <th>Stock</th>
                    <th>Status</th>
                    <th class="text-end">Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${products}">
                    <tr>
                        <td class="text-muted">#${p.productId}</td>
                        <td>
                            <div class="d-flex align-items-center gap-2">
                                <img src="${p.imageUrl}" alt="${p.name}" class="rounded-2 object-fit-cover" width="40" height="40">
                                <div>
                                    <div class="fw-bold text-dark">${p.name}</div>
                                    <span class="text-muted small">${p.brand}</span>
                                </div>
                            </div>
                        </td>
                        <td><span class="badge bg-light text-dark border">${p.categoryName}</span></td>
                        <td class="fw-semibold">₹<fmt:formatNumber value="${p.price}" maxFractionDigits="2"/></td>
                        <td>${p.discount}%</td>
                        <td>
                            <c:choose>
                                <c:when test="${p.stock <= 5}">
                                    <span class="badge bg-danger">${p.stock} (Low)</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-success-subtle text-success">${p.stock} units</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <span class="badge ${p.status == 'ACTIVE' ? 'bg-success' : 'bg-secondary'}">${p.status}</span>
                        </td>
                        <td class="text-end">
                            <form action="${pageContext.request.contextPath}/admin/products" method="post" class="d-inline" onsubmit="return confirm('Delete this product?');">
                                <input type="hidden" name="action" value="deleteProduct">
                                <input type="hidden" name="productId" value="${p.productId}">
                                <button type="submit" class="btn btn-outline-danger btn-sm border-0" title="Delete Product">
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

<!-- Add Product Modal -->
<div class="modal fade" id="addProductModal" tabindex="-1" aria-labelledby="addProductModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content border-0 shadow">
            <form action="${pageContext.request.contextPath}/admin/products" method="post">
                <input type="hidden" name="action" value="addProduct">
                <div class="modal-header">
                    <h5 class="modal-title fw-bold" id="addProductModalLabel">Add New Product</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row g-3">
                        <div class="col-md-8">
                            <label class="form-label small fw-semibold">Product Name</label>
                            <input type="text" name="name" class="form-control" placeholder="e.g. Ergonomic Bluetooth Mouse" required>
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Brand</label>
                            <input type="text" name="brand" class="form-control" placeholder="e.g. Logitech" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Category</label>
                            <select name="categoryId" class="form-select" required>
                                <c:forEach var="c" items="${categories}">
                                    <option value="${c.categoryId}">${c.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Price (₹)</label>
                            <input type="number" step="0.01" name="price" class="form-control" placeholder="1999.00" required>
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Discount (%)</label>
                            <input type="number" step="0.01" name="discount" class="form-control" placeholder="10.00" value="0.00">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Initial Stock</label>
                            <input type="number" name="stock" class="form-control" placeholder="50" required>
                        </div>
                        <div class="col-md-8">
                            <label class="form-label small fw-semibold">Image URL</label>
                            <input type="url" name="imageUrl" class="form-control" placeholder="https://images.unsplash.com/..." required>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-semibold">Description</label>
                            <textarea name="description" rows="3" class="form-control" placeholder="Product features, specifications, and warranty info..."></textarea>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-primary fw-semibold">Save Product</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="../fragments/footer.jsp" />
