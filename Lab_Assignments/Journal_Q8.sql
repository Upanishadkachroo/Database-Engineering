use bank_db;

-- Sample Nested Subqueries


-- Subquery in WHERE
SELECT first_name, last_name
FROM customers
WHERE customer_id IN (
-- Subquery: Select accounts with balance above average
SELECT customer_id FROM accounts
WHERE balance > (SELECT AVG(balance) FROM accounts) -- Nested Subquery
);


-- Subquery in SELECT
SELECT account_number,
(SELECT branch_name FROM branches b WHERE b.branch_id = a.branch_id) AS branch_name, -- Subquery in SELECT
balance
FROM accounts a;


-- Subquery in FROM (Derived Table)
SELECT b.branch_name, t.max_balance
FROM (
SELECT branch_id, MAX(balance) AS max_balance -- Derived Table Subquery
FROM accounts
GROUP BY branch_id
) t
JOIN branches b ON t.branch_id = b.branch_id;


-- Correlated Subquery
SELECT account_number, balance
FROM accounts a
WHERE balance > (
-- Correlated Subquery
SELECT AVG(balance)
FROM accounts
WHERE branch_id = a.branch_id
);


-- Set Operations


-- UNION
SELECT first_name, last_name FROM customers
UNION
SELECT first_name, last_name FROM employees;


-- UNION ALL
SELECT first_name, last_name FROM customers
UNION ALL
SELECT first_name, last_name FROM employees;


-- INTERSECT (simulate with INNER JOIN)
SELECT c.first_name, c.last_name
FROM customers c
INNER JOIN employees e
ON c.first_name = e.first_name AND c.last_name = e.last_name;


-- EXCEPT / MINUS (simulate with LEFT JOIN + NULL check)
SELECT c.first_name, c.last_name
FROM customers c
LEFT JOIN employees e
ON c.first_name = e.first_name AND c.last_name = e.last_name
WHERE e.employee_id IS NULL;