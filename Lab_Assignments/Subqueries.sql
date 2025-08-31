create database subqueries;
show tables;

use subqueries;

CREATE TABLE Employees (
    id INT PRIMARY KEY,
    fname VARCHAR(50) NOT NULL,
    lname VARCHAR(50) NOT NULL,
    Age INT CHECK (Age > 0),
    emailID VARCHAR(100) UNIQUE NOT NULL,
    PhoneNo VARCHAR(20),
    City VARCHAR(50)
);

CREATE TABLE Client (
    id INT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    age INT CHECK (age > 0),
    emailID VARCHAR(100) UNIQUE NOT NULL,
    PhoneNo VARCHAR(20),
    City VARCHAR(50),
    empID INT,
    FOREIGN KEY (empID) REFERENCES Employees(id)
);

CREATE TABLE Project (
    id INT PRIMARY KEY,
    empID INT,
    name VARCHAR(50) NOT NULL,
    startdate DATE,
    clientID INT,
    FOREIGN KEY (empID) REFERENCES Employees(id),
    FOREIGN KEY (clientID) REFERENCES Client(id)
);

INSERT INTO Employees (id, fname, lname, Age, emailID, PhoneNo, City) VALUES
(1, 'Aman',  'Proto',   32, 'aman@gmail.com',  '898',  'Delhi'),
(2, 'Yagya', 'Narayan', 44, 'yagya@gmail.com', '222',  'Palam'),
(3, 'Rahul', 'BD',      22, 'rahul@gmail.com', '444',  'Kolkata'),
(4, 'Jatin', 'Hermit',  31, 'jatin@gmail.com', '666',  'Raipur'),
(5, 'PK',    'Pandey',  21, 'pk@gmail.com',    '555',  'Jaipur');

INSERT INTO Client (id, first_name, last_name, age, emailID, PhoneNo, City, empID) VALUES
(1, 'Mac',     'Rogers',   47, 'mac@hotmail.com', '333',   'Kolkata',   3),
(2, 'Max',     'Poirier',  27, 'max@gmail.com',   '222',   'Kolkata',   3),
(3, 'Peter',   'Jain',     24, 'peter@abc.com',   '111',   'Delhi',     1),
(4, 'Sushant', 'Aggarwal', 23, 'sushant@yahoo.com','45454', 'Hyderabad', 5),
(5, 'Pratap',  'Singh',    36, 'p@xyz.com',       '777767','Mumbai',    2);

INSERT INTO Project (id, empID, name, startdate, clientID) VALUES
(1, 1, 'A', '2021-04-21', 3),
(2, 2, 'B', '2021-03-12', 1),
(3, 3, 'C', '2021-01-16', 5),
(4, 3, 'D', '2021-04-27', 2),
(5, 5, 'E', '2021-05-01', 4);

show tables;


-- Sub queries
-- where clause same table
-- employess with age > 30
select age, fname, lname from Employees where age > 30;
select * from Employees where age in (select age from Employees where age > 30);

-- where clause with different table
-- employee details working in more than 1 project
select * from Employees where id in (select empID from Project group by empID having count(empID)>1);

-- single value subquery
-- details of employee with age > avg(age)
select * from Employees where age > (select avg(age) from Employees);

-- from clause
-- select max age person whose first name contains 'a'
-- every derived table must have its alias
select max(age) from (select * from Employees where fname like '%a%') as temp;

-- corelated subquery
-- find 3rd oldest employee
select * from Employees e1 where 3 = (
       select count(e2.age) from Employees e2 where e2.age >= e1.age );
       
       
-- View
select * from Employees;

-- creating a view
create view custom_view as select fname, age from Employees;

select * from custom_view;

-- alter 
alter view custom_view as select fname, lnmae, age from Employees;

drop view if exists custom_view;
