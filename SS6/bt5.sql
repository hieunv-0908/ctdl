CREATE DATABASE customer_analysis_demo;
USE customer_analysis_demo;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(255)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(1, 'Nguyen Van An'),
(2, 'Tran Thi Binh'),
(3, 'Le Van Cuong'),
(4, 'Pham Thi Dao');

INSERT INTO products VALUES
(1, 'Laptop Dell', 20000000),
(2, 'iPhone 15', 25000000),
(3, 'Tai nghe Bluetooth', 1500000),
(4, 'Chuột không dây', 500000);

INSERT INTO orders VALUES
(101, 1, '2025-01-01', 'completed'),
(102, 1, '2025-01-05', 'completed'),
(103, 1, '2025-01-10', 'completed'),
(104, 2, '2025-01-03', 'completed'),
(105, 2, '2025-01-08', 'completed'),
(106, 3, '2025-01-02', 'completed');

INSERT INTO order_items VALUES
(101, 1, 1),
(101, 3, 2),
(102, 2, 1),
(103, 4, 4),
(104, 3, 3),
(105, 1, 1),
(105, 4, 2),
(106, 3, 1);

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.quantity * p.price) AS total_spent,
    AVG(oi.quantity * p.price) AS avg_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.customer_name
HAVING 
    COUNT(DISTINCT o.order_id) >= 3
    AND SUM(oi.quantity * p.price) > 10000000
ORDER BY total_spent DESC;
