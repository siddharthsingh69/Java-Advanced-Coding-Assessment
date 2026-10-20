package com.shopsphere.service;

import com.shopsphere.dao.CartDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.CartItem;
import com.shopsphere.model.Product;

import java.util.List;

public class CartService {

    private final CartDAO cartDAO = new CartDAO();
    private final ProductDAO productDAO = new ProductDAO();

    public List<CartItem> getCartItems(int userId) {
        return cartDAO.getCartByUser(userId);
    }

    public boolean addToCart(int userId, int productId, int quantity) {
        Product p = productDAO.findById(productId);
        if (p == null || !p.isInStock()) {
            return false;
        }
        return cartDAO.addToCart(userId, productId, quantity);
    }

    public boolean updateQuantity(int cartId, int quantity) {
        return cartDAO.updateQuantity(cartId, quantity);
    }

    public boolean removeItem(int cartId) {
        return cartDAO.removeFromCart(cartId);
    }

    public int getCartItemCount(int userId) {
        return cartDAO.getCartCount(userId);
    }

    public double calculateTotal(List<CartItem> items) {
        double total = 0.0;
        for (CartItem item : items) {
            total += item.getSubtotal();
        }
        return Math.round(total * 100.0) / 100.0;
    }
}
