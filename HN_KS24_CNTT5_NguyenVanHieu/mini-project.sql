create database mini_project_1;
use mini_project_1;

-- Câu 1
create table render(
	render_id int primary key auto_increment,
    render_name varchar(100) not null,
    phone varchar(15) unique,
    register_date date default(current_date())
);

create table book(
	book_id int primary key,
    book_title varchar(150) not null,
    author varchar(100),
    publish_year int check(publish_year >= 1900)
);

create table borrow(
	render_id int,
	book_id int,
	borrow_date date default(current_date()),
    return_date date,
	foreign key (render_id) references render (render_id),
	foreign key (book_id) references book (book_id)
);

-- Câu 2
alter table render add email varchar(100) unique;
alter table book modify author varchar(150) unique;
alter table borrow modify return_date date check(return_date >= borrow_date);

-- Câu 3
-- 1 thêm dữ liệu
insert into render (render_name,phone,email,register_date) values ('Nguyễn Văn An','0901234567','an.nguyen@gmail.com','2024-09-01');
insert into render (render_name,phone,email,register_date) values ('Trần Thị Bình','0912345678','binh.tran@gmail.com','2024-09-05');
insert into render (render_name,phone,email,register_date) values ('Lê Minh Châu','0923456789','chau.le@gmail.com','2024-09-10');

insert into book (book_id,book_title,author,publish_year) values (101,'Lập trình C căn bản','Nguyễn Văn A','2018');
insert into book (book_id,book_title,author,publish_year) values (102,'Cơ sở dữ liệu','Trần Thị B','2020');
insert into book (book_id,book_title,author,publish_year) values (103,'Lập trình Java','Lê Minh C','2019');
insert into book (book_id,book_title,author,publish_year) values (104,'Hệ quản trị MySQL','Phạm Văn D','2021');

insert into borrow (render_id,book_id,borrow_date,return_date) values ('1','101','2024-09-15',NULL);
insert into borrow (render_id,book_id,borrow_date,return_date) values ('1','101','2024-09-15','2024-09-25');
insert into borrow (render_id,book_id,borrow_date,return_date) values ('2','102','2024-09-18',NULL);

update borrow set return_date = '2024-10-01' where render_id = 1;



