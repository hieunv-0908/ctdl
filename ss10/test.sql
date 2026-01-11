CREATE DATABASE IF NOT EXISTS practice_db;
USE practice_db;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100),
    email VARCHAR(100) unique,
    city VARCHAR(50)
);

CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_name VARCHAR(100),
    price DECIMAL(10,2),
    stock INT,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT,
    order_date DATE,
    status ENUM('pending','completed','cancelled'),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);	

INSERT INTO customers (full_name, email, city) VALUES
('Nguyen Van A','a@gmail.com','Ha Noi'),
('Tran Thi B','b@gmail.com','Hai Phong'),
('Le Van C','c@gmail.com','Da Nang'),
('Pham Thi D','d@gmail.com','TP HCM'),
('Hoang Van E','e@gmail.com','Can Tho');

INSERT INTO categories (category_name) VALUES
('Laptop'),
('Phone'),
('Tablet'),
('Accessory'),
('Monitor');

INSERT INTO products (product_name, price, stock, category_id) VALUES
('Laptop Dell',1500,10,1),
('Laptop HP',1400,8,1),
('iPhone 14',1200,15,2),
('Samsung S23',1100,12,2),
('iPad Air',900,7,3),
('Mouse Logitech',50,50,4),
('Keyboard Razer',120,30,4),
('LG Monitor 27"',400,6,5);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1,'2025-01-01','completed'),
(2,'2025-01-03','pending'),
(3,'2025-01-05','completed'),
(1,'2025-01-07','cancelled'),
(4,'2025-01-08','completed'),
(5,'2025-01-10','pending');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1,1,1),
(1,6,2),
(2,3,1),
(3,4,1),
(3,6,1),
(4,2,1),
(5,8,2),
(5,7,1),
(6,5,1);

-- create view view_product
-- as
-- select p.product_name,p.price,p.stock,c.category_name from products as p 
-- join categories as c on p.category_id = p.category_id;

alter view view_product
as 
select p.product_name,p.price,p.stock from products as p 
join categories as c on p.category_id = p.category_id;

create view order_date_fil as 
select * from orders as o where o.order_date between '2025-01-01' and '2025-01-05';

select * from order_date_fil;

DROP VIEW `practice_db`.`order_date_fil`
