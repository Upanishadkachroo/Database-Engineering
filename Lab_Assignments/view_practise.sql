show databases;

use ORG;

show tables;

select * from Worker;

create view Emp_lastname AS
select First_Name, Last_Name
from Worker
where Last_Name='Arora';

select * from Emp_lastname;

create view Ammeer_emp AS
select First_Name, Last_Name, Salary
from Worker
where Salary>5000;

select * from Ammeer_emp;

UPDATE Ammeer_emp
SET Salary=11000
where First_Name="Monika";

DROP VIEW Ammeer_emp;
DROP VIEW Emp_lastname;