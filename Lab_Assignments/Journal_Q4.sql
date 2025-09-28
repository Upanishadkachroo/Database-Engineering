use bank_db;

CREATE TABLE test_notnull (
    id INT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);
-- This will fail:
INSERT INTO test_notnull (id) VALUES (1);


CREATE TABLE test_default (
    id INT PRIMARY KEY,
    city VARCHAR(50) DEFAULT 'Mumbai'
);
INSERT INTO test_default (id) VALUES (1);
-- city will be 'Mumbai'


CREATE TABLE test_unique (
    id INT PRIMARY KEY,
    email VARCHAR(100) UNIQUE
);
-- This will fail (duplicate email):
INSERT INTO test_unique VALUES (1, 'abc@gmail.com');
INSERT INTO test_unique VALUES (2, 'abc@gmail.com');



CREATE TABLE test_pk (
    account_id INT PRIMARY KEY,
    account_number VARCHAR(20) UNIQUE NOT NULL
);


CREATE TABLE parent_branch (
    branch_id INT PRIMARY KEY,
    branch_name VARCHAR(50) NOT NULL
);

CREATE TABLE child_employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    branch_id INT,
    FOREIGN KEY (branch_id) REFERENCES parent_branch(branch_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE test_check (
    id INT PRIMARY KEY,
    salary DECIMAL(10,2) CHECK (salary >= 0)
);
-- This will fail:
INSERT INTO test_check VALUES (1, -5000);
