show databases;
use DBE;

show tables;

-- where clause uses
select * from customer where customer_city='Mumbai';
select * from account where balance > 20000;

-- rename(alias)
select customer_name as customer_naam, customer_city as customer_cty from customer;
select c.customer_name, d.account_number from customer c, depositor d where c.customer_name = d.customer_name;

-- string operation using LIKE
select * from customer where customer_name LIKE 'R%';
select * from customer where customer_city LIKE '%i';
select * from customer where customer_street LIKE '%r%';

-- ORDER BY using DESC and ASC
select account_number, balance from account order by balance desc;
select customer_name, customer_city from customer order by customer_name asc;

-- where clause predicate using between, in & not
select * from account where balance between 1000 and 200000;
select * from customer where customer_city in('Mumbai', 'Delhi');
select * from customer where not customer_city = 'Delhi';

-- Customers who are both depositors and borrowers
-- SELECT customer_name FROM depositor INTERSECT SELECT customer_name FROM borrower; not supported in mysql
SELECT customer_name
FROM depositor
WHERE customer_name IN (SELECT customer_name FROM borrower);


-- Customers who are depositors but not borrowers
-- SELECT customer_name FROM depositor EXCEPT SELECT customer_name FROM borrower; not supported in mysql
SELECT customer_name
FROM depositor
WHERE customer_name NOT IN (SELECT customer_name FROM borrower);

-- tuples with null values
select * from account where balance is null;
select * from customer where customer_city is null;

-- aggregate functions
select sum(assets) as total_assets from branch;
select avg(balance) as avg_balance from account;
select max(amount) as max_amt from loan;
select count(*) as total_customer from customer;

-- using group by
-- total balance of each branch
select branch_name, sum(balance) as branch_balance from account group by branch_name;

-- number of counts per branch
select branch_name, count(*) as no_accounts from account group by branch_name;

-- Having clause
-- Branches with total balance greater than 50000
SELECT branch_name, SUM(balance) AS Total_Balance
FROM account 
GROUP BY branch_name
HAVING SUM(balance) > 50000;

-- Branches with more than 2 accounts
SELECT branch_name, COUNT(*) AS Accounts_Count
FROM account 
GROUP BY branch_name
HAVING COUNT(*) > 2;

-- Nested Subqueries
-- Customers having balance greater than average balance
SELECT customer_name 
FROM depositor d
WHERE d.account_number IN (
    SELECT account_number FROM account 
    WHERE balance > (SELECT AVG(balance) FROM account)
);

-- Find branches with maximum assets
SELECT branch_name 
FROM branch
WHERE assets = (SELECT MAX(assets) FROM branch);

-- Customers who have an account in 'SBI_Pune'
SELECT customer_name 
FROM depositor 
WHERE account_number IN (
    SELECT account_number FROM account WHERE branch_name = 'SBI_Pune'
);

-- Customers who have balance more than every customer of Pune branch
SELECT customer_name 
FROM depositor d 
WHERE d.account_number IN (
    SELECT account_number FROM account 
    WHERE balance > ALL (
        SELECT balance FROM account WHERE branch_name = 'SBI_Pune'
    )
);

-- Customers who have at least one account with balance greater than some account in Pune branch
SELECT customer_name 
FROM depositor d 
WHERE d.account_number IN (
    SELECT account_number FROM account 
    WHERE balance > SOME (
        SELECT balance FROM account WHERE branch_name = 'SBI_Pune'
    )
);



