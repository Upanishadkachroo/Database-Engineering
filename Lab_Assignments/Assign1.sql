show databases;
create database DBE;

use DBE;
show databases;

create table branch(
  branch_name varchar(50) primary key,
  branch_city varchar(50),
  assets decimal(12,2)
);

create table account(
   account_number int primary key,
   branch_name varchar(50),
   balance decimal(12,2),
   foreign key (branch_name) references branch(branch_name)
);

create table customer(
  customer_name varchar(50) primary key,
  customer_street varchar(50),
  customer_city varchar(50)
);

create table depositor(
   customer_name varchar(50),
   account_number int,
   primary key (customer_name, account_number),
   foreign key (account_number) references account(account_number),
   foreign key (customer_name) references customer(customer_name)
);

create table loan(
   loan_number int primary key,
   branch_name varchar(50),
   amount int,
   foreign key (branch_name) references branch(branch_name)
);

create table borrower(
   customer_name varchar(50),
   loan_number int,
   primary key (customer_name, loan_number),
   foreign key (customer_name) references customer(customer_name),
   foreign key (loan_number) references loan(loan_number)
);

show tables;

-- Branch
insert into branch (branch_name, branch_city, assets) values ('ICICI Bank', 'Vishrambag', 1000000.00);
INSERT INTO branch VALUES ('SBI_Pune', 'Pune', 5000000.00);
INSERT INTO branch VALUES ('SBI_Mumbai', 'Mumbai', 8000000.00);
INSERT INTO branch VALUES ('SBI_Delhi', 'Delhi', 6000000.00);

select * from branch;

-- Account
INSERT INTO account VALUES (101, 'SBI_Pune', 20000.50);
INSERT INTO account VALUES (102, 'SBI_Mumbai', 35000.75);
INSERT INTO account VALUES (103, 'SBI_Delhi', 15000.00);

select * from account;

-- Customer
INSERT INTO customer VALUES ('Rahul', 'MG Road', 'Pune');
INSERT INTO customer VALUES ('Sneha', 'Andheri', 'Mumbai');
INSERT INTO customer VALUES ('Amit', 'Karol Bagh', 'Delhi');

select * from customer;

-- Depositor (link customer to account)
INSERT INTO depositor VALUES ('Rahul', 101);
INSERT INTO depositor VALUES ('Sneha', 102);
INSERT INTO depositor VALUES ('Amit', 103);

select * from depositor;

-- Loan
INSERT INTO loan VALUES (201, 'SBI_Pune', 100000);
INSERT INTO loan VALUES (202, 'SBI_Mumbai', 200000);
INSERT INTO loan VALUES (203, 'SBI_Delhi', 150000);

select * from loan;

-- Borrower (link customer to loan)
INSERT INTO borrower VALUES ('Rahul', 201);
INSERT INTO borrower VALUES ('Sneha', 202);
INSERT INTO borrower VALUES ('Amit', 203);

select * from borrower;

-- get customers from pune
select * from customer where customer_city='Pune';

-- list of account in sbi_delhi branch 
select account_number, balance from account where branch_name='SBI_DELHI';
select * from branch where branch_name='SBI_Delhi';

-- update the balance of the account
update account set balance=balance+50000.00 where account_number=102;
select * from account where account_number=102;

-- delete from branch
delete from branch where branch_name='ICICI Bank';
select * from branch;

-- find all people either depositor or borrower
select customer_name from depositor union select customer_name from borrower;







