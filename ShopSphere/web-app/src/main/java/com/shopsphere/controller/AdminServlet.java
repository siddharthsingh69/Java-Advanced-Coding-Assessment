package com.shopsphere.controller;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.Category;
import com.shopsphere.model.Order;
import com.shopsphere.model.Product;
import com.shopsphere.model.User;
import com.shopsphere.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = {
    "/admin",
    "/admin/dashboard",
    "/admin/products",
    "/admin/orders",
    "/admin/users"
})
public class AdminServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final OrderService orderService = new OrderService();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/admin/products".equals(path)) {
            List<Product> products = productDAO.findAll();
            List<Category> categories = categoryDAO.findAll();
            req.setAttribute("products", products);
            req.setAttribute("categories", categories);
            req.getRequestDispatcher("/admin/products.jsp").forward(req, resp);
        } else if ("/admin/orders".equals(path)) {
            List<Order> orders = orderService.getAllOrders();
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/admin/orders.jsp").forward(req, resp);
        } else if ("/admin/users".equals(path)) {
            List<User> customers = userDAO.findAllCustomers();
            req.setAttribute("customers", customers);
            req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
        } else {
            // Dashboard KPI summary
            List<Product> products = productDAO.findAll();
            List<Order> orders = orderService.getAllOrders();
            List<User> customers = userDAO.findAllCustomers();

            double totalRevenue = 0.0;
            int lowStockCount = 0;
            for (Order o : orders) {
                if ("COMPLETED".equalsIgnoreCase(o.getPaymentStatus()) || !"CANCELLED".equalsIgnoreCase(o.getOrderStatus())) {
                    totalRevenue += o.getFinalPayable();
                }
            }
            for (Product p : products) {
                if (p.getStock() <= 5) {
                    lowStockCount++;
                }
            }

            req.setAttribute("totalProducts", products.size());
            req.setAttribute("totalOrders", orders.size());
            req.setAttribute("totalCustomers", customers.size());
            req.setAttribute("totalRevenue", Math.round(totalRevenue * 100.0) / 100.0);
            req.setAttribute("lowStockCount", lowStockCount);
            req.setAttribute("recentOrders", orders.size() > 5 ? orders.subList(0, 5) : orders);

            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");

        if ("addProduct".equalsIgnoreCase(action)) {
            try {
                Product p = new Product();
                p.setCategoryId(Integer.parseInt(req.getParameter("categoryId")));
                p.setName(req.getParameter("name"));
                p.setBrand(req.getParameter("brand"));
                p.setDescription(req.getParameter("description"));
                p.setPrice(Double.parseDouble(req.getParameter("price")));
                p.setDiscount(Double.parseDouble(req.getParameter("discount")));
                p.setStock(Integer.parseInt(req.getParameter("stock")));
                p.setImageUrl(req.getParameter("imageUrl"));
                p.setStatus("ACTIVE");

                productDAO.create(p);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/admin/products?success=created");
        } else if ("deleteProduct".equalsIgnoreCase(action)) {
            try {
                int productId = Integer.parseInt(req.getParameter("productId"));
                productDAO.delete(productId);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/admin/products?success=deleted");
        } else if ("updateOrderStatus".equalsIgnoreCase(action)) {
            try {
                int orderId = Integer.parseInt(req.getParameter("orderId"));
                String newStatus = req.getParameter("orderStatus");
                orderService.updateStatus(orderId, newStatus);
            } catch (Exception e) {
                e.printStackTrace();
            }
            resp.sendRedirect(req.getContextPath() + "/admin/orders?success=updated");
        }
    }
}
