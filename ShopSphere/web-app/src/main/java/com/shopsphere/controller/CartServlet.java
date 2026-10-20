package com.shopsphere.controller;

import com.shopsphere.model.CartItem;
import com.shopsphere.model.User;
import com.shopsphere.service.CartService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CartServlet", urlPatterns = {"/cart"})
public class CartServlet extends HttpServlet {

    private final CartService cartService = new CartService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        List<CartItem> cartItems = cartService.getCartItems(user.getUserId());
        double total = cartService.calculateTotal(cartItems);

        req.setAttribute("cartItems", cartItems);
        req.setAttribute("cartTotal", total);

        // Update session cart count
        session.setAttribute("cartCount", cartService.getCartItemCount(user.getUserId()));

        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        String action = req.getParameter("action");

        try {
            if ("add".equalsIgnoreCase(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                int quantity = 1;
                if (req.getParameter("quantity") != null) {
                    quantity = Math.max(1, Integer.parseInt(req.getParameter("quantity")));
                }
                cartService.addToCart(user.getUserId(), productId, quantity);
            } else if ("update".equalsIgnoreCase(action)) {
                int cartId = Integer.parseInt(req.getParameter("cartId"));
                int quantity = Integer.parseInt(req.getParameter("quantity"));
                cartService.updateQuantity(cartId, quantity);
            } else if ("remove".equalsIgnoreCase(action)) {
                int cartId = Integer.parseInt(req.getParameter("cartId"));
                cartService.removeItem(cartId);
            }

            // Refresh cart count
            session.setAttribute("cartCount", cartService.getCartItemCount(user.getUserId()));
        } catch (Exception e) {
            e.printStackTrace();
        }

        String referer = req.getHeader("referer");
        if (referer != null && referer.contains("/product?")) {
            resp.sendRedirect(referer + "&added=true");
        } else {
            resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }
}
