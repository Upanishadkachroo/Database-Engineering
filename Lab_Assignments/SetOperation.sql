create database setoperation;
use setoperation;

CREATE TABLE Dept1 (
    empid INT PRIMARY KEY,
    name VARCHAR(50),
    role VARCHAR(50)
);

CREATE TABLE Dept2 (
    empid INT PRIMARY KEY,
    name VARCHAR(50),
    role VARCHAR(50)
);

-- Dept1
INSERT INTO Dept1 (empid, name, role) VALUES
(1, 'A', 'engineer'),
(2, 'B', 'salesman'),
(3, 'C', 'manager'),
(4, 'D', 'salesman'),
(5, 'E', 'engineer');

-- Dept2
INSERT INTO Dept2 (empid, name, role) VALUES
(3, 'C', 'manager'),
(6, 'F', 'marketing'),
(7, 'G', 'salesman');

-- Set Operation -rows are always distinct
-- list all the employees in the company
select * from Dept1
UNION
select * from Dept2;

-- list out all employees of the department who work as salesman
select * from Dept1 where role='salesman'
union
select * from Dept2 where role='salesman';

-- list out all the employees who work for both the department
-- Intersect
select * from Dept1 inner join Dept2 using(empid);

-- list out all employees in dept1 but not in dept2
-- Minus
select Dept1.* from Dept1 
left join Dept2 using(empid) where Dept2.empid is null;
