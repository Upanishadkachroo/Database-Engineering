use bank_db;

-- Create an index on the customer email for faster searches
CREATE INDEX idx_customers_email ON customers(email);

-- Create an index on account number
CREATE INDEX idx_accounts_number ON accounts(account_number);

-- Useful when querying by branch and account type together
CREATE INDEX idx_accounts_branch_type 
ON accounts(branch_id, account_type_id);

-- Ensures uniqueness at the database level (alternative to UNIQUE constraint)
CREATE UNIQUE INDEX idx_unique_phone 
ON customers(phone);

-- Remove an index if no longer needed
DROP INDEX idx_customers_email ON customers;

DROP INDEX idx_accounts_branch_type ON accounts;

-- Search by email (will use idx_customers_email if exists)
SELECT * FROM customers WHERE email = 'rahul.sharma@example.com';

-- Search accounts by branch and account type (uses composite index)
SELECT * 
FROM accounts 
WHERE branch_id = 1 AND account_type_id = 2;
