<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<jsp:include page="fragments/header.jsp">
    <jsp:param name="title" value="Checkout | ShopSphere"/>
</jsp:include>
<jsp:include page="fragments/navbar.jsp" />

<div class="mb-4">
    <h3 class="fw-bold mb-1"><i class="bi bi-shield-lock text-primary me-2"></i> Secure Checkout</h3>
    <p class="text-muted small">Complete your delivery address and payment details below</p>
</div>

<form action="${pageContext.request.contextPath}/checkout" method="post" id="checkoutForm">
    <div class="row g-4">
        <!-- Delivery Address Selection -->
        <div class="col-lg-7">
            <div class="card border-0 shadow-sm p-4 mb-4">
                <h5 class="fw-bold mb-3"><i class="bi bi-geo-alt text-primary me-2"></i>1. Delivery Address</h5>

                <c:if test="${not empty addresses}">
                    <div class="mb-3">
                        <label class="form-label fw-semibold small text-muted">Select an existing address:</label>
                        <c:forEach var="addr" items="${addresses}" varStatus="status">
                            <div class="form-check p-3 border rounded-3 mb-2">
                                <input class="form-check-input ms-0 me-2" type="radio" name="addressId" id="addr_${addr.addressId}" 
                                       value="${addr.addressId}" ${status.first ? 'checked' : ''} onclick="toggleNewAddress(false)">
                                <label class="form-check-label" for="addr_${addr.addressId}">
                                    <span class="fw-bold text-dark">${addr.addressType}</span> - ${addr.addressLine}, ${addr.city}, ${addr.state} - ${addr.pincode}
                                </label>
                            </div>
                        </c:forEach>
                    </div>

                    <div class="form-check mb-3">
                        <input class="form-check-input" type="radio" name="addressId" id="addr_new" value="new" onclick="toggleNewAddress(true)">
                        <label class="form-check-label fw-semibold" for="addr_new">
                            + Add and deliver to a new address
                        </label>
                    </div>
                </c:if>

                <!-- New Address Fields -->
                <div id="newAddressFields" class="${not empty addresses ? 'd-none' : ''}">
                    <h6 class="fw-bold text-secondary mb-3">New Address Details</h6>
                    <div class="mb-3">
                        <label class="form-label small fw-semibold">Street / Flat / Apartment</label>
                        <input type="text" name="addressLine" class="form-control" placeholder="Flat 402, Sunshine Apartments">
                    </div>
                    <div class="row g-2 mb-3">
                        <div class="col-md-5">
                            <label class="form-label small fw-semibold">City</label>
                            <input type="text" name="city" class="form-control" placeholder="Jaipur">
                        </div>
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">State</label>
                            <input type="text" name="state" class="form-control" placeholder="Rajasthan">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label small fw-semibold">Pincode</label>
                            <input type="text" name="pincode" class="form-control" placeholder="302001">
                        </div>
                    </div>
                    <div class="mb-2">
                        <label class="form-label small fw-semibold">Address Type</label>
                        <select name="addressType" class="form-select form-select-sm" style="max-width: 200px;">
                            <option value="HOME">Home</option>
                            <option value="WORK">Work</option>
                            <option value="OTHER">Other</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Payment Method -->
            <div class="card border-0 shadow-sm p-4">
                <h5 class="fw-bold mb-3"><i class="bi bi-credit-card text-primary me-2"></i>2. Payment Method</h5>
                <div class="form-check p-3 border rounded-3 mb-2">
                    <input class="form-check-input ms-0 me-2" type="radio" name="paymentMethod" id="pay_cod" value="COD" checked>
                    <label class="form-check-label fw-semibold" for="pay_cod">
                        <i class="bi bi-cash-stack text-success me-1"></i> Cash on Delivery (COD)
                    </label>
                </div>
                <div class="form-check p-3 border rounded-3 mb-2">
                    <input class="form-check-input ms-0 me-2" type="radio" name="paymentMethod" id="pay_upi" value="UPI">
                    <label class="form-check-label fw-semibold" for="pay_upi">
                        <i class="bi bi-qr-code-scan text-primary me-1"></i> UPI (Google Pay / PhonePe / Paytm)
                    </label>
                </div>
                <div class="form-check p-3 border rounded-3">
                    <input class="form-check-input ms-0 me-2" type="radio" name="paymentMethod" id="pay_card" value="CARD">
                    <label class="form-check-label fw-semibold" for="pay_card">
                        <i class="bi bi-credit-card-2-front text-info me-1"></i> Credit / Debit Card
                    </label>
                </div>
            </div>
        </div>

        <!-- Checkout Summary & Coupon -->
        <div class="col-lg-5">
            <div class="card border-0 shadow-sm p-4 mb-4">
                <h5 class="fw-bold mb-3">Order Details</h5>
                <div class="list-group list-group-flush mb-3">
                    <c:forEach var="item" items="${cartItems}">
                        <div class="list-group-item px-0 d-flex justify-content-between align-items-center">
                            <div>
                                <span class="fw-semibold text-dark">${item.product.name}</span>
                                <div class="text-muted small">Qty: ${item.quantity} &times; ₹<fmt:formatNumber value="${item.product.finalPrice}" maxFractionDigits="2"/></div>
                            </div>
                            <span class="fw-bold text-dark">₹<fmt:formatNumber value="${item.subtotal}" maxFractionDigits="2"/></span>
                        </div>
                    </c:forEach>
                </div>

                <!-- Coupon Entry Form -->
                <div class="mb-3">
                    <label class="form-label small fw-semibold">Apply Promo Coupon</label>
                    <div class="input-group">
                        <input type="text" id="couponInput" class="form-control" placeholder="e.g. WELCOME10" value="${appliedCoupon != null ? appliedCoupon.code : ''}">
                        <button type="button" class="btn btn-outline-primary" onclick="applyCoupon()">Apply</button>
                    </div>
                    <c:if test="${not empty appliedCoupon}">
                        <div class="text-success small mt-1">
                            <i class="bi bi-check-circle-fill"></i> Coupon <b>${appliedCoupon.code}</b> applied! (Saved ₹<fmt:formatNumber value="${discountAmount}" maxFractionDigits="2"/>)
                        </div>
                    </c:if>
                    <c:if test="${not empty couponError}">
                        <div class="text-danger small mt-1">${couponError}</div>
                    </c:if>
                </div>

                <!-- Hidden coupon code passed with order form -->
                <input type="hidden" name="couponCode" id="hiddenCouponCode" value="${appliedCoupon != null ? appliedCoupon.code : ''}">

                <hr>
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted">Subtotal</span>
                    <span class="fw-semibold">₹<fmt:formatNumber value="${subtotal}" maxFractionDigits="2"/></span>
                </div>
                <c:if test="${discountAmount > 0}">
                    <div class="d-flex justify-content-between mb-2 text-success">
                        <span>Coupon Discount</span>
                        <span>- ₹<fmt:formatNumber value="${discountAmount}" maxFractionDigits="2"/></span>
                    </div>
                </c:if>
                <div class="d-flex justify-content-between mb-3">
                    <span class="text-muted">Shipping</span>
                    <span class="text-success fw-semibold">FREE</span>
                </div>
                <hr>
                <div class="d-flex justify-content-between align-items-baseline mb-4">
                    <span class="fs-5 fw-bold">Total Amount</span>
                    <span class="fs-3 fw-bold text-primary">₹<fmt:formatNumber value="${totalPayable}" maxFractionDigits="2"/></span>
                </div>

                <button type="submit" class="btn btn-primary w-100 py-3 fw-bold fs-6">
                    Place Order Now <i class="bi bi-check-circle ms-1"></i>
                </button>
            </div>
        </div>
    </div>
</form>

<script>
function toggleNewAddress(show) {
    var elem = document.getElementById("newAddressFields");
    if (show) {
        elem.classList.remove("d-none");
    } else {
        elem.classList.add("d-none");
    }
}

function applyCoupon() {
    var code = document.getElementById("couponInput").value;
    if (code) {
        window.location.href = "${pageContext.request.contextPath}/checkout?coupon=" + encodeURIComponent(code.trim());
    }
}
</script>

<jsp:include page="fragments/footer.jsp" />
