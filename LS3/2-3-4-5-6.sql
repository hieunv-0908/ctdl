-- Tạo bảng Student
CREATE TABLE Student (
    student_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    date_of_birth DATE,
    email VARCHAR(100) UNIQUE
);

-- Thêm dữ liệu (ít nhất 3 sinh viên)
INSERT INTO Student (student_id, full_name, date_of_birth, email) VALUES
(1, 'Nguyen Van A', '2002-05-10', 'nguyenvana@gmail.com'),
(2, 'Tran Thi B', '2001-09-21', 'tranthib@gmail.com'),
(3, 'Le Van C', '2003-01-15', 'levanc@gmail.com');

-- Lấy toàn bộ danh sách sinh viên
SELECT * FROM Student;

-- Lấy mã sinh viên và họ tên của tất cả sinh viên
SELECT student_id, full_name FROM Student;

-- Cập nhật email cho một sinh viên cụ thể (ví dụ student_id = 1)
UPDATE Student
SET email = 'nguyenvana_new@gmail.com'
WHERE student_id = 1;

-- Cập nhật email cho sinh viên có student_id = 3
UPDATE Student
SET email = 'levanc_new@gmail.com'
WHERE student_id = 3;

-- Cập nhật ngày sinh cho một sinh viên khác (ví dụ student_id = 4)
UPDATE Student
SET date_of_birth = '2000-12-01'
WHERE student_id = 4;

-- Cập nhật ngày sinh cho sinh viên có student_id = 2
UPDATE Student
SET date_of_birth = '2001-08-20'
WHERE student_id = 2;

-- Xóa một sinh viên đã nhập nhầm (student_id = 5)
DELETE FROM Student
WHERE student_id = 5;

-- Kiểm tra lại dữ liệu: lấy tất cả sinh viên sau khi cập nhật và xóa
SELECT * FROM Student;

-- Tạo bảng Subject với ràng buộc dữ liệu
CREATE TABLE Subject (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(100) NOT NULL,
    credit INT CHECK (credit > 0)
);

-- Thêm dữ liệu cho các môn học
INSERT INTO Subject (subject_id, subject_name, credit) VALUES
(1, 'Cơ sở dữ liệu', 3),
(2, 'Lập trình C', 4),
(3, 'Cấu trúc dữ liệu và giải thuật', 3);

-- Cập nhật số tín chỉ cho một môn học (ví dụ: subject_id = 2)
UPDATE Subject
SET credit = 5
WHERE subject_id = 2;

-- Đổi tên một môn học (ví dụ: subject_id = 3)
UPDATE Subject
SET subject_name = 'CTDL & GT'
WHERE subject_id = 3;

-- Kiểm tra dữ liệu sau khi cập nhật
SELECT * FROM Subject;

-- Tạo bảng Enrollment với khóa ngoại và ràng buộc không đăng ký trùng
CREATE TABLE Enrollment (
    student_id INT,
    subject_id INT,
    enroll_date DATE NOT NULL,
    PRIMARY KEY (student_id, subject_id), -- không cho trùng môn với cùng sinh viên
    FOREIGN KEY (student_id) REFERENCES Student(student_id),
    FOREIGN KEY (subject_id) REFERENCES Subject(subject_id)
);

-- Thêm dữ liệu đăng ký môn học cho ít nhất 2 sinh viên
INSERT INTO Enrollment (student_id, subject_id, enroll_date) VALUES
(1, 1, '2024-09-01'),
(1, 2, '2024-09-02'),
(2, 1, '2024-09-01'),
(2, 3, '2024-09-03');

-- Lấy ra tất cả các lượt đăng ký
SELECT * FROM Enrollment;

-- Lấy ra các lượt đăng ký của một sinh viên cụ thể (ví dụ: student_id = 1)
SELECT *
FROM Enrollment
WHERE student_id = 1;
