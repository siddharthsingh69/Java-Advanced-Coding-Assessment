package com.shopsphere.service;

import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.User;

public class AuthService {

    private final UserDAO userDAO = new UserDAO();

    public User login(String email, String password) {
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            return null;
        }
        return userDAO.authenticate(email.trim().toLowerCase(), password);
    }

    public boolean register(String name, String email, String password, String mobile) {
        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            return false;
        }
        // Check duplicate email
        if (userDAO.findByEmail(email.trim().toLowerCase()) != null) {
            return false;
        }

        User user = new User();
        user.setName(name != null ? name.trim() : "");
        user.setEmail(email.trim().toLowerCase());
        user.setPassword(password);
        user.setMobile(mobile != null ? mobile.trim() : "");
        user.setRole("CUSTOMER");
        user.setStatus("ACTIVE");

        return userDAO.register(user);
    }
}
