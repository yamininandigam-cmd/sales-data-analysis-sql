-- =========================
-- SALES DATA ANALYSIS PROJECT
-- =========================

CREATE DATABASE sales_analysis;

-----

USE sales_analysis;

-- 1. CREATE TABLES

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50),
    price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- =========================
-- 2. INSERT DATA
-- =========================

INSERT INTO customers VALUES
(1, 'Rahul', 'Delhi'),
(2, 'Anita', 'Mumbai'),
(3, 'Kiran', 'Bangalore');

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 60000),
(2, 'Phone', 'Electronics', 20000),
(3, 'Headphones', 'Accessories', 2000),
(4, 'Keyboard', 'Accessories', 1500);

INSERT INTO orders VALUES
(1, 1, '2024-01-10'),
(2, 2, '2024-01-12'),
(3, 1, '2024-02-05'),
(4, 3, '2024-02-20');

INSERT INTO order_details VALUES
(1, 1, 1, 1),
(2, 1, 3, 2),
(3, 2, 2, 1),
(4, 3, 1, 1),
(5, 3, 4, 1),
(6, 4, 2, 2);

-- =========================
-- 3. ANALYSIS QUERIES
-- =========================

-- Total Revenue
SELECT SUM(p.price * od.quantity) AS total_revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id;

-- Revenue by Category
SELECT p.category,
       SUM(p.price * od.quantity) AS revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.category;

-- Top Selling Products
SELECT p.product_name,
       SUM(od.quantity) AS total_sold
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

-- Customer Purchase Summary
SELECT c.customer_name,
       SUM(p.price * od.quantity) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
GROUP BY c.customer_name;

-- Subquery: Customers who spent more than average
SELECT customer_name, total_spent
FROM (
    SELECT c.customer_name,
           SUM(p.price * od.quantity) AS total_spent
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    GROUP BY c.customer_name
) t
WHERE total_spent > (
    SELECT AVG(total_spent)
    FROM (
        SELECT SUM(p.price * od.quantity) AS total_spent
        FROM customers c
        JOIN orders o ON c.customer_id = o.customer_id
        JOIN order_details od ON o.order_id = od.order_id
        JOIN products p ON od.product_id = p.product_id
        GROUP BY c.customer_name
    ) avg_table
);