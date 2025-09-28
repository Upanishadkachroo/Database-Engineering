use bank_db;

-- Insert a new customer
INSERT INTO customers (first_name, last_name, dob, gender, email, phone, address)
VALUES ('Amit', 'Verma', '1985-07-20', 'M', 'amit.verma@example.com', '9123456780', 'Delhi');

-- Insert a new account for this customer
INSERT INTO accounts (account_number, customer_id, branch_id, account_type_id, balance)
VALUES ('ACC2001', 2, 1, 1, 15000.00);

-- Delete a customer (also deletes accounts via ON DELETE CASCADE)
DELETE FROM customers WHERE customer_id = 2;


-- Add a new column
ALTER TABLE customers ADD COLUMN pan_number VARCHAR(15) UNIQUE;

-- Modify column type
ALTER TABLE accounts MODIFY balance DECIMAL(18,2);

-- Drop a column
ALTER TABLE customers DROP COLUMN pan_number;


-- Increase balance for a specific account
UPDATE accounts SET balance = balance + 2000 WHERE account_number = 'ACC1001';

-- Change customer phone number
UPDATE customers SET phone = '9000012345' WHERE customer_id = 1;

-- Get all customers from Mumbai
SELECT * FROM customers WHERE address LIKE '%Mumbai%';

-- Get accounts with balance > 10,000
SELECT account_number, balance FROM accounts WHERE balance > 10000;

-- Get transactions above 5000
SELECT * FROM transactions WHERE amount > 5000;


