package com.shopsphere.controller;

import com.shopsphere.dao.AddressDAO;
import com.shopsphere.dao.CouponDAO;
import com.shopsphere.model.Address;
import com.shopsphere.model.CartItem;
import com.shopsphere.model.Coupon;
import com.shopsphere.model.User;
import com.shopsphere.service.CartService;
import com.shopsphere.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CheckoutServlet", urlPatterns = {"/checkout"})
public class CheckoutServlet extends HttpServlet {

    private final AddressDAO addressDAO = new AddressDAO();
    private final CartService cartService = new CartService();
    private final OrderService orderService = new OrderService();
    private final CouponDAO couponDAO = new CouponDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        List<CartItem> cartItems = cartService.getCartItems(user.getUserId());
        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        List<Address> addresses = addressDAO.findByUser(user.getUserId());
        double subtotal = cartService.calculateTotal(cartItems);

        String couponCode = req.getParameter("coupon");
        double discount = 0.0;
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            Coupon c = couponDAO.findByCode(couponCode.trim());
            if (c != null) {
                discount = c.calculateDiscount(subtotal);
                req.setAttribute("appliedCoupon", c);
                req.setAttribute("discountAmount", discount);
            } else {
                req.setAttribute("couponError", "Invalid or expired coupon code.");
            }
        }

        req.setAttribute("cartItems", cartItems);
        req.setAttribute("subtotal", subtotal);
        req.setAttribute("totalPayable", Math.max(0.0, subtotal - discount));
        req.setAttribute("addresses", addresses);

        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        String addressIdStr = req.getParameter("addressId");
        String newAddressLine = req.getParameter("addressLine");
        String paymentMethod = req.getParameter("paymentMethod");
        String couponCode = req.getParameter("couponCode");

        Integer selectedAddressId = null;

        // Check if user submitted a new address
        if ("new".equalsIgnoreCase(addressIdStr) || (addressIdStr == null && newAddressLine != null)) {
            String city = req.getParameter("city");
            String state = req.getParameter("state");
            String pincode = req.getParameter("pincode");
            String addressType = req.getParameter("addressType");

            Address a = new Address();
            a.setUserId(user.getUserId());
            a.setAddressLine(newAddressLine);
            a.setCity(city);
            a.setState(state);
            a.setPincode(pincode);
            a.setAddressType(addressType != null ? addressType : "HOME");

            if (addressDAO.create(a)) {
                selectedAddressId = a.getAddressId();
            }
        } else if (addressIdStr != null && !addressIdStr.isEmpty()) {
            try {
                selectedAddressId = Integer.parseInt(addressIdStr);
            } catch (NumberFormatException ignored) {}
        }

        boolean success = orderService.placeOrder(user.getUserId(), selectedAddressId, couponCode, paymentMethod);
        if (success) {
            // Update session cart count
            session.setAttribute("cartCount", 0);
            resp.sendRedirect(req.getContextPath() + "/orders?placed=true");
        } else {
            resp.sendRedirect(req.getContextPath() + "/checkout?error=failed");
        }
    }
}
