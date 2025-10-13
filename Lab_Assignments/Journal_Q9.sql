use bank_db;

-- Create a simple view
-- View: Show all customers with their account numbers and balances
CREATE VIEW customer_accounts AS
SELECT c.customer_id, c.first_name, c.last_name, a.account_number, a.balance
FROM customers c
JOIN accounts a ON c.customer_id = a.customer_id;

-- Retrieve data from the view
SELECT * FROM customer_accounts;

-- Retrieve only customers with balance > 10000
SELECT * 
FROM customer_accounts
WHERE balance > 10000;

-- Increase balance of a specific account via view
UPDATE customer_accounts
SET balance = balance + 500
WHERE account_number = 'ACC1001';

-- Remove the view when no longer needed
DROP VIEW IF EXISTS customer_accounts;

-- View: Total balance per branch
CREATE VIEW branch_total_balance AS
SELECT b.branch_id, b.branch_name, SUM(a.balance) AS total_balance
FROM branches b
JOIN accounts a ON b.branch_id = a.branch_id
GROUP BY b.branch_id, b.branch_name;

-- Query the view
SELECT * FROM branch_total_balance;

-- Find branches with total balance > 50000
SELECT * FROM branch_total_balance
WHERE total_balance > 50000;

