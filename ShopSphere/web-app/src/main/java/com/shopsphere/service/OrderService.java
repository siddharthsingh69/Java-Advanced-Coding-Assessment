package com.shopsphere.service;

import com.shopsphere.dao.CouponDAO;
import com.shopsphere.dao.OrderDAO;
import com.shopsphere.model.CartItem;
import com.shopsphere.model.Coupon;
import com.shopsphere.model.Order;

import java.util.List;

public class OrderService {

    private final OrderDAO orderDAO = new OrderDAO();
    private final CouponDAO couponDAO = new CouponDAO();
    private final CartService cartService = new CartService();

    public boolean placeOrder(int userId, Integer addressId, String couponCode, String paymentMethod) {
        List<CartItem> cartItems = cartService.getCartItems(userId);
        if (cartItems == null || cartItems.isEmpty()) {
            return false;
        }

        double totalAmount = cartService.calculateTotal(cartItems);
        double discount = 0.0;

        if (couponCode != null && !couponCode.trim().isEmpty()) {
            Coupon coupon = couponDAO.findByCode(couponCode.trim());
            if (coupon != null) {
                discount = coupon.calculateDiscount(totalAmount);
            }
        }

        Order order = new Order();
        order.setUserId(userId);
        order.setAddressId(addressId);
        order.setTotalAmount(totalAmount);
        order.setDiscount(discount);
        order.setPaymentMethod(paymentMethod != null ? paymentMethod : "COD");
        order.setPaymentStatus("COD".equalsIgnoreCase(paymentMethod) ? "PENDING" : "COMPLETED");
        order.setOrderStatus("PENDING");

        return orderDAO.placeOrder(order, cartItems);
    }

    public List<Order> getCustomerOrders(int userId) {
        return orderDAO.getOrdersByUser(userId);
    }

    public Order getOrderDetails(int orderId) {
        return orderDAO.getOrderById(orderId);
    }

    public List<Order> getAllOrders() {
        return orderDAO.getAllOrders();
    }

    public boolean updateStatus(int orderId, String newStatus) {
        return orderDAO.updateOrderStatus(orderId, newStatus);
    }
}
