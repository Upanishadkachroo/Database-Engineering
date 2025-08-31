show databases;
use DBE;
show tables;

create database LA1;
use LA1;
show tables;
CREATE TABLE Department (
    deptname    VARCHAR(50) PRIMARY KEY,
    building    VARCHAR(50) NOT NULL,
    budget      DECIMAL(12,2) CHECK (budget >= 0)
);

CREATE TABLE Course (
    courseid    INT PRIMARY KEY,
    title       VARCHAR(100) NOT NULL,
    deptname    VARCHAR(50),
    credits     INT CHECK (credits > 0),
    FOREIGN KEY (deptname) REFERENCES Department(deptname)
);

CREATE TABLE Instructor (
    ID          INT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL,
    deptname    VARCHAR(50),
    salary      DECIMAL(10,2) CHECK (salary > 0),
    FOREIGN KEY (deptname) REFERENCES Department(deptname)
);

CREATE TABLE Teaches (
    ID          INT,
    courseid    INT,
    PRIMARY KEY (ID, courseid),
    FOREIGN KEY (ID) REFERENCES Instructor(ID),
    FOREIGN KEY (courseid) REFERENCES Course(courseid)
);

CREATE TABLE Student (
    SID         INT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL,
    deptname    VARCHAR(50),
    Tot_credits INT DEFAULT 0,
    FOREIGN KEY (deptname) REFERENCES Department(deptname)
);
show tables;

CREATE TABLE Takes (
    SID         INT,
    courseid    INT,
    grade       CHAR(2),
    PRIMARY KEY (SID, courseid),
    FOREIGN KEY (SID) REFERENCES Student(SID),
    FOREIGN KEY (courseid) REFERENCES Course(courseid)
);


-- Insert Department
INSERT INTO Department VALUES ('CSE', 'Block-A', 500000);
INSERT INTO Department VALUES ('IT', 'Block-B', 300000);
INSERT INTO Department VALUES ('ECE', 'Block-C', 400000);

select * from Department;

-- Insert Courses
INSERT INTO Course VALUES (101, 'DBMS', 'CSE', 4);
INSERT INTO Course VALUES (102, 'Operating Systems', 'IT', 3);
INSERT INTO Course VALUES (103, 'Digital Electronics', 'ECE', 4);

-- Insert Instructors
INSERT INTO Instructor VALUES (1, 'Alice', 'CSE', 80000);
INSERT INTO Instructor VALUES (2, 'Bob', 'IT', 70000);
INSERT INTO Instructor VALUES (3, 'Charlie', 'ECE', 65000);

-- Insert Students
INSERT INTO Student VALUES (1001, 'Ravi', 'CSE', 20);
INSERT INTO Student VALUES (1002, 'Priya', 'IT', 15);
INSERT INTO Student VALUES (1003, 'Arjun', 'ECE', 10);

-- Insert Teaches
INSERT INTO Teaches VALUES (1, 101);
INSERT INTO Teaches VALUES (2, 102);
INSERT INTO Teaches VALUES (3, 103);

-- Insert Takes
INSERT INTO Takes VALUES (1001, 101, 'A');
INSERT INTO Takes VALUES (1002, 102, 'B');
INSERT INTO Takes VALUES (1003, 103, 'A');

-- Update
UPDATE Student SET Tot_credits = Tot_credits + 3 WHERE SID = 1001;

-- Select
SELECT * FROM Student;

show tables;
select * from Teaches;

-- String Functions
-- to uppercase the name and save them under uppercasecase column
select upper(name) as uppercasename from Student;

select * from Instructor;
select substr(name, 1, 3) as shortname from Instructor;

-- Ordering 
-- by default in ascending order
select * from Instructor order by salary desc;
select * from Instructor order by salary;

-- Find average salary per department
-- Uisng Group By and Having clause
select * from Instructor;
show tables;
select deptname, avg(salary) as avgsalary from Instructor group by deptname;

-- Departments having more than 1 instructor
select deptname, count(ID) as numinstructor from Instructor group by deptname having count(ID) > 1;

-- Select student who got grade 'A'
select * from Student;
select * from Takes;

select name from Student where SID in (select SID from Takes where grade = 'A');

-- Instructor who teaches courses in CSE
select name from Instructor where ID in (select ID from Teaches where courseid in (select courseid from Course where deptname = "CSE"));

-- Average salary of Instructor with deptname
select name, deptname, avg(salary) from Instructor group by deptname, name;

SELECT deptname, AvgSal
FROM (SELECT deptname, AVG(salary) AS AvgSal
      FROM Instructor
      GROUP BY deptname) AS DeptSalary;
      
      
-- Joins
-- Natural join Student and Takes
select * from Student natural join Takes;

-- left join: show all students even if they have not taken course
SELECT S.SID, S.name, T.courseid
FROM Student S LEFT OUTER JOIN Takes T
ON S.SID = T.SID;

-- Right join: show all courses even if student has not taked them
SELECT T.SID, C.courseid, C.title
FROM Student T RIGHT OUTER JOIN Takes K
ON T.SID = K.SID
RIGHT OUTER JOIN Course C
ON K.courseid = C.courseid;

