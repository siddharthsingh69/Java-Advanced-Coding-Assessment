package com.shopsphere.swing;

import com.shopsphere.dao.UserDAO;
import com.shopsphere.model.User;

import javax.swing.*;
import java.awt.*;

public class AdminLoginDialog extends JDialog {

    private JTextField emailField;
    private JPasswordField passwordField;
    private boolean authenticated = false;
    private User authenticatedUser;

    public AdminLoginDialog(JFrame parent) {
        super(parent, "ShopSphere Admin - Secure Desktop Login", true);
        initUI();
    }

    private void initUI() {
        setSize(420, 260);
        setLocationRelativeTo(getParent());
        setResizable(false);
        setLayout(new BorderLayout(10, 10));

        // Header Banner
        JPanel headerPanel = new JPanel();
        headerPanel.setBackground(new Color(79, 70, 229));
        headerPanel.setBorder(BorderFactory.createEmptyBorder(12, 12, 12, 12));
        JLabel titleLabel = new JLabel("ShopSphere Desktop Admin");
        titleLabel.setFont(new Font("SansSerif", Font.BOLD, 16));
        titleLabel.setForeground(Color.WHITE);
        headerPanel.add(titleLabel);
        add(headerPanel, BorderLayout.NORTH);

        // Form Panel
        JPanel formPanel = new JPanel(new GridBagLayout());
        formPanel.setBorder(BorderFactory.createEmptyBorder(15, 20, 10, 20));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(6, 6, 6, 6);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        gbc.gridx = 0; gbc.gridy = 0;
        formPanel.add(new JLabel("Admin Email:"), gbc);
        gbc.gridx = 1; gbc.weightx = 1.0;
        emailField = new JTextField("admin@shopsphere.com", 18);
        formPanel.add(emailField, gbc);

        gbc.gridx = 0; gbc.gridy = 1; gbc.weightx = 0.0;
        formPanel.add(new JLabel("Password:"), gbc);
        gbc.gridx = 1; gbc.weightx = 1.0;
        passwordField = new JPasswordField("admin123", 18);
        formPanel.add(passwordField, gbc);

        add(formPanel, BorderLayout.CENTER);

        // Button Panel
        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT, 10, 10));
        JButton cancelButton = new JButton("Cancel");
        JButton loginButton = new JButton("Login");
        loginButton.setFont(new Font("SansSerif", Font.BOLD, 12));
        loginButton.setBackground(new Color(79, 70, 229));
        loginButton.setForeground(Color.WHITE);

        cancelButton.addActionListener(e -> dispose());
        loginButton.addActionListener(e -> performLogin());

        // Enter key activates login
        getRootPane().setDefaultButton(loginButton);

        buttonPanel.add(cancelButton);
        buttonPanel.add(loginButton);
        add(buttonPanel, BorderLayout.SOUTH);
    }

    private void performLogin() {
        String email = emailField.getText().trim();
        String pass = new String(passwordField.getPassword()).trim();

        UserDAO userDAO = new UserDAO();
        User user = userDAO.authenticate(email, pass);

        if (user != null && user.isAdmin()) {
            this.authenticated = true;
            this.authenticatedUser = user;
            dispose();
        } else {
            JOptionPane.showMessageDialog(this,
                    "Invalid Admin credentials or unauthorized role.",
                    "Authentication Failed",
                    JOptionPane.ERROR_MESSAGE);
        }
    }

    public boolean isAuthenticated() {
        return authenticated;
    }

    public User getAuthenticatedUser() {
        return authenticatedUser;
    }
}
