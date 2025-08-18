use DBE;
show tables;

-- query using exists clause
-- Find customers who have at least one account
select customer_name from customer c where exists (
	    select 1
        from depositor d
        where d.customer_name = c.customer_name
);

-- Find branches with their total balance
select branch_name, total_balance from (
       select branch_name, sum(balance) as total_balance
       from account 
       group by branch_name
) as branch_balance where total_balance > 40000;


-- Display each account with the average balance of all accounts
select account_number, balance, (select avg(balance) from account) as avg_balance from account;

-- Update: Increase loan amount by 10% for branch 'SBI_Pune'
UPDATE loan 
SET amount = amount * 1.10 
WHERE branch_name = 'SBI_Pune';

-- cartesian product
select * from customer, account;

-- Natural join
select * from depositor natural join account;

-- join using where
SELECT c.customer_name, a.account_number, a.balance FROM customer c, depositor d, account a
WHERE c.customer_name = d.customer_name AND d.account_number = a.account_number;

-- join using on
SELECT c.customer_name, a.account_number, a.balance
FROM customer c 
JOIN depositor d ON c.customer_name = d.customer_name
JOIN account a ON d.account_number = a.account_number;

-- join using using
SELECT customer_name, account_number, balance
FROM depositor 
JOIN account USING (account_number);

-- Left Outer Join
SELECT c.customer_name, d.account_number
FROM customer c
LEFT JOIN depositor d ON c.customer_name = d.customer_name;

-- Right Outer Join
SELECT c.customer_name, d.account_number
FROM customer c
RIGHT JOIN depositor d ON c.customer_name = d.customer_name;

-- Full Outer Join
SELECT c.customer_name, d.account_number
FROM customer c
LEFT JOIN depositor d ON c.customer_name = d.customer_name
UNION
SELECT c.customer_name, d.account_number
FROM customer c
RIGHT JOIN depositor d ON c.customer_name = d.customer_name;

-- Create View
CREATE VIEW customer_accounts AS
SELECT c.customer_name, a.account_number, a.balance
FROM customer c 
JOIN depositor d ON c.customer_name = d.customer_name
JOIN account a ON d.account_number = a.account_number;

-- Update View
UPDATE customer_accounts 
SET balance = balance + 1000 
WHERE customer_name = 'Rahul';

-- table with date,time, timestamp
CREATE TABLE transaction (
    txn_id INT PRIMARY KEY,
    account_number INT,
    txn_date DATE,
    txn_time TIME,
    txn_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2),
    FOREIGN KEY (account_number) REFERENCES account(account_number)
);

select * from transaction;


-- Create index on customer name for faster search
CREATE INDEX idx_customer_name ON customer(customer_name);

-- Unique index on account_number (though it’s already PK)
CREATE UNIQUE INDEX idx_account_number ON account(account_number);


-- integrity constraints
CREATE TABLE branch (
    branch_name VARCHAR(50) PRIMARY KEY,
    branch_city VARCHAR(50) NOT NULL,
    assets DECIMAL(15,2) CHECK (assets >= 0),
    UNIQUE (branch_name)
);

CREATE TABLE account (
    account_number INT PRIMARY KEY,
    branch_name VARCHAR(50) NOT NULL,
    balance DECIMAL(12,2) CHECK (balance >= 0),
    FOREIGN KEY (branch_name) REFERENCES branch(branch_name)
);






