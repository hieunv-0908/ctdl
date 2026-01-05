

CREATE DATABASE product_order_demo;
USE product_order_demo;

CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);



INSERT INTO products VALUES
(1, 'Laptop Dell', 20000000),
(2, 'iPhone 15', 25000000),
(3, 'Tai nghe Bluetooth', 1500000),
(4, 'Chuột không dây', 500000),
(5, 'Bàn phím cơ', 2000000);

INSERT INTO order_items VALUES
(101, 1, 1),
(101, 3, 2),
(102, 2, 1),
(102, 4, 3),
(103, 3, 5),
(104, 5, 2),
(105, 1, 1),
(105, 5, 1);

SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name;

SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity * p.price) AS total_revenue
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity * p.price) > 5000000
ORDER BY total_revenue DESC;
