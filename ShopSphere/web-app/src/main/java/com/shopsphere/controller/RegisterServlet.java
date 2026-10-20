package com.shopsphere.controller;

import com.shopsphere.service.AuthService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String mobile = req.getParameter("mobile");

        if (password == null || password.length() < 6) {
            req.setAttribute("errorMessage", "Password must be at least 6 characters long.");
            req.setAttribute("name", name);
            req.setAttribute("email", email);
            req.setAttribute("mobile", mobile);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        boolean success = authService.register(name, email, password, mobile);
        if (success) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?success=registered");
        } else {
            req.setAttribute("errorMessage", "Email already exists or invalid registration data.");
            req.setAttribute("name", name);
            req.setAttribute("email", email);
            req.setAttribute("mobile", mobile);
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        }
    }
}
