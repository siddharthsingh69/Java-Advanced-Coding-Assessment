package com.shopsphere.dao;

import com.shopsphere.model.*;
import com.shopsphere.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    /**
     * Executes order placement atomically in a single JDBC transaction.
     */
    public boolean placeOrder(Order order, List<CartItem> items) {
        String insertOrderSql = "INSERT INTO orders (user_id, address_id, total_amount, discount, payment_method, payment_status, order_status) " +
                                "VALUES (?, ?, ?, ?, ?, ?, ?)";
        String insertItemSql = "INSERT INTO order_items (order_id, product_id, quantity, price) VALUES (?, ?, ?, ?)";
        String updateStockSql = "UPDATE products SET stock = stock - ? WHERE product_id = ? AND stock >= ?";
        String clearCartSql = "DELETE FROM cart WHERE user_id = ?";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Begin transaction

            // 1. Insert order
            int orderId;
            try (PreparedStatement psOrder = conn.prepareStatement(insertOrderSql, Statement.RETURN_GENERATED_KEYS)) {
                psOrder.setInt(1, order.getUserId());
                if (order.getAddressId() != null) {
                    psOrder.setInt(2, order.getAddressId());
                } else {
                    psOrder.setNull(2, Types.INTEGER);
                }
                psOrder.setDouble(3, order.getTotalAmount());
                psOrder.setDouble(4, order.getDiscount());
                psOrder.setString(5, order.getPaymentMethod());
                psOrder.setString(6, order.getPaymentStatus());
                psOrder.setString(7, order.getOrderStatus());

                psOrder.executeUpdate();
                try (ResultSet rs = psOrder.getGeneratedKeys()) {
                    if (rs.next()) {
                        orderId = rs.getInt(1);
                        order.setOrderId(orderId);
                    } else {
                        conn.rollback();
                        return false;
                    }
                }
            }

            // 2. Insert items and decrement stock
            try (PreparedStatement psItem = conn.prepareStatement(insertItemSql);
                 PreparedStatement psStock = conn.prepareStatement(updateStockSql)) {
                for (CartItem item : items) {
                    // Check & decrement stock
                    psStock.setInt(1, item.getQuantity());
                    psStock.setInt(2, item.getProductId());
                    psStock.setInt(3, item.getQuantity());
                    int stockUpdated = psStock.executeUpdate();
                    if (stockUpdated == 0) {
                        // Insufficient stock!
                        conn.rollback();
                        return false;
                    }

                    // Insert order item
                    psItem.setInt(1, orderId);
                    psItem.setInt(2, item.getProductId());
                    psItem.setInt(3, item.getQuantity());
                    psItem.setDouble(4, item.getProduct().getFinalPrice());
                    psItem.addBatch();
                }
                psItem.executeBatch();
            }

            // 3. Clear customer's cart
            try (PreparedStatement psClear = conn.prepareStatement(clearCartSql)) {
                psClear.setInt(1, order.getUserId());
                psClear.executeUpdate();
            }

            conn.commit(); // Transaction success
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    rollbackEx.printStackTrace();
                }
            }
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    closeEx.printStackTrace();
                }
            }
        }
        return false;
    }

    public List<Order> getOrdersByUser(int userId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapOrderRow(rs));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.name AS customer_name, u.email AS customer_email " +
                     "FROM orders o JOIN users u ON o.user_id = u.user_id " +
                     "ORDER BY o.created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = mapOrderRow(rs);
                order.setCustomerName(rs.getString("customer_name"));
                order.setCustomerEmail(rs.getString("customer_email"));
                list.add(order);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Order getOrderById(int orderId) {
        String orderSql = "SELECT o.*, u.name AS customer_name, u.email AS customer_email " +
                          "FROM orders o JOIN users u ON o.user_id = u.user_id " +
                          "WHERE o.order_id = ?";
        String itemsSql = "SELECT oi.*, p.name, p.brand, p.image_url FROM order_items oi " +
                          "JOIN products p ON oi.product_id = p.product_id " +
                          "WHERE oi.order_id = ?";
        String addrSql = "SELECT * FROM addresses WHERE address_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(orderSql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapOrderRow(rs);
                    order.setCustomerName(rs.getString("customer_name"));
                    order.setCustomerEmail(rs.getString("customer_email"));

                    // Fetch address if present
                    if (order.getAddressId() != null) {
                        try (PreparedStatement psAddr = conn.prepareStatement(addrSql)) {
                            psAddr.setInt(1, order.getAddressId());
                            try (ResultSet rsAddr = psAddr.executeQuery()) {
                                if (rsAddr.next()) {
                                    Address a = new Address();
                                    a.setAddressId(rsAddr.getInt("address_id"));
                                    a.setAddressLine(rsAddr.getString("address_line"));
                                    a.setCity(rsAddr.getString("city"));
                                    a.setState(rsAddr.getString("state"));
                                    a.setPincode(rsAddr.getString("pincode"));
                                    a.setAddressType(rsAddr.getString("address_type"));
                                    order.setAddress(a);
                                }
                            }
                        }
                    }

                    // Fetch items
                    try (PreparedStatement psItems = conn.prepareStatement(itemsSql)) {
                        psItems.setInt(1, orderId);
                        try (ResultSet rsItems = psItems.executeQuery()) {
                            while (rsItems.next()) {
                                OrderItem item = new OrderItem();
                                item.setOrderItemId(rsItems.getInt("order_item_id"));
                                item.setOrderId(rsItems.getInt("order_id"));
                                item.setProductId(rsItems.getInt("product_id"));
                                item.setQuantity(rsItems.getInt("quantity"));
                                item.setPrice(rsItems.getDouble("price"));

                                Product p = new Product();
                                p.setProductId(rsItems.getInt("product_id"));
                                p.setName(rsItems.getString("name"));
                                p.setBrand(rsItems.getString("brand"));
                                p.setImageUrl(rsItems.getString("image_url"));
                                item.setProduct(p);

                                order.getItems().add(item);
                            }
                        }
                    }

                    return order;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateOrderStatus(int orderId, String newStatus) {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    private Order mapOrderRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        int addrId = rs.getInt("address_id");
        if (!rs.wasNull()) {
            o.setAddressId(addrId);
        }
        o.setTotalAmount(rs.getDouble("total_amount"));
        o.setDiscount(rs.getDouble("discount"));
        o.setPaymentMethod(rs.getString("payment_method"));
        o.setPaymentStatus(rs.getString("payment_status"));
        o.setOrderStatus(rs.getString("order_status"));
        o.setCreatedAt(rs.getTimestamp("created_at"));
        return o;
    }
}
