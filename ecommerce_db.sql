-- ============================================================
--  E-Commerce Platform Database
--  Full SQL Implementation
-- ============================================================

-- ============================================================
-- 1. CREATE & SELECT DATABASE
-- ============================================================
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- ============================================================
-- 2. CREATE TABLES
-- ============================================================

-- Categories (must be created before Products due to FK)
CREATE TABLE Categories (
    category_id   INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL,
    description   TEXT
);

-- Customers
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE NOT NULL,
    phone       VARCHAR(20),
    address     TEXT
);

-- Products
CREATE TABLE Products (
    product_id  INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(150) NOT NULL,
    price       DECIMAL(10, 2) NOT NULL,
    stock       INT DEFAULT 0,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

-- Orders
CREATE TABLE Orders (
    order_id     INT AUTO_INCREMENT PRIMARY KEY,
    customer_id  INT NOT NULL,
    order_date   DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- Order_Items (junction table between Orders and Products)
CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id      INT NOT NULL,
    product_id    INT NOT NULL,
    quantity      INT NOT NULL DEFAULT 1,
    price         DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id)   REFERENCES Orders(order_id)   ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);

-- Payments (1:1 with Orders)
CREATE TABLE Payments (
    payment_id     INT AUTO_INCREMENT PRIMARY KEY,
    order_id       INT UNIQUE NOT NULL,
    payment_date   DATETIME DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('Credit Card', 'Debit Card', 'PayPal', 'Cash on Delivery', 'Bank Transfer') NOT NULL,
    amount         DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ============================================================
-- 3. INSERT SAMPLE DATA
-- ============================================================

-- Categories
INSERT INTO Categories (category_name, description) VALUES
('Electronics','Phones, laptops, tablets'),
('Clothing','Fashion items'),
('Home & Kitchen','Appliances'),
('Books','All books'),
('Sports','Sports equipment'),
('Beauty','Cosmetics'),
('Automotive','Car tools'),
('Gaming','Video games'),
('Toys','Kids toys'),
('Music','Instruments');

-- Customers
INSERT INTO Customers (name, email, phone, address) VALUES
('Alice Johnson','alice@email.com','+1-555-0101','NY'),
('Bob Smith','bob@email.com','+1-555-0102','LA'),
('Carol White','carol@email.com','+1-555-0103','Chicago'),
('David Brown','david@email.com','+1-555-0104','Houston'),
('Eva Martinez','eva@email.com','+1-555-0105','Phoenix'),
('Frank Wilson','frank@email.com','+1-555-0106','PA'),
('Grace Lee','grace@email.com','+1-555-0107','TX'),
('Henry Taylor','henry@email.com','+1-555-0108','CA'),
('Ibrahim Traore','ibrahim@email.com','+226-70000001','Ouagadougou'),
('Fatou Diallo','fatou@email.com','+226-70000002','Bobo');

-- Products
INSERT INTO Products (name, price, stock, category_id) VALUES
('Samsung Galaxy S24',       799.99,  50,  1),
('Apple MacBook Air M2',    1099.99,  30,  1),
('Sony WH-1000XM5 Headphones', 299.99, 75, 1),
('LG 4K Smart TV 55"',       649.99,  20,  1),
('Running Jacket',            59.99, 120,  2),
('Yoga Pants',                39.99, 200,  2),
('Classic Sneakers',          89.99, 150,  2),
('Coffee Maker Deluxe',       79.99,  60,  3),
('Non-Stick Cookware Set',    99.99,  45,  3),
('The Pragmatic Programmer',  42.99, 100,  4),
('Clean Code',                38.99, 100,  4),
('Yoga Mat Premium',          29.99, 180,  5),
('Dumbbell Set 20kg',        119.99,  40,  5);

-- Orders
INSERT INTO Orders (customer_id, order_date, total_amount) VALUES
(1, '2024-01-05 10:23:00', 1099.99),
(1, '2024-02-14 14:00:00',  299.99),
(2, '2024-01-18 09:15:00',  799.99),
(3, '2024-02-02 16:45:00',  179.98),
(3, '2024-03-10 11:30:00',   42.99),
(4, '2024-03-20 08:55:00',  649.99),
(5, '2024-04-01 13:10:00',  149.98),
(6, '2024-04-15 17:00:00',  119.99),
(7, '2024-04-22 12:20:00',   81.98),
(8, '2024-05-05 10:05:00',  338.98);

-- Order_Items
INSERT INTO Order_Items (order_id, product_id, quantity, price) VALUES
(1,  2, 1, 1099.99),   -- Alice: MacBook
(2,  3, 1,  299.99),   -- Alice: Headphones
(3,  1, 1,  799.99),   -- Bob: Galaxy S24
(4,  5, 1,   59.99),   -- Carol: Running Jacket
(4,  7, 1,   89.99),   -- Carol: Sneakers
(4,  6, 1,   29.99),   -- Carol: Yoga Pants (using price at order time)
(5, 10, 1,   42.99),   -- Carol: Pragmatic Programmer
(6,  4, 1,  649.99),   -- David: LG TV
(7,  8, 1,   79.99),   -- Eva: Coffee Maker
(7,  9, 1,   69.99),   -- Eva: Cookware partial
(8, 13, 1,  119.99),   -- Frank: Dumbbell Set
(9, 12, 1,   29.99),   -- Grace: Yoga Mat
(9,  6, 1,   39.99),   -- Grace: Yoga Pants
(9, 11, 1,   11.99),   -- Grace: Clean Code
(10, 3, 1,  299.99),   -- Henry: Headphones
(10, 1, 1,   38.99);   -- Henry: Galaxy (partial)

-- Payments
INSERT INTO Payments (order_id, payment_date, payment_method, amount) VALUES
(1,  '2024-01-05 10:25:00', 'Credit Card',      1099.99),
(2,  '2024-02-14 14:02:00', 'PayPal',            299.99),
(3,  '2024-01-18 09:17:00', 'Debit Card',        799.99),
(4,  '2024-02-02 16:47:00', 'Credit Card',       179.98),
(5,  '2024-03-10 11:32:00', 'Bank Transfer',      42.99),
(6,  '2024-03-20 09:00:00', 'Credit Card',       649.99),
(7,  '2024-04-01 13:12:00', 'Cash on Delivery',  149.98),
(8,  '2024-04-15 17:03:00', 'Debit Card',        119.99),
(9,  '2024-04-22 12:22:00', 'PayPal',             81.98),
(10, '2024-05-05 10:08:00', 'Credit Card',       338.98);

-- ============================================================
-- 4. SELECT QUERIES
-- ============================================================

SELECT * FROM Products;

SELECT name, price FROM Products WHERE price > 100;

SELECT * FROM Products ORDER BY price DESC;

SELECT * FROM Products LIMIT 5;

SELECT * FROM Products WHERE price BETWEEN 50 AND 300;

SELECT * FROM Products WHERE category_id IN (1,2);

SELECT * FROM Products WHERE name LIKE '%Pro%';

-- ============================================================
-- 5. JOIN QUERIES
-- ============================================================

-- List all orders with customer names
SELECT
    c.name         AS customer_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC;

-- Full order details: customer → order → items → product
SELECT
    c.name              AS customer_name,
    o.order_id,
    p.name              AS product_name,
    oi.quantity,
    oi.price            AS unit_price,
    (oi.quantity * oi.price) AS line_total
FROM Customers c
JOIN Orders      o  ON c.customer_id  = o.customer_id
JOIN Order_Items oi ON o.order_id     = oi.order_id
JOIN Products    p  ON oi.product_id  = p.product_id
ORDER BY o.order_id, p.name;

-- Orders with payment method
SELECT
    o.order_id,
    c.name           AS customer_name,
    o.total_amount,
    pay.payment_method,
    pay.payment_date
FROM Orders o
JOIN Customers c  ON o.customer_id = c.customer_id
JOIN Payments pay ON o.order_id    = pay.order_id;

-- Products with their category names
SELECT
    p.product_id,
    p.name       AS product_name,
    p.price,
    p.stock,
    cat.category_name
FROM Products p
LEFT JOIN Categories cat ON p.category_id = cat.category_id;


-- 6. AGGREGATE FUNCTIONS
-- ============================================================

-- Total number of customers
SELECT COUNT(*) AS total_customers FROM Customers;

-- Average product price
SELECT ROUND(AVG(price), 2) AS avg_price FROM Products;

-- Total revenue (from payments)
SELECT SUM(amount) AS total_revenue FROM Payments;

-- Most expensive and cheapest product
SELECT
    MAX(price) AS most_expensive,
    MIN(price) AS cheapest
FROM Products;


SELECT AVG(price) FROM Products;


-- Number of products per category
SELECT
    cat.category_name,
    COUNT(p.product_id) AS product_count
FROM Categories cat
LEFT JOIN Products p ON cat.category_id = p.category_id
GROUP BY cat.category_name
ORDER BY product_count DESC;

-- Customers with more than 1 order
SELECT
    c.name,
    COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

-- Total spending per customer
SELECT
    c.name,
    SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

-- Revenue by payment method
SELECT
    payment_method,
    COUNT(*)        AS transactions,
    SUM(amount)     AS total_revenue
FROM Payments
GROUP BY payment_method
ORDER BY total_revenue DESC;


SELECT category_id, COUNT(*) FROM Products GROUP BY category_id;


SELECT customer_id, COUNT(*) FROM Orders
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- ============================================================
-- 7. ADVANCED QUERIES
-- ============================================================

-- Top 5 best-selling products (by quantity sold)
SELECT
    p.name,
    SUM(oi.quantity) AS total_sold
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC
LIMIT 5;

-- Products that have never been ordered (using LEFT JOIN)
SELECT p.name AS unsold_product
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

-- Customers who have never placed an order
SELECT c.name AS inactive_customer
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Monthly revenue report
SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    COUNT(*)                           AS total_orders,
    SUM(amount)                        AS monthly_revenue
FROM Payments
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY month;

-- Products low in stock (less than 50 units)
SELECT name, stock
FROM Products
WHERE stock < 50
ORDER BY stock ASC;

-- ============================================================
-- 8. UPDATE & DELETE EXAMPLES
-- ============================================================

UPDATE Products
SET price = 749.99
WHERE product_id = 1;

UPDATE Products
SET stock = stock + 100
WHERE product_id = 2;

UPDATE Customers
SET name = 'Updated Customer'
WHERE customer_id = 3;


-- DELETE examples

-- Delete a customer
DELETE FROM Customers WHERE customer_id = 10;

-- Delete an order
DELETE FROM Orders WHERE order_id = 9;


-- ============================================================
-- Referential Integrity Violation 
-- ============================================================

-- This query is EXPECTED TO FAIL
INSERT INTO Orders (customer_id, total_amount)
VALUES (999, 100);


-- ============================================================
--  END OF FILE
-- ============================================================
