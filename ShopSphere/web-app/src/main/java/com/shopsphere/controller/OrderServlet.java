package com.shopsphere.controller;

import com.shopsphere.model.Order;
import com.shopsphere.model.User;
import com.shopsphere.service.OrderService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderServlet", urlPatterns = {"/orders", "/order-details"})
public class OrderServlet extends HttpServlet {

    private final OrderService orderService = new OrderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("user");

        String servletPath = req.getServletPath();

        if ("/order-details".equals(servletPath)) {
            String idStr = req.getParameter("id");
            if (idStr != null) {
                try {
                    int orderId = Integer.parseInt(idStr);
                    Order order = orderService.getOrderDetails(orderId);
                    // Ensure customer owns this order or is admin
                    if (order != null && (order.getUserId() == user.getUserId() || user.isAdmin())) {
                        req.setAttribute("order", order);
                        req.getRequestDispatcher("/order-details.jsp").forward(req, resp);
                        return;
                    }
                } catch (NumberFormatException ignored) {}
            }
            resp.sendRedirect(req.getContextPath() + "/orders");
        } else {
            List<Order> orders = orderService.getCustomerOrders(user.getUserId());
            req.setAttribute("orders", orders);
            req.getRequestDispatcher("/orders.jsp").forward(req, resp);
        }
    }
}
