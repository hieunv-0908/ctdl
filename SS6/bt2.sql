CREATE DATABASE quan_ly_ban_hang;
USE quan_ly_ban_hang;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    unit_price DECIMAL(10,2)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers (customer_name) VALUES
('Nguyễn Văn A'),
('Trần Thị B'),
('Lê Văn C');

INSERT INTO products (product_name, unit_price) VALUES
('Laptop', 15000000),
('Chuột', 200000),
('Bàn phím', 500000);

INSERT INTO orders (customer_id, order_date) VALUES
(1, '2024-01-01'),
(1, '2024-01-05'),
(2, '2024-01-10'),
(3, '2024-01-12');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 15000000),
(1, 2, 2, 200000),
(2, 3, 1, 500000),
(3, 1, 1, 15000000),
(3, 3, 2, 500000),
(4, 2, 3, 200000);

UPDATE orders o
JOIN (
    SELECT order_id, SUM(quantity * unit_price) AS total_amount
    FROM order_items
    GROUP BY order_id
) t ON o.order_id = t.order_id
SET o.total_amount = t.total_amount;

SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

SELECT c.customer_id, c.customer_name, MAX(o.total_amount) AS max_order_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

SELECT c.customer_id, c.customer_name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;