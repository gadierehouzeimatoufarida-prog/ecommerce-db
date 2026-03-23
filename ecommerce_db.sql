-- ============================================================
--  E-Commerce Platform Database
--  Group 12 | CS27 – BIT | March 2026
-- ============================================================

-- ============================================================
-- 1. CREATE & SELECT DATABASE
-- ============================================================
CREATE DATABASE IF NOT EXISTS ecommerce_db;
USE ecommerce_db;

-- ============================================================
-- 2. DROP TABLES (reset propre — ordre important a cause des FK)
-- ============================================================
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Categories;
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================================
-- 3. CREATE TABLES
-- ============================================================

-- Categories
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

-- Order_Items
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
-- 4. INSERT SAMPLE DATA
-- ============================================================

-- Categories
INSERT INTO Categories (category_name, description) VALUES
('Electronics',   'Phones, laptops, tablets'),
('Clothing',      'Fashion items'),
('Home & Kitchen','Appliances'),
('Books',         'All books'),
('Sports',        'Sports equipment'),
('Beauty',        'Cosmetics'),
('Automotive',    'Car tools'),
('Gaming',        'Video games'),
('Toys',          'Kids toys'),
('Music',         'Instruments');

-- Customers
INSERT INTO Customers (name, email, phone, address) VALUES
('Alice Johnson', 'alice@email.com',  '+1-555-0101',   'NY'),
('Bob Smith',     'bob@email.com',    '+1-555-0102',   'LA'),
('Carol White',   'carol@email.com',  '+1-555-0103',   'Chicago'),
('David Brown',   'david@email.com',  '+1-555-0104',   'Houston'),
('Eva Martinez',  'eva@email.com',    '+1-555-0105',   'Phoenix'),
('Frank Wilson',  'frank@email.com',  '+1-555-0106',   'PA'),
('Grace Lee',     'grace@email.com',  '+1-555-0107',   'TX'),
('Henry Taylor',  'henry@email.com',  '+1-555-0108',   'CA'),
('Ibrahim Traore','ibrahim@email.com','+226-70000001', 'Ouagadougou'),
('Fatou Diallo',  'fatou@email.com',  '+226-70000002', 'Bobo');

-- Products
INSERT INTO Products (name, price, stock, category_id) VALUES
('Samsung Galaxy S24',          799.99,  50, 1),
('Apple MacBook Air M2',       1099.99,  30, 1),
('Sony WH-1000XM5 Headphones',  299.99,  75, 1),
('LG 4K Smart TV 55"',          649.99,  20, 1),
('Running Jacket',               59.99, 120, 2),
('Yoga Pants',                   39.99, 200, 2),
('Classic Sneakers',             89.99, 150, 2),
('Coffee Maker Deluxe',          79.99,  60, 3),
('Non-Stick Cookware Set',       99.99,  45, 3),
('The Pragmatic Programmer',     42.99, 100, 4),
('Clean Code',                   38.99, 100, 4),
('Yoga Mat Premium',             29.99, 180, 5),
('Dumbbell Set 20kg',           119.99,  40, 5);

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
(1,  2, 1, 1099.99),
(2,  3, 1,  299.99),
(3,  1, 1,  799.99),
(4,  5, 1,   59.99),
(4,  7, 1,   89.99),
(4,  6, 1,   29.99),
(5, 10, 1,   42.99),
(6,  4, 1,  649.99),
(7,  8, 1,   79.99),
(7,  9, 1,   69.99),
(8, 13, 1,  119.99),
(9, 12, 1,   29.99),
(9,  6, 1,   39.99),
(9, 11, 1,   11.99),
(10, 3, 1,  299.99),
(10, 1, 1,   38.99);

-- Payments
INSERT INTO Payments (order_id, payment_date, payment_method, amount) VALUES
(1,  '2024-01-05 10:25:00', 'Credit Card',     1099.99),
(2,  '2024-02-14 14:02:00', 'PayPal',           299.99),
(3,  '2024-01-18 09:17:00', 'Debit Card',       799.99),
(4,  '2024-02-02 16:47:00', 'Credit Card',      179.98),
(5,  '2024-03-10 11:32:00', 'Bank Transfer',     42.99),
(6,  '2024-03-20 09:00:00', 'Credit Card',      649.99),
(7,  '2024-04-01 13:12:00', 'Cash on Delivery', 149.98),
(8,  '2024-04-15 17:03:00', 'Debit Card',       119.99),
(9,  '2024-04-22 12:22:00', 'PayPal',            81.98),
(10, '2024-05-05 10:08:00', 'Credit Card',      338.98);

-- ============================================================
-- 5. SELECT QUERIES
-- ============================================================

SELECT * FROM Customers;

SELECT * FROM Products;

SELECT name, price FROM Products WHERE price > 100;

SELECT * FROM Products ORDER BY price DESC;

SELECT * FROM Products LIMIT 5;

SELECT * FROM Products WHERE price BETWEEN 50 AND 300;

SELECT * FROM Products WHERE category_id IN (1, 2);

SELECT * FROM Products WHERE name LIKE '%Pro%';

-- ============================================================
-- 6. JOIN QUERIES
-- ============================================================

-- Toutes les commandes avec le nom du client
SELECT
    c.name         AS customer_name,
    o.order_id,
    o.order_date,
    o.total_amount
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
ORDER BY o.order_date DESC;

-- Details complets : client, commande, produit
SELECT
    c.name                   AS customer_name,
    o.order_id,
    p.name                   AS product_name,
    oi.quantity,
    oi.price                 AS unit_price,
    (oi.quantity * oi.price) AS line_total
FROM Customers c
JOIN Orders      o  ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id    = oi.order_id
JOIN Products    p  ON oi.product_id = p.product_id
ORDER BY o.order_id, p.name;

-- Commandes avec methode de paiement
SELECT
    o.order_id,
    c.name            AS customer_name,
    o.total_amount,
    pay.payment_method,
    pay.payment_date
FROM Orders o
JOIN Customers c  ON o.customer_id = c.customer_id
JOIN Payments pay ON o.order_id    = pay.order_id;

-- Produits avec leur categorie
SELECT
    p.product_id,
    p.name            AS product_name,
    p.price,
    p.stock,
    cat.category_name
FROM Products p
LEFT JOIN Categories cat ON p.category_id = cat.category_id;

-- ============================================================
-- 7. AGGREGATE FUNCTIONS
-- ============================================================

SELECT COUNT(*) AS total_customers FROM Customers;

SELECT ROUND(AVG(price), 2) AS avg_price FROM Products;

SELECT SUM(amount) AS total_revenue FROM Payments;

SELECT MAX(price) AS most_expensive, MIN(price) AS cheapest FROM Products;

-- Nombre de produits par categorie
SELECT
    cat.category_name,
    COUNT(p.product_id) AS product_count
FROM Categories cat
LEFT JOIN Products p ON cat.category_id = p.category_id
GROUP BY cat.category_name
ORDER BY product_count DESC;

-- Clients avec plus d'une commande
SELECT
    c.name,
    COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 1
ORDER BY total_orders DESC;

-- Total depense par client
SELECT
    c.name,
    SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY total_spent DESC;

-- Revenue par methode de paiement
SELECT
    payment_method,
    COUNT(*)    AS transactions,
    SUM(amount) AS total_revenue
FROM Payments
GROUP BY payment_method
ORDER BY total_revenue DESC;

-- ============================================================
-- 8. ADVANCED QUERIES
-- ============================================================

-- Top 5 produits les plus vendus
SELECT
    p.name,
    SUM(oi.quantity) AS total_sold
FROM Products p
JOIN Order_Items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name
ORDER BY total_sold DESC
LIMIT 5;

-- Produits jamais commandes
SELECT p.name AS unsold_product
FROM Products p
LEFT JOIN Order_Items oi ON p.product_id = oi.product_id
WHERE oi.order_item_id IS NULL;

-- Clients sans aucune commande
SELECT c.name AS inactive_customer
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Revenue mensuel
SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    COUNT(*)                           AS total_orders,
    SUM(amount)                        AS monthly_revenue
FROM Payments
GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
ORDER BY month;

-- Produits avec stock faible (moins de 50 unites)
SELECT name, stock
FROM Products
WHERE stock < 50
ORDER BY stock ASC;

-- ============================================================
-- 9. UPDATE & DELETE
-- ============================================================

UPDATE Products SET price = 749.99      WHERE product_id = 1;
UPDATE Products SET stock = stock + 100 WHERE product_id = 2;
UPDATE Customers SET name = 'Updated Customer' WHERE customer_id = 3;

-- DELETE dans le bon ordre (order avant customer a cause du FK)
DELETE FROM Orders    WHERE order_id    = 9;
DELETE FROM Customers WHERE customer_id = 10;

-- ============================================================
-- 10. REFERENTIAL INTEGRITY TEST (POUR LA PRESENTATION)
-- ============================================================

-- STEP 1 : verifier que le client 999 n'existe pas
SELECT * FROM Customers WHERE customer_id = 999;
-- Resultat attendu : 0 lignes (vide)

-- STEP 2 : essayer d'inserer une commande pour ce client inexistant
-- Cette requete va ECHOUER intentionnellement
-- Erreur attendue : Error Code 1452
INSERT INTO Orders (customer_id, total_amount) VALUES (999, 100);

-- STEP 3 : version correcte avec un customer_id valide
INSERT INTO Orders (customer_id, total_amount) VALUES (1, 100.00);

-- ============================================================
--  END OF FILE
-- ============================================================
