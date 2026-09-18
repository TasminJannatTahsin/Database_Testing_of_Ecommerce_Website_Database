-- ============================================================
-- E-COMMERCE DATABASE FOR DATABASE TESTING
-- MySQL 8.0+
-- ============================================================

DROP DATABASE IF EXISTS ecommerce_testing;
CREATE DATABASE ecommerce_testing
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE ecommerce_testing;

-- ============================================================
-- 1. USERS
-- ============================================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    user_type ENUM('Customer', 'Admin') NOT NULL DEFAULT 'Customer',
    status ENUM('Active', 'Inactive', 'Blocked') NOT NULL DEFAULT 'Active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP
);

-- ============================================================
-- 2. ADDRESSES
-- ============================================================
CREATE TABLE addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    address_type ENUM('Billing', 'Shipping', 'Both') NOT NULL DEFAULT 'Shipping',
    address_line VARCHAR(200) NOT NULL,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100),
    postal_code VARCHAR(20) NOT NULL,
    country VARCHAR(100) NOT NULL DEFAULT 'Bangladesh',
    is_default BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_addresses_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- 3. CATEGORIES
-- ============================================================
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(500),
    status ENUM('Active', 'Inactive') NOT NULL DEFAULT 'Active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 4. PRODUCTS
-- ============================================================
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    product_name VARCHAR(200) NOT NULL,
    sku VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    discount_percent DECIMAL(5,2) NOT NULL DEFAULT 0,
    status ENUM('Active', 'Inactive', 'Out of Stock')
        NOT NULL DEFAULT 'Active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_products_category
        FOREIGN KEY (category_id) REFERENCES categories(category_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT chk_product_price
        CHECK (price >= 0),

    CONSTRAINT chk_product_discount
        CHECK (discount_percent BETWEEN 0 AND 100)
);

-- ============================================================
-- 5. PRODUCT IMAGES
-- ============================================================
CREATE TABLE product_images (
    image_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    is_primary BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_product_images_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- 6. INVENTORY
-- ============================================================
CREATE TABLE inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL UNIQUE,
    quantity INT NOT NULL DEFAULT 0,
    reorder_level INT NOT NULL DEFAULT 10,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_inventory_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT chk_inventory_quantity
        CHECK (quantity >= 0),

    CONSTRAINT chk_reorder_level
        CHECK (reorder_level >= 0)
);

-- ============================================================
-- 7. CARTS
-- ============================================================
CREATE TABLE carts (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    status ENUM('Active', 'Abandoned', 'Converted')
        NOT NULL DEFAULT 'Active',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_carts_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- 8. CART ITEMS
-- ============================================================
CREATE TABLE cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_cart_items_cart
        FOREIGN KEY (cart_id) REFERENCES carts(cart_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_cart_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT uq_cart_product
        UNIQUE (cart_id, product_id),

    CONSTRAINT chk_cart_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_cart_unit_price
        CHECK (unit_price >= 0)
);

-- ============================================================
-- 9. ORDERS
-- ============================================================
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    shipping_address_id INT NOT NULL,
    billing_address_id INT,
    order_number VARCHAR(30) NOT NULL UNIQUE,
    order_status ENUM(
        'Pending',
        'Confirmed',
        'Processing',
        'Shipped',
        'Delivered',
        'Cancelled',
        'Returned'
    ) NOT NULL DEFAULT 'Pending',
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    shipping_cost DECIMAL(10,2) NOT NULL DEFAULT 0,
    tax_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    ordered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_orders_shipping_address
        FOREIGN KEY (shipping_address_id) REFERENCES addresses(address_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT fk_orders_billing_address
        FOREIGN KEY (billing_address_id) REFERENCES addresses(address_id)
        ON DELETE SET NULL ON UPDATE CASCADE,

    CONSTRAINT chk_order_amounts
        CHECK (
            subtotal >= 0
            AND discount_amount >= 0
            AND shipping_cost >= 0
            AND tax_amount >= 0
            AND total_amount >= 0
        )
);

-- ============================================================
-- 10. ORDER ITEMS
-- ============================================================
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    line_total DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT chk_order_item_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_order_item_prices
        CHECK (
            unit_price >= 0
            AND discount_amount >= 0
            AND line_total >= 0
        )
);

-- ============================================================
-- 11. PAYMENTS
-- ============================================================
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    payment_method ENUM(
        'Cash on Delivery',
        'Card',
        'Mobile Banking',
        'Bank Transfer'
    ) NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,
    amount DECIMAL(10,2) NOT NULL,
    payment_status ENUM(
        'Pending',
        'Paid',
        'Failed',
        'Refunded'
    ) NOT NULL DEFAULT 'Pending',
    paid_at DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payments_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT chk_payment_amount
        CHECK (amount >= 0)
);

-- ============================================================
-- 12. SHIPMENTS
-- ============================================================
CREATE TABLE shipments (
    shipment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    courier_name VARCHAR(100),
    tracking_number VARCHAR(100) UNIQUE,
    shipment_status ENUM(
        'Pending',
        'Packed',
        'Shipped',
        'In Transit',
        'Delivered',
        'Returned'
    ) NOT NULL DEFAULT 'Pending',
    shipped_at DATETIME,
    delivered_at DATETIME,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_shipments_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- 13. COUPONS
-- ============================================================
CREATE TABLE coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_code VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(300),
    discount_type ENUM('Percentage', 'Fixed') NOT NULL,
    discount_value DECIMAL(10,2) NOT NULL,
    minimum_order_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    usage_limit INT,
    used_count INT NOT NULL DEFAULT 0,
    start_date DATETIME NOT NULL,
    end_date DATETIME NOT NULL,
    status ENUM('Active', 'Inactive', 'Expired') NOT NULL DEFAULT 'Active',

    CONSTRAINT chk_coupon_discount
        CHECK (discount_value >= 0),

    CONSTRAINT chk_coupon_min_order
        CHECK (minimum_order_amount >= 0),

    CONSTRAINT chk_coupon_usage
        CHECK (
            used_count >= 0
            AND (usage_limit IS NULL OR usage_limit >= used_count)
        ),

    CONSTRAINT chk_coupon_dates
        CHECK (end_date > start_date)
);

-- ============================================================
-- 14. ORDER COUPONS
-- ============================================================
CREATE TABLE order_coupons (
    order_coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    coupon_id INT NOT NULL,
    discount_amount DECIMAL(10,2) NOT NULL,

    CONSTRAINT fk_order_coupons_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_order_coupons_coupon
        FOREIGN KEY (coupon_id) REFERENCES coupons(coupon_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,

    CONSTRAINT uq_order_coupon
        UNIQUE (order_id, coupon_id),

    CONSTRAINT chk_order_coupon_discount
        CHECK (discount_amount >= 0)
);

-- ============================================================
-- 15. REVIEWS
-- ============================================================
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    order_id INT,
    rating TINYINT NOT NULL,
    review_title VARCHAR(150),
    review_text TEXT,
    status ENUM('Pending', 'Approved', 'Rejected')
        NOT NULL DEFAULT 'Pending',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_reviews_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_reviews_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_reviews_order
        FOREIGN KEY (order_id) REFERENCES orders(order_id)
        ON DELETE SET NULL ON UPDATE CASCADE,

    CONSTRAINT uq_user_product_review
        UNIQUE (user_id, product_id),

    CONSTRAINT chk_review_rating
        CHECK (rating BETWEEN 1 AND 5)
);

-- ============================================================
-- 16. WISHLISTS
-- ============================================================
CREATE TABLE wishlists (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    wishlist_name VARCHAR(100) NOT NULL DEFAULT 'My Wishlist',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_wishlists_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- 17. WISHLIST ITEMS
-- ============================================================
CREATE TABLE wishlist_items (
    wishlist_item_id INT AUTO_INCREMENT PRIMARY KEY,
    wishlist_id INT NOT NULL,
    product_id INT NOT NULL,
    added_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_wishlist_items_wishlist
        FOREIGN KEY (wishlist_id) REFERENCES wishlists(wishlist_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT fk_wishlist_items_product
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON DELETE CASCADE ON UPDATE CASCADE,

    CONSTRAINT uq_wishlist_product
        UNIQUE (wishlist_id, product_id)
);

-- ============================================================
-- 18. NOTIFICATIONS
-- ============================================================
CREATE TABLE notifications (
    notification_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    notification_type VARCHAR(50) NOT NULL,
    reference_id INT,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    read_at DATETIME,
    status ENUM('Active', 'Archived') NOT NULL DEFAULT 'Active',

    CONSTRAINT fk_notifications_user
        FOREIGN KEY (user_id) REFERENCES users(user_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- USERS
INSERT INTO users
(first_name, last_name, email, password_hash, phone, user_type, status)
VALUES
('Tasmin', 'Tahsin', 'tasmin@example.com', 'HASH001', '01710000001', 'Customer', 'Active'),
('Rahim', 'Ahmed', 'rahim@example.com', 'HASH002', '01710000002', 'Customer', 'Active'),
('Nusrat', 'Jahan', 'nusrat@example.com', 'HASH003', '01710000003', 'Customer', 'Active'),
('Admin', 'User', 'admin@example.com', 'HASH004', '01710000004', 'Admin', 'Active'),
('Karim', 'Hasan', 'karim@example.com', 'HASH005', '01710000005', 'Customer', 'Inactive'),
 ('Mahia', 'Jannat', 'mahia@example.com', 'HASH006', '01710000006', 'Customer', 'Active'),

 ( 'Rahia', 'Akter', 'rahia@example.com', 'HASH007', '01710000007', 'Customer', 'Inactive'),
( 'Hasah', 'Sakeh', 'Hassah@example.com', 'HASH008', '01710000008', 'Customer', 'Active'),
 ( 'Nihal', 'Uddin', 'nihal@example.com', 'HASH009', '01710000009', 'Customer', 'Inactive'),
 ( 'Tonny', 'Begum', 'tonny@example.com', 'HASH010', '01710000010', 'Customer', 'Inactive'),
 ( 'Safin', 'Hasan', 'safin@example.com', 'HASH011', '01710000011', 'Customer', 'Active'),
 ( 'Sami', 'Kovir', 'sami@example.com', 'HASH012', '01710000012', 'Customer', 'Inactive'),
( 'Minhas', 'Rahman', 'minhas@example.com', 'HASH013', '01710000013', 'Customer', 'Active'),
 ( 'Abdullah', 'Antor', 'abdullah@example.com', 'HASH014', '01710000014', 'Customer', 'Inactive'),
 ( 'Kabir', 'Hossain', 'kabir@example.com', 'HASH015', '01710000015', 'Customer', 'Active'),
 ( 'Monir', 'Islam', 'monir@example.com', 'HASH016', '01710000016', 'Customer', 'Inactive'),
 ( 'Tamjid', 'Islam', 'tamjid@example.com', 'HASH017', '01710000017', 'Customer', 'Active'),
( 'Tamim', 'Hssas', 'tamim@example.com', 'HASH018', '01710000018', 'Customer', 'Inactive'),
 ( 'Tania', 'Jaman', 'tania@example.com', 'HASH019', '01710000019', 'Customer', 'Active'),
 ( 'Rafiq', 'Uddin', 'Rafiq@example.com', 'HASH020', '01710000020', 'Customer', 'Inactive');


-- ADDRESSES
INSERT INTO addresses
(user_id, address_type, address_line, city, state, postal_code, country, is_default)
VALUES
(1, 'Both', 'House 11/B, Road 5', 'Dhaka', 'Dhaka', '1207', 'Bangladesh', TRUE),
(2, 'Shipping', 'House 22, Road 10', 'Chittagong', 'Chattogram', '4000', 'Bangladesh', TRUE),
(3, 'Both', 'House 33, Road 3', 'Sylhet', 'Sylhet', '3100', 'Bangladesh', TRUE),
(4, 'Both', 'Office 10', 'Dhaka', 'Dhaka', '1212', 'Bangladesh', TRUE),
(5, 'Shipping', 'House 55', 'Rajshahi', 'Rajshahi', '6000', 'Bangladesh', TRUE),
(6, 'Both', 'House 12/A, Road 6', 'KHULNA', 'KHULNA', '1207', 'Bangladesh', TRUE),
(7, 'Shipping', 'House 12, Road 10', 'Chittagong', 'Chattogram', '4000', 'Bangladesh', TRUE),
(8, 'Both', 'House 23, Road 3', 'Sylhet', 'Sylhet', '3100', 'Bangladesh', TRUE),
(9, 'Both', 'Office 11', 'Dhaka', 'Dhaka', '1212', 'Bangladesh', TRUE),
(10, 'Shipping', 'House 75', 'Rajshahi', 'Rajshahi', '6000', 'Bangladesh', TRUE),
(11, 'Both', 'House 18/B, Road 8', 'Dhaka', 'Dhaka', '1207', 'Bangladesh', TRUE),
(12, 'Shipping', 'House 12, Road 10', 'Chittagong', 'Chattogram', '4000', 'Bangladesh', TRUE),
(13, 'Both', 'House 73, Road 13', 'Sylhet', 'Sylhet', '3100', 'Bangladesh', TRUE),
(14, 'Both', 'Office 110', 'Dhaka', 'Dhaka', '1212', 'Bangladesh', TRUE),
(15, 'Shipping', 'House 515', 'Rajshahi', 'Rajshahi', '6000', 'Bangladesh', TRUE),
(16, 'Both', 'House 111/B, Road 51', 'Dhaka', 'Dhaka', '1207', 'Bangladesh', TRUE),
(17, 'Shipping', 'House 212, Road 110', 'Chittagong', 'Chattogram', '4000', 'Bangladesh', TRUE),
(18, 'Both', 'House 313, Road 31', 'Sylhet', 'Sylhet', '3100', 'Bangladesh', TRUE),
(19, 'Both', 'Office 180', 'Dhaka', 'Dhaka', '1212', 'Bangladesh', TRUE),
(20, 'Shipping', 'House 155', 'Rajshahi', 'Rajshahi', '6000', 'Bangladesh', TRUE);




-- CATEGORIES
INSERT INTO categories (category_name, description)
VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Men and women clothing'),
('Books', 'Books and educational materials'),
('Home & Kitchen', 'Home and kitchen products'),
('Sports', 'Sports and fitness products');

-- PRODUCTS
INSERT INTO products
(category_id, product_name, sku, description, price, discount_percent, status)
VALUES
(1, 'Wireless Mouse', 'ELEC-001', '2.4GHz wireless mouse', 850.00, 5.00, 'Active'),
(1, 'Mechanical Keyboard', 'ELEC-002', 'RGB mechanical keyboard', 3500.00, 10.00, 'Active'),
(1, 'USB-C Cable', 'ELEC-003', 'Fast charging USB-C cable', 450.00, 0.00, 'Active'),
(2, 'Cotton T-Shirt', 'CLOT-001', 'Premium cotton t-shirt', 750.00, 5.00, 'Active'),
(2, 'Denim Jeans', 'CLOT-002', 'Regular fit denim jeans', 2200.00, 15.00, 'Active'),
(3, 'SQL for Beginners', 'BOOK-001', 'Database learning book', 650.00, 0.00, 'Active'),
(3, 'Software Testing Guide', 'BOOK-002', 'Manual and automation testing', 900.00, 10.00, 'Active'),
(4, 'Electric Kettle', 'HOME-001', '1.5 litre electric kettle', 1800.00, 8.00, 'Active'),
(5, 'Yoga Mat', 'SPRT-001', 'Non-slip exercise yoga mat', 1200.00, 5.00, 'Active'),
(5, 'Football', 'SPRT-002', 'Professional size football', 1100.00, 0.00, 'Out of Stock');

-- PRODUCT IMAGES
INSERT INTO product_images (product_id, image_url, is_primary)
VALUES
(1, 'https://example.com/images/mouse.jpg', TRUE),
(2, 'https://example.com/images/keyboard.jpg', TRUE),
(3, 'https://example.com/images/cable.jpg', TRUE),
(4, 'https://example.com/images/tshirt.jpg', TRUE),
(5, 'https://example.com/images/jeans.jpg', TRUE),
(6, 'https://example.com/images/sql-book.jpg', TRUE),
(7, 'https://example.com/images/testing-book.jpg', TRUE),
(8, 'https://example.com/images/kettle.jpg', TRUE),
(9, 'https://example.com/images/yoga-mat.jpg', TRUE),
(10, 'https://example.com/images/football.jpg', TRUE);

-- INVENTORY
INSERT INTO inventory (product_id, quantity, reorder_level)
VALUES
(1, 100, 10),
(2, 50, 10),
(3, 200, 20),
(4, 80, 10),
(5, 40, 5),
(6, 60, 10),
(7, 30, 5),
(8, 25, 5),
(9, 70, 10),
(10, 0, 5);

-- CARTS
INSERT INTO carts (user_id, status)
VALUES
(1, 'Active'),
(2, 'Active'),
(3, 'Abandoned');

-- CART ITEMS
INSERT INTO cart_items (cart_id, product_id, quantity, unit_price)
VALUES
(1, 1, 2, 850.00),
(1, 3, 1, 450.00),
(2, 4, 2, 750.00),
(3, 6, 1, 650.00);

-- ORDERS
INSERT INTO orders
(user_id, shipping_address_id, billing_address_id, order_number,
 order_status, subtotal, discount_amount, shipping_cost, tax_amount, total_amount)
VALUES
(1, 1, 1, 'ORD-10001', 'Delivered', 1700.00, 85.00, 60.00, 80.00, 1755.00),
(2, 2, 2, 'ORD-10002', 'Processing', 2950.00, 295.00, 80.00, 130.00, 2865.00),
(3, 3, 3, 'ORD-10003', 'Cancelled', 650.00, 0.00, 60.00, 32.50, 742.50);

-- ORDER ITEMS
INSERT INTO order_items
(order_id, product_id, quantity, unit_price, discount_amount, line_total)
VALUES
(1, 1, 2, 850.00, 85.00, 1615.00),
(2, 5, 1, 2200.00, 220.00, 1980.00),
(2, 4, 1, 750.00, 75.00, 675.00),
(3, 6, 1, 650.00, 0.00, 650.00);

-- PAYMENTS
INSERT INTO payments
(order_id, payment_method, transaction_id, amount, payment_status, paid_at)
VALUES
(1, 'Card', 'TXN-10001', 1755.00, 'Paid', CURRENT_TIMESTAMP),
(2, 'Mobile Banking', 'TXN-10002', 2865.00, 'Paid', CURRENT_TIMESTAMP),
(3, 'Cash on Delivery', NULL, 742.50, 'Failed', NULL);

-- SHIPMENTS
INSERT INTO shipments
(order_id, courier_name, tracking_number, shipment_status, shipped_at, delivered_at)
VALUES
(1, 'Pathao Courier', 'TRK-10001', 'Delivered',
 DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 5 DAY),
 DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 2 DAY)),
(2, 'Sundarban Courier', 'TRK-10002', 'In Transit',
 DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 1 DAY), NULL),
(3, NULL, NULL, 'Pending', NULL, NULL);

-- COUPONS
INSERT INTO coupons
(coupon_code, description, discount_type, discount_value,
 minimum_order_amount, usage_limit, used_count,
 start_date, end_date, status)
VALUES
('WELCOME10', '10 percent welcome discount', 'Percentage', 10.00,
 1000.00, 100, 5,
 DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 30 DAY),
 DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 60 DAY), 'Active'),

('SAVE500', '500 taka discount', 'Fixed', 500.00,
 3000.00, 50, 10,
 DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 10 DAY),
 DATE_ADD(CURRENT_TIMESTAMP, INTERVAL 20 DAY), 'Active'),

('OLD20', 'Expired test coupon', 'Percentage', 20.00,
 500.00, 20, 20,
 DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 60 DAY),
 DATE_SUB(CURRENT_TIMESTAMP, INTERVAL 30 DAY), 'Expired');

-- ORDER COUPONS
INSERT INTO order_coupons (order_id, coupon_id, discount_amount)
VALUES
(1, 1, 85.00),
(2, 2, 295.00);

-- REVIEWS
INSERT INTO reviews
(user_id, product_id, order_id, rating, review_title, review_text, status)
VALUES
(1, 1, 1, 5, 'Excellent Mouse', 'Very smooth and comfortable.', 'Approved'),
(2, 5, 2, 4, 'Good Jeans', 'Good quality and fitting.', 'Approved'),
(3, 6, 3, 3, 'Useful Book', 'Good for beginners.', 'Pending');

-- WISHLISTS
INSERT INTO wishlists (user_id, wishlist_name)
VALUES
(1, 'My Wishlist'),
(2, 'Favorite Products'),
(3, 'Books to Buy');

-- WISHLIST ITEMS
INSERT INTO wishlist_items (wishlist_id, product_id)
VALUES
(1, 2),
(1, 8),
(2, 5),
(2, 9),
(3, 7);

-- NOTIFICATIONS
INSERT INTO notifications
(user_id, title, message, notification_type, reference_id, is_read, read_at)
VALUES
(1, 'Order Delivered', 'Your order ORD-10001 has been delivered.',
 'Order', 1, TRUE, CURRENT_TIMESTAMP),
(2, 'Order Processing', 'Your order ORD-10002 is being processed.',
 'Order', 2, FALSE, NULL),
(3, 'Welcome', 'Welcome to our e-commerce website.',
 'System', NULL, FALSE, NULL);

-- ============================================================
-- BASIC VERIFICATION
-- ============================================================

SELECT 'Database created successfully' AS message;

SELECT TABLE_NAME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'ecommerce_testing'
ORDER BY TABLE_NAME;

-- ============================================================
-- END OF DATABASE SCRIPT
-- ============================================================
