use bank_db;

-- Create a new database user
CREATE USER 'bank_user'@'localhost' IDENTIFIED BY 'password123';

-- Grant privileges to the user on bank_db
GRANT SELECT, INSERT, UPDATE, DELETE ON bank_db.* TO 'bank_user'@'localhost';

-- Revoke a privilege
REVOKE DELETE ON bank_db.* FROM 'bank_user'@'localhost';

-- Show user privileges
SHOW GRANTS FOR 'bank_user'@'localhost';



-- Start a transaction
START TRANSACTION;

-- Example: withdraw money
UPDATE accounts SET balance = balance - 1000 WHERE account_number = 'ACC1001';

-- Example: deposit money into another account
UPDATE accounts SET balance = balance + 1000 WHERE account_number = 'ACC1002';

-- Commit the transaction (make changes permanent)
COMMIT;

-- Rollback example (undo changes if something went wrong)
ROLLBACK;

-- Savepoint example (partial rollback)
START TRANSACTION;
UPDATE accounts SET balance = balance - 500 WHERE account_number = 'ACC1001';
SAVEPOINT deduct500;

UPDATE accounts SET balance = balance + 500 WHERE account_number = 'ACC1003';

-- If something fails, rollback to savepoint
ROLLBACK TO deduct500;

-- Commit the successful part
COMMIT;

