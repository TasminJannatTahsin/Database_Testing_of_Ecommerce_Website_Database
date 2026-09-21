🛒 E-commerce Website Database Testing
📌 Introduction
This project focuses on Database Testing for an E-commerce Website Database using MySQL. The objective is to verify the accuracy, integrity, consistency, reliability, and correctness of data stored in the website's backend database.

The database represents a real-world e-commerce system containing modules such as users, addresses, categories, products, inventory, carts, orders, payments, shipments, coupons, reviews, wishlists, and notifications.

Testing is performed using SQL queries to validate database structure, relationships, constraints, calculations, data consistency, and real-world business rules.

🎯 Project Objectives
Verify database structure and table relationships.
Validate Primary Keys (PK) and Foreign Keys (FK).
Perform CRUD testing.
Test duplicate and unique data.
Verify different JOIN operations.
Validate aggregate functions such as COUNT(), SUM(), AVG(), MIN(), and MAX().
Validate order totals and payment amounts.
Perform data consistency testing.
Perform boundary-value testing.
Test GROUP BY and HAVING.
Validate real-world e-commerce business rules.
🗂️ Database Modules
Module	Main Tables
👤 User Management	users, addresses
📦 Product Management	categories, products, product_images, inventory
🛒 Shopping Cart	carts, cart_items
🧾 Order Management	orders, order_items
💳 Payment	payments
🚚 Shipping	shipments
🎟️ Coupon & Discount	coupons, order_coupons
⭐ Reviews	reviews
❤️ Wishlist	wishlists, wishlist_items
🔔 Notifications	notifications
🗃️ Database Tables
The project contains 18 tables:

users
addresses
categories
products
product_images
inventory
carts
cart_items
orders
order_items
payments
shipments
coupons
order_coupons
reviews
wishlists
wishlist_items
notifications
🧩 ER Diagram
🧩 ERDiagramEW.png

🔍 Database Testing Scope
1. CRUD Testing
CRUD means Create, Read, Update, Delete.

INSERT INTO products
(category_id, product_name, sku, price)
VALUES
(1, 'Test Product', 'TEST-001', 500.00);

SELECT * FROM products;

UPDATE products
SET price = 550.00
WHERE sku = 'TEST-001';

DELETE FROM products
WHERE sku = 'TEST-001';
2. Primary Key Testing
Verify that primary keys are unique and not NULL.

SELECT product_id, COUNT(*)
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;
Expected: No rows.

3. Foreign Key Testing
Verify that related records have valid parent records.

SELECT p.product_id, p.category_id
FROM products p
LEFT JOIN categories c
    ON p.category_id = c.category_id
WHERE c.category_id IS NULL;
Expected: No orphan products.

4. Duplicate Data Testing
Test unique fields such as email, phone, SKU, order number, coupon code, transaction ID, and tracking number.

SELECT sku, COUNT(*) AS duplicate_count
FROM products
GROUP BY sku
HAVING COUNT(*) > 1;
Expected: No rows.

5. JOIN Testing
SELECT
    o.order_number,
    u.first_name,
    u.last_name,
    o.total_amount
FROM orders o
JOIN users u
    ON o.user_id = u.user_id;
This verifies the relationship between customers and orders.

6. Aggregate Function Testing
SELECT
    COUNT(*) AS total_products,
    AVG(price) AS average_price,
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price
FROM products;
7. Order Total Validation
Defined header-level rule:

Total Amount = Subtotal - Discount + Shipping Cost + Tax

SELECT
    order_number,
    total_amount,
    (subtotal - discount_amount + shipping_cost + tax_amount)
        AS calculated_total
FROM orders
WHERE total_amount <>
      (subtotal - discount_amount + shipping_cost + tax_amount);
Expected: No rows.

If item-level discounts and order-level discounts are both used, define clearly whether they are cumulative to avoid double-counting.

8. Payment Validation
SELECT
    o.order_number,
    o.total_amount,
    p.amount AS payment_amount,
    p.payment_status
FROM orders o
JOIN payments p
    ON o.order_id = p.order_id
WHERE p.payment_status = 'Paid'
  AND p.amount <> o.total_amount;
Expected: No rows.

9. Data Consistency Testing
SELECT
    p.product_id,
    p.product_name,
    p.status,
    i.quantity
FROM products p
JOIN inventory i
    ON p.product_id = i.product_id
WHERE i.quantity = 0
  AND p.status = 'Active';
Expected: No rows if zero-stock products must be unavailable.

10. Boundary-Value Testing
Test values at, below, and above defined limits.

For a discount rule of 0–100%:

Value	Expected
-0.01	❌ Invalid
0	✅ Valid
0.01	✅ Valid
99.99	✅ Valid
100	✅ Valid
100.01	❌ Invalid
11. GROUP BY / HAVING Testing
SELECT
    user_id,
    COUNT(*) AS total_orders
FROM orders
GROUP BY user_id
HAVING COUNT(*) > 1;
This identifies customers with more than one order.

12. Real-World E-commerce Business-Rule Testing
Examples:

Products should not be sold when stock is unavailable.
Inventory should not be negative.
Order totals must be correctly calculated.
Paid amount should match the order amount where required.
Coupon eligibility must follow minimum-order requirements.
Discount percentages must remain within allowed limits.
Order items must reference valid products.
Reviews should follow the project's purchase/review policy.
Cancelled orders should follow the defined payment/refund process.
🧪 Testing Checklist
Test Area	Status
Database Structure Testing	✅
CRUD Testing	✅
Primary Key Testing	✅
Foreign Key Testing	✅
Duplicate Data Testing	✅
JOIN Testing	✅
Aggregate Function Testing	✅
Order Total Validation	✅
Payment Validation	✅
Data Consistency Testing	✅
Boundary-Value Testing	✅
GROUP BY / HAVING Testing	✅
Business-Rule Testing	✅
🛠️ Tools & Technologies
Tool	Purpose
MySQL	Database
MySQL Workbench	Database design and SQL execution
SQL	Database testing queries
ER Diagram	Database relationship visualization
GitHub	Version control and documentation
📁 Project Structure
Ecommerce_Website/
│
├── EcommerceSite/
│   └── Website source Dump files
│
├── ERDiagramEW.png
├── Ecommerce Website Database.docx 
└── README.md
🎯 Expected Outcome
After testing, the database should:

Maintain valid relationships between tables.
Prevent invalid and duplicate data.
Maintain accurate order and payment information.
Enforce defined constraints.
Preserve data consistency.
Follow e-commerce business rules.
Produce accurate query and aggregate results.
⭐ Conclusion
This project demonstrates practical MySQL database testing for a real-world e-commerce website. It covers database structure, CRUD operations, keys, relationships, calculations, constraints, data consistency, boundary values, grouped data, and business rules to help ensure that the backend database remains accurate, consistent, reliable, and logically correct.

👩‍💻 Project Type
Database Testing Project — E-commerce Website
Database: MySQL
Testing Approach: Manual SQL-based Database Testing

👩‍💻 Author:Tasmin Jannat Tahsin
