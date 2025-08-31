show databases;
use DBE;
show tables;

create database joins;
show tables;

use joins;

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

-- Inner join
-- enlist all employees ids,name along with project allocated to them
select e.id, e.fname, e.lname, p.id, p.name from Employees as e
inner join Project as p on p.id=e.id; 

-- fetch out all employee ids, names along with project allocated to them from jaipur with client working in hyderabad
select e.id, e.emailID, e.PhoneNo, c.first_name, c.last_name from Employees as e
inner join Client as c on e.ID = c.ID where e.City = 'Jaipur' and c.City = 'Hyderabad';


-- Left Join
-- Fetch out rach project allocated to each employee
 select * from Employees as e 
 left join Project as p on e.id=p.id;
 
SELECT e.id, e.fname, e.lname, p.id AS project_id, p.name AS project_name
FROM Employees e
LEFT JOIN Project p ON e.id = p.empID;

-- Right join
-- list out all the projects along with employees name and their respective allocated emailid
select p.id, p.name, e.id, e.fname, e.lname, e.emailID from Employees as e 
right join Project p on e.id=p.id;

-- Cross join
-- list out all possible combination of employee and projects that can exist
select e.fname, e.lname, p.id, p.name from Employees as e
cross join Project p;

