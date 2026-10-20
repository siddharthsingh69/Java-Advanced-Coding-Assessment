package com.shopsphere.swing;

import javax.swing.*;

public class SwingAdminApp {

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            try {
                // Set system look and feel
                UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
            } catch (Exception ignored) {
            }

            AdminLoginDialog loginDialog = new AdminLoginDialog(null);
            loginDialog.setVisible(true);

            if (loginDialog.isAuthenticated()) {
                AdminMainFrame mainFrame = new AdminMainFrame(loginDialog.getAuthenticatedUser());
                mainFrame.setVisible(true);
            } else {
                System.exit(0);
            }
        });
    }
}
