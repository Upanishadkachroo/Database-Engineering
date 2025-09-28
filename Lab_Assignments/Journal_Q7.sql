use bank_db;

-- Show customers with their accounts
SELECT c.customer_id, c.first_name, c.last_name, a.account_number, a.balance
FROM customers c
INNER JOIN accounts a ON c.customer_id = a.customer_id;

-- Show all customers and their accounts (if any)
SELECT c.customer_id, c.first_name, a.account_number, a.balance
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id;

-- Show all accounts and their customers (if customer deleted, account may still exist)
SELECT c.customer_id, c.first_name, a.account_number, a.balance
FROM customers c
RIGHT JOIN accounts a ON c.customer_id = a.customer_id;

-- Full outer join = LEFT JOIN + RIGHT JOIN
SELECT c.customer_id, c.first_name, a.account_number, a.balance
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
UNION
SELECT c.customer_id, c.first_name, a.account_number, a.balance
FROM customers c
RIGHT JOIN accounts a ON c.customer_id = a.customer_id;

-- If both customers and accounts have customer_id
SELECT *
FROM customers
NATURAL JOIN accounts;

-- Show transactions with account number, customer name, and branch
SELECT t.transaction_id, t.type, t.amount, a.account_number, c.first_name, b.branch_name
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
JOIN customers c ON a.customer_id = c.customer_id
JOIN branches b ON a.branch_id = b.branch_id;

