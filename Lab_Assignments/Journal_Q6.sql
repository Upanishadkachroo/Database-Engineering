use bank_db;

-- Convert customer names to uppercase
SELECT UPPER(first_name) AS fname, UPPER(last_name) AS lname FROM customers;

-- Get length of customer emails
SELECT email, LENGTH(email) AS email_length FROM customers;

-- Concatenate first and last name
SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM customers;

-- Find customers whose email ends with 'example.com'
SELECT * FROM customers WHERE email LIKE '%@example.com';

-- Total number of customers
SELECT COUNT(*) AS total_customers FROM customers;

-- Maximum balance among accounts
SELECT MAX(balance) AS highest_balance FROM accounts;

-- Average balance of all accounts
SELECT AVG(balance) AS average_balance FROM accounts;

-- Total deposits made in transactions
SELECT SUM(amount) AS total_deposits FROM transactions WHERE type='DEPOSIT';


-- Count number of accounts per branch
SELECT branch_id, COUNT(account_id) AS total_accounts
FROM accounts
GROUP BY branch_id;

-- Average balance per account type
SELECT account_type_id, AVG(balance) AS avg_balance
FROM accounts
GROUP BY account_type_id;


-- Show branches with more than 2 accounts
SELECT branch_id, COUNT(account_id) AS total_accounts
FROM accounts
GROUP BY branch_id
HAVING COUNT(account_id) > 2;

-- Show account types with average balance > 5000
SELECT account_type_id, AVG(balance) AS avg_balance
FROM accounts
GROUP BY account_type_id
HAVING AVG(balance) > 5000;


