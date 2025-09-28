show databases;
use bank_db;

show tables;

-- Branches
CREATE TABLE IF NOT EXISTS branches (
  branch_id INT AUTO_INCREMENT PRIMARY KEY,
  branch_name VARCHAR(100) NOT NULL,
  address TEXT,
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50),
  zip VARCHAR(12),
  phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Customers
CREATE TABLE IF NOT EXISTS customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  dob DATE,
  gender ENUM('M','F','O') DEFAULT 'O',
  email VARCHAR(100) UNIQUE,
  phone VARCHAR(20) UNIQUE,
  address TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- Employees
CREATE TABLE IF NOT EXISTS employees (
  employee_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  branch_id INT NOT NULL,
  role VARCHAR(50),
  hire_date DATE,
  salary DECIMAL(12,2) DEFAULT 0.00,
  email VARCHAR(100) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_employees_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON UPDATE CASCADE ON DELETE RESTRICT,
  CONSTRAINT chk_employee_salary CHECK (salary >= 0)
) ENGINE=InnoDB;

-- Account types
CREATE TABLE IF NOT EXISTS account_types (
  account_type_id INT AUTO_INCREMENT PRIMARY KEY,
  type_name VARCHAR(50) NOT NULL UNIQUE,
  interest_rate DECIMAL(5,2) DEFAULT 0.00,
  min_balance DECIMAL(12,2) DEFAULT 0.00
) ENGINE=InnoDB;

-- Accounts
CREATE TABLE IF NOT EXISTS accounts (
  account_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  account_number VARCHAR(20) NOT NULL UNIQUE,
  customer_id INT NOT NULL,
  branch_id INT NOT NULL,
  account_type_id INT NOT NULL,
  balance DECIMAL(15,2) NOT NULL DEFAULT 0.00,
  opened_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status ENUM('ACTIVE','CLOSED','FROZEN') DEFAULT 'ACTIVE',
  CONSTRAINT fk_accounts_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_accounts_branch FOREIGN KEY (branch_id) REFERENCES branches(branch_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_accounts_type FOREIGN KEY (account_type_id) REFERENCES account_types(account_type_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT chk_accounts_balance CHECK (balance >= 0)
) ENGINE=InnoDB;

-- Transactions
CREATE TABLE IF NOT EXISTS transactions (
  transaction_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  account_id BIGINT NOT NULL,
  type ENUM('DEPOSIT','WITHDRAWAL','TRANSFER','FEE') NOT NULL,
  amount DECIMAL(15,2) NOT NULL,
  target_account_id BIGINT,
  transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  description VARCHAR(255),
  CONSTRAINT fk_transactions_account FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_transactions_target_account FOREIGN KEY (target_account_id) REFERENCES accounts(account_id) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT chk_transactions_amount CHECK (amount > 0)
) ENGINE=InnoDB;

-- Loans
CREATE TABLE IF NOT EXISTS loans (
  loan_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  account_id BIGINT NOT NULL,
  principal_amount DECIMAL(15,2) NOT NULL,
  interest_rate DECIMAL(5,2) NOT NULL,
  start_date DATE,
  end_date DATE,
  status ENUM('OPEN','CLOSED','DEFAULTED') DEFAULT 'OPEN',
  CONSTRAINT fk_loans_account FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT chk_loans_amount CHECK (principal_amount > 0)
) ENGINE=InnoDB;

-- Beneficiaries
CREATE TABLE IF NOT EXISTS beneficiaries (
  beneficiary_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  beneficiary_name VARCHAR(100) NOT NULL,
  beneficiary_account_number VARCHAR(20) NOT NULL,
  bank_name VARCHAR(100),
  added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_beneficiaries_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Cards (note: in production, do NOT store sensitive PAN/CVV in plaintext)
CREATE TABLE IF NOT EXISTS cards (
  card_id BIGINT AUTO_INCREMENT PRIMARY KEY,
  account_id BIGINT NOT NULL,
  card_number VARCHAR(19) NOT NULL UNIQUE,
  card_type ENUM('DEBIT','CREDIT') NOT NULL,
  expiry_date DATE,
  masked_card VARCHAR(19),
  issued_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  status ENUM('ACTIVE','BLOCKED','EXPIRED') DEFAULT 'ACTIVE',
  CONSTRAINT fk_cards_account FOREIGN KEY (account_id) REFERENCES accounts(account_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- Helpful indexes
CREATE INDEX idx_customers_email ON customers(email);
CREATE INDEX idx_accounts_customer ON accounts(customer_id);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);

-- End of schema


-- Insert into branches
INSERT INTO branches (branch_name, city, state, zip, phone)
VALUES ('Main Branch', 'Mumbai', 'Maharashtra', '400001', '022-12345678');

-- Insert into customers
INSERT INTO customers (first_name, last_name, dob, gender, email, phone, address)
VALUES ('Rahul', 'Sharma', '1990-05-12', 'M', 'rahul.sharma@example.com', '9876543210', 'Andheri, Mumbai');

-- Insert account type
INSERT INTO account_types (type_name, interest_rate, min_balance)
VALUES ('Savings', 3.50, 1000.00);

-- Insert account (uses FK: customer_id, branch_id, account_type_id)
INSERT INTO accounts (account_number, customer_id, branch_id, account_type_id, balance)
VALUES ('ACC1001', 1, 1, 1, 5000.00);

-- Insert transaction (uses FK: account_id)
INSERT INTO transactions (account_id, type, amount, description)
VALUES (1, 'DEPOSIT', 2000.00, 'Initial deposit');

-- Show all customers
SELECT * FROM customers;

-- Show all accounts with customer details (PK & FK join)
SELECT a.account_number, a.balance, c.first_name, c.last_name
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id;

-- Show all transactions with account number
SELECT t.transaction_id, t.type, t.amount, a.account_number
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id;

-- Check which branch an employee belongs to (PK-FK join)
SELECT e.first_name, e.last_name, b.branch_name
FROM employees e
JOIN branches b ON e.branch_id = b.branch_id;


