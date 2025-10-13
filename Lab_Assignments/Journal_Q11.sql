use bank_db;

-- Trigger: Automatically record a log when a new account is created
CREATE TABLE account_log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    account_number VARCHAR(20),
    action VARCHAR(50),
    action_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER $$

CREATE TRIGGER trg_account_insert
AFTER INSERT ON accounts
FOR EACH ROW
BEGIN
    INSERT INTO account_log(account_number, action)
    VALUES (NEW.account_number, 'Account Created');
END $$

DELIMITER ;

-- Trigger: Record changes when account balance is updated
DELIMITER $$

CREATE TRIGGER trg_account_update
AFTER UPDATE ON accounts
FOR EACH ROW
BEGIN
    IF OLD.balance != NEW.balance THEN
        INSERT INTO account_log(account_number, action)
        VALUES (NEW.account_number, CONCAT('Balance updated from ', OLD.balance, ' to ', NEW.balance));
    END IF;
END $$

DELIMITER ;


-- Trigger: Record a log when an account is deleted
DELIMITER $$

CREATE TRIGGER trg_account_delete
BEFORE DELETE ON accounts
FOR EACH ROW
BEGIN
    INSERT INTO account_log(account_number, action)
    VALUES (OLD.account_number, 'Account Deleted');
END $$

DELIMITER ;


-- Insert new account
INSERT INTO accounts (account_number, customer_id, branch_id, account_type_id, balance)
VALUES ('ACC3001', 1, 1, 1, 1000);

-- Update balance
UPDATE accounts SET balance = balance + 500 WHERE account_number = 'ACC3001';

-- Delete account
DELETE FROM accounts WHERE account_number = 'ACC3001';

-- Check logs
SELECT * FROM account_log;

