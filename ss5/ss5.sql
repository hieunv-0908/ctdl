create database ls4;

create table products (
	productId int,
    productName varchar(255),
	price decimal(10,2),
    stock int,
    status enum('active','inactive')
);

create table customers (
	customerId int,
    full_name varchar(255),
    email varchar(255),
    city varchar(255),
    status enum('active','inactive')
);

create table orders (
	orderId int,
    customerId int,
    total_amount decimal(10,2),
    order_date date,
    status enum('pending','completed','cancelled')
);

insert into products (productId,productName, price, stock, status) value (01, 'BanhMi', 5.2, 20, 'active');

INSERT INTO products (productId, productName, price, stock, status)
VALUES (02, 'SuaTuoi', 12.5, 50, 'active');

INSERT INTO products (productId, productName, price, stock, status)
VALUES (03, 'BanhQuy', 8.0, 30, 'active');

INSERT INTO products (productId, productName, price, stock, status)
VALUES (04, 'NuocNgot', 10.0, 100, 'active');

INSERT INTO products (productId, productName, price, stock, status)
VALUES (05, 'MiGoi', 4.5, 200, 'active');

INSERT INTO products (productId, productName, price, stock, status)
VALUES (06, 'CaPhe', 15.0, 40, 'inactive');


insert into customers (customerId,full_name,email,city,status) value ('01','khachA','a@gmail.com','HaNoi','active');

INSERT INTO customers (customerId, full_name, email, city, status)
VALUES ('02', 'khachB', 'b@gmail.com', 'HaiPhong', 'active');

INSERT INTO customers (customerId, full_name, email, city, status)
VALUES ('03', 'khachC', 'c@gmail.com', 'DaNang', 'active');

INSERT INTO customers (customerId, full_name, email, city, status)
VALUES ('04', 'khachD', 'd@gmail.com', 'HoChiMinh', 'inactive');

INSERT INTO customers (customerId, full_name, email, city, status)
VALUES ('05', 'khachE', 'e@gmail.com', 'CanTho', 'active');

INSERT INTO customers (customerId, full_name, email, city, status)
VALUES ('06', 'khachF', 'f@gmail.com', 'Hue', 'active');

insert into orders (orderId,customerId,total_amount,order_date,status) value (1,2,5000,'2026-01-01','pending');

INSERT INTO orders (orderId, customerId, total_amount, order_date, status)
VALUES (02, 03, 120000, '2026-01-02', 'completed');

INSERT INTO orders (orderId, customerId, total_amount, order_date, status)
VALUES (03, 01, 75000, '2026-01-03', 'pending');

INSERT INTO orders (orderId, customerId, total_amount, order_date, status)
VALUES (04, 04, 200000, '2026-01-04', 'cancelled');

INSERT INTO orders (orderId, customerId, total_amount, order_date, status)
VALUES (05, 05, 95000, '2026-01-05', 'completed');

INSERT INTO orders (orderId, customerId, total_amount, order_date, status)
VALUES (06, 02, 60000, '2026-01-06', 'pending');

INSERT INTO orders (orderId, customerId, total_amount, order_date, status)
VALUES (07, 06, 180000, '2026/01/07', 'completed');


select * from products;
select * from products where status = 'active';
select * from products where price > 10;
select * from products where status = 'active' order by price ASC;

select * from customers;
select * from customers where city = 'HoChiMinh';
select * from customers where city = 'HaNoi' AND status = 'active';
select * from customers order by full_name ASC;

select * from orders where status = 'completed';
select * from orders where total_amount > 5000000;
select * from orders where status = 'completed' order by total_amount asc;

select * from products order by sold_quantity asc limit 10;
select * from products order by sold_quantity asc limit 5 offset 10;
	
SELECT * FROM products WHERE price < 2000000 ORDER BY sold_quantity DESC;

SELECT *
FROM orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 0;

SELECT *
FROM orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 5;

SELECT *
FROM orders
WHERE status <> 'cancelled'
ORDER BY order_date DESC
LIMIT 5 OFFSET 10;


alter table products
add column sold_quantity int;

