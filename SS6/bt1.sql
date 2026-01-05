CREATE DATABASE customer_order_demo;
USE customer_order_demo;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,        
    full_name   VARCHAR(255),           
    city        VARCHAR(255)             
);
CREATE TABLE orders (
    order_id    INT PRIMARY KEY,         
    customer_id INT,                      
    order_date  DATE,                    
    status      ENUM('pending', 'completed', 'cancelled'),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO customers VALUES
(1, 'Nguyen Van An', 'Ha Noi'),
(2, 'Tran Thi Binh', 'Da Nang'),
(3, 'Le Van Cuong', 'Ho Chi Minh'),
(4, 'Pham Thi Dao', 'Ha Noi'),
(5, 'Hoang Van Em', 'Can Tho');

INSERT INTO orders VALUES
(101, 1, '2025-01-01', 'completed'),
(102, 1, '2025-01-03', 'pending'),
(103, 2, '2025-01-05', 'completed'),
(104, 3, '2025-01-06', 'cancelled'),
(105, 3, '2025-01-07', 'completed'),
(106, 3, '2025-01-08', 'completed'),
(107, 4, '2025-01-09', 'pending');


SELECT
    o.order_id,
    c.full_name AS ten_khach_hang,
    o.order_date,
    o.status
FROM orders o
JOIN customers c
    ON o.customer_id = c.customer_id;

SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS so_don_hang
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name;


SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS so_don_hang
FROM customers c
JOIN orders o
    ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
HAVING COUNT(o.order_id) >= 1;

