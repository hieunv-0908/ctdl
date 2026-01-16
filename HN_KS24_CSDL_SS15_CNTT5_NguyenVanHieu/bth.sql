/*
 * DATABASE SETUP - SESSION 15 EXAM
 * Database: StudentManagement
 */

DROP DATABASE IF EXISTS StudentManagement;
CREATE DATABASE StudentManagement;
USE StudentManagement;

-- =============================================
-- 1. TABLE STRUCTURE
-- =============================================

-- Table: Students
CREATE TABLE Students (
    StudentID CHAR(5) PRIMARY KEY,
    FullName VARCHAR(50) NOT NULL,
    TotalDebt DECIMAL(10,2) DEFAULT 0
);

-- Table: Subjects
CREATE TABLE Subjects (
    SubjectID CHAR(5) PRIMARY KEY,
    SubjectName VARCHAR(50) NOT NULL,
    Credits INT CHECK (Credits > 0)
);

-- Table: Grades
CREATE TABLE Grades (
    StudentID CHAR(5),
    SubjectID CHAR(5),
    Score DECIMAL(4,2) CHECK (Score BETWEEN 0 AND 10),
    PRIMARY KEY (StudentID, SubjectID),
    CONSTRAINT FK_Grades_Students FOREIGN KEY (StudentID) REFERENCES Students(StudentID),
    CONSTRAINT FK_Grades_Subjects FOREIGN KEY (SubjectID) REFERENCES Subjects(SubjectID)
);

-- Table: GradeLog
CREATE TABLE GradeLog (
    LogID INT PRIMARY KEY AUTO_INCREMENT,
    StudentID CHAR(5),
    OldScore DECIMAL(4,2),
    NewScore DECIMAL(4,2),
    ChangeDate DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- 2. SEED DATA
-- =============================================

-- Insert Students
INSERT INTO Students (StudentID, FullName, TotalDebt) VALUES 
('SV01', 'Ho Khanh Linh', 5000000),
('SV03', 'Tran Thi Khanh Huyen', 0);

-- Insert Subjects
INSERT INTO Subjects (SubjectID, SubjectName, Credits) VALUES 
('SB01', 'Co so du lieu', 3),
('SB02', 'Lap trinh Java', 4),
('SB03', 'Lap trinh C', 3);

-- Insert Grades
INSERT INTO Grades (StudentID, SubjectID, Score) VALUES 
('SV01', 'SB01', 8.5), -- Passed
('SV03', 'SB02', 3.0); -- Failed

-- End of File
-- Phan:A
-- c1
delimiter //
drop trigger tg_CheckScore;
create trigger tg_CheckScore  before insert
on Grades
for each row
begin
	if (new.score < 0) then
		set new.score = 0;
	elseif (new.score > 10) then
		set new.score = 10;
	end if;
end //
delimiter ;

insert into grades (StudentID,SubjectID,Score) value ('SV03','SB01',-8);

-- c2
start transaction;
insert into students (StudentID,FullName) value ('SV02','Ha Bich Ngoc');
update students set TotalDebt = 5000000.00;
commit;

-- Phan B:
-- c3

delimiter //

create trigger tg_LogGradeUpdate
after update on Grades
for each row
begin
    if old.Score <> new.Score then
        insert into GradeLog (
            StudentID,
            OldScore,
            NewScore,
            ChangeDate
        )
        values (
            old.StudentID,
            old.Score,
            new.Score,
            NOW()
        );
    end if;
end //

delimiter ;

-- c4
delimiter //

create procedure sp_PayTuition()
begin
    declare v_TotalDebt decimal(15,2);
    start transaction;
    update Students
    set TotalDebt = TotalDebt - 2000000
    where StudentID = 'SV01';
    select TotalDebt
    into v_TotalDebt
    from Students
    where StudentID = 'SV01';
    if v_TotalDebt < 0 then
        rollback;
    else
        commit;
    end if;
end //

delimiter ;
