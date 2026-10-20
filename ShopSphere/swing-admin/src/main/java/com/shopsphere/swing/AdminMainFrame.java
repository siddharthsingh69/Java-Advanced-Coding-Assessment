package com.shopsphere.swing;

import com.shopsphere.dao.CategoryDAO;
import com.shopsphere.dao.OrderDAO;
import com.shopsphere.dao.ProductDAO;
import com.shopsphere.model.Category;
import com.shopsphere.model.Order;
import com.shopsphere.model.Product;
import com.shopsphere.model.User;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.util.List;

public class AdminMainFrame extends JFrame {

    private final User currentUser;
    private final ProductDAO productDAO = new ProductDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    private JTable productTable;
    private DefaultTableModel productTableModel;

    private JTable orderTable;
    private DefaultTableModel orderTableModel;

    public AdminMainFrame(User user) {
        super("ShopSphere Desktop Administration | Logged in as: " + user.getName());
        this.currentUser = user;
        initUI();
        loadProducts();
        loadOrders();
    }

    private void initUI() {
        setSize(950, 620);
        setLocationRelativeTo(null);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLayout(new BorderLayout());

        // Top Navigation Bar
        JPanel topPanel = new JPanel(new BorderLayout());
        topPanel.setBackground(new Color(30, 27, 75));
        topPanel.setBorder(BorderFactory.createEmptyBorder(12, 16, 12, 16));

        JLabel titleLabel = new JLabel("ShopSphere Desktop Control Panel");
        titleLabel.setFont(new Font("SansSerif", Font.BOLD, 18));
        titleLabel.setForeground(Color.WHITE);

        JLabel userLabel = new JLabel("Admin: " + currentUser.getName() + " (" + currentUser.getEmail() + ")");
        userLabel.setForeground(new Color(224, 231, 255));

        topPanel.add(titleLabel, BorderLayout.WEST);
        topPanel.add(userLabel, BorderLayout.EAST);
        add(topPanel, BorderLayout.NORTH);

        // Tabbed Pane for Modules
        JTabbedPane tabbedPane = new JTabbedPane();
        tabbedPane.setFont(new Font("SansSerif", Font.PLAIN, 13));

        tabbedPane.addTab("Product Management", createProductPanel());
        tabbedPane.addTab("Order Management", createOrderPanel());

        add(tabbedPane, BorderLayout.CENTER);
    }

    private JPanel createProductPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Product Table Setup
        String[] columns = {"ID", "Name", "Brand", "Category", "Price (₹)", "Discount", "Stock", "Status"};
        productTableModel = new DefaultTableModel(columns, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        productTable = new JTable(productTableModel);
        productTable.setRowHeight(24);
        productTable.getTableHeader().setFont(new Font("SansSerif", Font.BOLD, 12));
        JScrollPane scrollPane = new JScrollPane(productTable);
        panel.add(scrollPane, BorderLayout.CENTER);

        // Control Toolbar
        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 8));

        JButton refreshBtn = new JButton("Refresh");
        JButton addBtn = new JButton("Add Product");
        JButton updateStockBtn = new JButton("Quick Restock");
        JButton deleteBtn = new JButton("Delete Selected");

        refreshBtn.addActionListener(e -> loadProducts());
        addBtn.addActionListener(e -> showAddProductDialog());
        updateStockBtn.addActionListener(e -> performQuickRestock());
        deleteBtn.addActionListener(e -> deleteSelectedProduct());

        toolbar.add(refreshBtn);
        toolbar.add(addBtn);
        toolbar.add(updateStockBtn);
        toolbar.add(deleteBtn);

        panel.add(toolbar, BorderLayout.SOUTH);
        return panel;
    }

    private JPanel createOrderPanel() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        String[] columns = {"Order ID", "Customer", "Date", "Total (₹)", "Payment", "Order Status"};
        orderTableModel = new DefaultTableModel(columns, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        orderTable = new JTable(orderTableModel);
        orderTable.setRowHeight(24);
        orderTable.getTableHeader().setFont(new Font("SansSerif", Font.BOLD, 12));
        JScrollPane scrollPane = new JScrollPane(orderTable);
        panel.add(scrollPane, BorderLayout.CENTER);

        // Toolbar for orders
        JPanel toolbar = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 8));
        JButton refreshOrdersBtn = new JButton("Refresh Orders");
        JButton updateStatusBtn = new JButton("Update Status");

        refreshOrdersBtn.addActionListener(e -> loadOrders());
        updateStatusBtn.addActionListener(e -> updateOrderStatus());

        toolbar.add(refreshOrdersBtn);
        toolbar.add(updateStatusBtn);

        panel.add(toolbar, BorderLayout.SOUTH);
        return panel;
    }

    private void loadProducts() {
        productTableModel.setRowCount(0);
        List<Product> products = productDAO.findAll();
        for (Product p : products) {
            productTableModel.addRow(new Object[]{
                    p.getProductId(),
                    p.getName(),
                    p.getBrand(),
                    p.getCategoryName(),
                    String.format("%.2f", p.getPrice()),
                    p.getDiscount() + "%",
                    p.getStock(),
                    p.getStatus()
            });
        }
    }

    private void loadOrders() {
        orderTableModel.setRowCount(0);
        List<Order> orders = orderDAO.getAllOrders();
        for (Order o : orders) {
            orderTableModel.addRow(new Object[]{
                    "#ORD-" + o.getOrderId(),
                    o.getCustomerName() + " (" + o.getCustomerEmail() + ")",
                    o.getCreatedAt(),
                    String.format("%.2f", o.getFinalPayable()),
                    o.getPaymentMethod() + " (" + o.getPaymentStatus() + ")",
                    o.getOrderStatus()
            });
        }
    }

    private void showAddProductDialog() {
        List<Category> categories = categoryDAO.findAllActive();
        if (categories.isEmpty()) {
            JOptionPane.showMessageDialog(this, "No categories available to attach product.", "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }

        JTextField nameField = new JTextField(20);
        JTextField brandField = new JTextField(20);
        JComboBox<Category> catBox = new JComboBox<>(categories.toArray(new Category[0]));
        JTextField priceField = new JTextField("1999.00", 10);
        JTextField discountField = new JTextField("0.00", 10);
        JTextField stockField = new JTextField("25", 10);
        JTextField imgField = new JTextField("https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=600", 20);

        JPanel form = new JPanel(new GridLayout(7, 2, 8, 8));
        form.add(new JLabel("Product Name:")); form.add(nameField);
        form.add(new JLabel("Brand:")); form.add(brandField);
        form.add(new JLabel("Category:")); form.add(catBox);
        form.add(new JLabel("Price (₹):")); form.add(priceField);
        form.add(new JLabel("Discount (%):")); form.add(discountField);
        form.add(new JLabel("Stock Quantity:")); form.add(stockField);
        form.add(new JLabel("Image URL:")); form.add(imgField);

        int result = JOptionPane.showConfirmDialog(this, form, "Add New Product", JOptionPane.OK_CANCEL_OPTION, JOptionPane.PLAIN_MESSAGE);
        if (result == JOptionPane.OK_OPTION) {
            try {
                Product p = new Product();
                p.setName(nameField.getText().trim());
                p.setBrand(brandField.getText().trim());
                Category selected = (Category) catBox.getSelectedItem();
                p.setCategoryId(selected.getCategoryId());
                p.setPrice(Double.parseDouble(priceField.getText().trim()));
                p.setDiscount(Double.parseDouble(discountField.getText().trim()));
                p.setStock(Integer.parseInt(stockField.getText().trim()));
                p.setImageUrl(imgField.getText().trim());
                p.setStatus("ACTIVE");

                if (productDAO.create(p)) {
                    JOptionPane.showMessageDialog(this, "Product created successfully!");
                    loadProducts();
                } else {
                    JOptionPane.showMessageDialog(this, "Failed to insert product.", "Error", JOptionPane.ERROR_MESSAGE);
                }
            } catch (Exception ex) {
                JOptionPane.showMessageDialog(this, "Invalid form inputs: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void performQuickRestock() {
        int selectedRow = productTable.getSelectedRow();
        if (selectedRow < 0) {
            JOptionPane.showMessageDialog(this, "Please select a product from the table first.", "Info", JOptionPane.INFORMATION_MESSAGE);
            return;
        }

        int productId = (int) productTableModel.getValueAt(selectedRow, 0);
        String name = (String) productTableModel.getValueAt(selectedRow, 1);

        String input = JOptionPane.showInputDialog(this, "Enter stock quantity to ADD for:\n" + name, "Quick Restock", JOptionPane.QUESTION_MESSAGE);
        if (input != null && !input.trim().isEmpty()) {
            try {
                int delta = Integer.parseInt(input.trim());
                if (productDAO.updateStock(productId, delta)) {
                    JOptionPane.showMessageDialog(this, "Stock updated successfully!");
                    loadProducts();
                } else {
                    JOptionPane.showMessageDialog(this, "Stock update failed.", "Error", JOptionPane.ERROR_MESSAGE);
                }
            } catch (NumberFormatException ex) {
                JOptionPane.showMessageDialog(this, "Invalid integer quantity.", "Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void deleteSelectedProduct() {
        int selectedRow = productTable.getSelectedRow();
        if (selectedRow < 0) {
            JOptionPane.showMessageDialog(this, "Please select a product to delete.", "Info", JOptionPane.INFORMATION_MESSAGE);
            return;
        }

        int productId = (int) productTableModel.getValueAt(selectedRow, 0);
        String name = (String) productTableModel.getValueAt(selectedRow, 1);

        int confirm = JOptionPane.showConfirmDialog(this, "Are you sure you want to delete:\n" + name + "?", "Confirm Delete", JOptionPane.YES_NO_OPTION);
        if (confirm == JOptionPane.YES_OPTION) {
            if (productDAO.delete(productId)) {
                JOptionPane.showMessageDialog(this, "Product deleted.");
                loadProducts();
            } else {
                JOptionPane.showMessageDialog(this, "Could not delete product (check if referenced by orders).", "Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void updateOrderStatus() {
        int selectedRow = orderTable.getSelectedRow();
        if (selectedRow < 0) {
            JOptionPane.showMessageDialog(this, "Please select an order from the table first.", "Info", JOptionPane.INFORMATION_MESSAGE);
            return;
        }

        String orderIdStr = (String) orderTableModel.getValueAt(selectedRow, 0);
        int orderId = Integer.parseInt(orderIdStr.replace("#ORD-", ""));

        String[] statuses = {"PENDING", "PROCESSING", "SHIPPED", "DELIVERED", "CANCELLED"};
        String chosen = (String) JOptionPane.showInputDialog(this, "Select new status for order " + orderIdStr + ":",
                "Update Order Status", JOptionPane.QUESTION_MESSAGE, null, statuses, statuses[1]);

        if (chosen != null) {
            if (orderDAO.updateOrderStatus(orderId, chosen)) {
                JOptionPane.showMessageDialog(this, "Order status updated to " + chosen);
                loadOrders();
            } else {
                JOptionPane.showMessageDialog(this, "Failed to update order status.", "Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }
}
