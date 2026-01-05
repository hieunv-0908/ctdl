CREATE DATABASE ecommerce_report;
USE ecommerce_report;

CREATE TABLE products (
    product_id   INT PRIMARY KEY,
    product_name VARCHAR(255),
    price        DECIMAL(12,2)
);

CREATE TABLE orders (
    order_id    INT PRIMARY KEY,
    order_date  DATE,
    status      ENUM('pending', 'completed', 'cancelled')
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY,
    order_id      INT,
    product_id    INT,
    quantity      INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO products VALUES
(1, 'Laptop Dell',        20000000),
(2, 'iPhone 15',          25000000),
(3, 'Tai nghe Bluetooth', 1500000),
(4, 'Chuột không dây',     500000),
(5, 'Bàn phím cơ',        2000000);

INSERT INTO orders VALUES
(101, '2025-01-01', 'completed'),
(102, '2025-01-02', 'completed'),
(103, '2025-01-03', 'completed'),
(104, '2025-01-04', 'completed'),
(105, '2025-01-05', 'completed'),
(106, '2025-01-06', 'completed'),
(107, '2025-01-07', 'completed'),
(108, '2025-01-08', 'completed'),
(109, '2025-01-09', 'cancelled'),
(110, '2025-01-10', 'completed');



INSERT INTO order_items VALUES
(1, 101, 1, 3),
(2, 101, 3, 5),
(3, 102, 2, 2),
(4, 102, 3, 4),
(5, 103, 1, 4),
(6, 103, 5, 6),
(7, 104, 3, 10),
(8, 104, 4, 8),
(9, 105, 2, 3),
(10,105, 5, 5),
(11,106, 3, 7),
(12,106, 1, 2),
(13,107, 2, 4),
(14,107, 3, 6),
(15,108, 5, 10),
(16,110, 3, 8);


SELECT
    p.product_name AS ten_san_pham,
    SUM(oi.quantity) AS tong_so_luong_ban,
    SUM(oi.quantity * p.price) AS tong_doanh_thu,
    AVG(p.price) AS gia_ban_trung_binh
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.status = 'completed'
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) >= 10
ORDER BY tong_doanh_thu DESC
LIMIT 5;

