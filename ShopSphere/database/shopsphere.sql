-- =====================================================================
-- ShopSphere: Advanced Java E-Commerce Database Schema & Seed Data
-- Database: shopsphere
-- Supported DBMS: MySQL 8.0+
-- =====================================================================

CREATE DATABASE IF NOT EXISTS shopsphere CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE shopsphere;

-- Drop tables in reverse order of foreign keys
DROP TABLE IF EXISTS coupon_usage;
DROP TABLE IF EXISTS coupons;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS wishlist;
DROP TABLE IF EXISTS cart;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS users;

-- 1. Users table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Stored as SHA-256 hash or Bcrypt
    mobile VARCHAR(15),
    role ENUM('CUSTOMER', 'ADMIN') DEFAULT 'CUSTOMER',
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Addresses table
CREATE TABLE addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    address_line VARCHAR(255) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(10) NOT NULL,
    address_type ENUM('HOME', 'WORK', 'OTHER') DEFAULT 'HOME',
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 3. Categories table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE'
) ENGINE=InnoDB;

-- 4. Products table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(200) NOT NULL,
    brand VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(5, 2) DEFAULT 0.00, -- discount percentage (e.g. 10.00 for 10%)
    stock INT NOT NULL DEFAULT 0,
    image_url VARCHAR(500),
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 5. Cart table
CREATE TABLE cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    UNIQUE KEY uq_user_product (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6. Wishlist table
CREATE TABLE wishlist (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_wishlist_user_product (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 7. Orders table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    address_id INT,
    total_amount DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(10, 2) DEFAULT 0.00,
    payment_method ENUM('COD', 'CARD', 'UPI', 'NET_BANKING') DEFAULT 'COD',
    payment_status ENUM('PENDING', 'COMPLETED', 'FAILED') DEFAULT 'PENDING',
    order_status ENUM('PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (address_id) REFERENCES addresses(address_id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 8. Order items table
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 9. Payments table
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    transaction_reference VARCHAR(100),
    amount DECIMAL(10, 2) NOT NULL,
    payment_status ENUM('SUCCESS', 'FAILED', 'PENDING') DEFAULT 'PENDING',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 10. Reviews table
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    review_text TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 11. Coupons table
CREATE TABLE coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    code VARCHAR(50) NOT NULL UNIQUE,
    discount_type ENUM('PERCENTAGE', 'FIXED') NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL,
    minimum_order DECIMAL(10, 2) DEFAULT 0.00,
    maximum_discount DECIMAL(10, 2) DEFAULT NULL,
    expiry_date DATE,
    status ENUM('ACTIVE', 'EXPIRED', 'DISABLED') DEFAULT 'ACTIVE'
) ENGINE=InnoDB;

-- 12. Coupon usage table
CREATE TABLE coupon_usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_id INT NOT NULL,
    user_id INT NOT NULL,
    order_id INT NOT NULL,
    used_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
) ENGINE=InnoDB;


-- =====================================================================
-- SEED DATA
-- Default Passwords:
-- 'admin123' -> 240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9 (SHA-256)
-- 'customer123' -> b041c0aeb35bb0fa4aa668ca5a920b590196fdaf9a00eb852c9b7f4d123cc6d6 (SHA-256)
-- =====================================================================

INSERT INTO users (user_id, name, email, password, mobile, role, status) VALUES
(1, 'ShopSphere Admin', 'admin@shopsphere.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', '9876543210', 'ADMIN', 'ACTIVE'),
(2, 'Siddharth Singh', 'siddharth@example.com', 'b041c0aeb35bb0fa4aa668ca5a920b590196fdaf9a00eb852c9b7f4d123cc6d6', '9811223344', 'CUSTOMER', 'ACTIVE'),
(3, 'Priya Patel', 'priya@example.com', 'b041c0aeb35bb0fa4aa668ca5a920b590196fdaf9a00eb852c9b7f4d123cc6d6', '9822334455', 'CUSTOMER', 'ACTIVE');

INSERT INTO addresses (address_id, user_id, address_line, city, state, pincode, address_type) VALUES
(1, 2, 'Flat 402, Sunshine Apartments, MI Road', 'Jaipur', 'Rajasthan', '302001', 'HOME'),
(2, 2, 'Tech Park, Tower B, Malviya Nagar', 'Jaipur', 'Rajasthan', '302017', 'WORK'),
(3, 3, '12, Shanti Kunj, C-Scheme', 'Jaipur', 'Rajasthan', '302005', 'HOME');

INSERT INTO categories (category_id, name, description, status) VALUES
(1, 'Electronics', 'Laptops, smartphones, audio devices, and computer accessories', 'ACTIVE'),
(2, 'Fashion', 'Men and women apparel, footwear, and fashion accessories', 'ACTIVE'),
(3, 'Home & Kitchen', 'Home decor, kitchen appliances, and furnishings', 'ACTIVE'),
(4, 'Books & Stationery', 'Academic textbooks, novels, notebooks, and writing instruments', 'ACTIVE');

INSERT INTO products (product_id, category_id, name, brand, description, price, discount, stock, image_url, status) VALUES
(1, 1, 'Pro Wireless Noise Cancelling Headphones', 'SoundMaster', 'Premium over-ear wireless headphones with active noise cancellation and 40-hour battery life.', 4999.00, 10.00, 25, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80', 'ACTIVE'),
(2, 1, 'Ultra Slim Mechanical Gaming Keyboard', 'KeyTech', 'RGB backlit mechanical keyboard with tactile blue switches and aircraft-grade aluminum frame.', 3499.00, 15.00, 40, 'https://images.unsplash.com/photo-1587829741301-dc798b83add3?w=600&auto=format&fit=crop&q=80', 'ACTIVE'),
(3, 1, '27-inch 4K UHD IPS Designer Monitor', 'VisionPro', 'Crisp 4K display with 99% sRGB color gamut, HDR support, and USB-C connectivity.', 24999.00, 8.00, 12, 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=600&auto=format&fit=crop&q=80', 'ACTIVE'),
(4, 2, 'Classic Tailored Oxford Cotton Shirt', 'UrbanCraft', '100% breathable Egyptian cotton tailored shirt suitable for formal and casual styling.', 1499.00, 20.00, 50, 'https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?w=600&auto=format&fit=crop&q=80', 'ACTIVE'),
(5, 2, 'Heritage Leather Chronograph Watch', 'Timeless', 'Handcrafted genuine leather strap with stainless steel case and Japanese quartz movement.', 5999.00, 25.00, 18, 'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=600&auto=format&fit=crop&q=80', 'ACTIVE'),
(6, 3, 'Smart Programmable Espresso Coffee Maker', 'BrewMaster', '15-bar Italian pump with integrated milk frother and dual temperature control.', 8999.00, 12.00, 15, 'https://images.unsplash.com/photo-1517668808822-9ebb02f2a0e6?w=600&auto=format&fit=crop&q=80', 'ACTIVE'),
(7, 4, 'Advanced Java: Comprehensive Enterprise Guide', 'TechPress', 'Covers Servlets, JSP, JDBC, RMI, Sockets, and Java Swing for enterprise students.', 799.00, 5.00, 60, 'https://images.unsplash.com/photo-1532012164546-f432f2e3777f?w=600&auto=format&fit=crop&q=80', 'ACTIVE');

INSERT INTO coupons (coupon_id, code, discount_type, discount_value, minimum_order, maximum_discount, expiry_date, status) VALUES
(1, 'WELCOME10', 'PERCENTAGE', 10.00, 1000.00, 500.00, '2027-12-31', 'ACTIVE'),
(2, 'FESTIVE500', 'FIXED', 500.00, 3000.00, 500.00, '2027-12-31', 'ACTIVE');

INSERT INTO reviews (review_id, user_id, product_id, rating, review_text) VALUES
(1, 2, 1, 5, 'Outstanding sound quality and battery life. Perfect for study and travel!'),
(2, 3, 4, 4, 'Great fitting shirt and very comfortable fabric. Highly recommended.');
