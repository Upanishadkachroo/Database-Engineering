-- ================================================================
-- SQL PRACTICE SET (about 30 questions + ready-to-run queries)
-- Databases: university (main) and bank (for transactions & triggers)
-- SQL dialect: MySQL-compatible (adjust minor syntax if using other RDBMS)
-- Copy-paste each block into your mysql / mongosh client as needed.
-- ================================================================

/* =========================
   0. CREATE DATABASES
   ========================= */
CREATE DATABASE IF NOT EXISTS university;
USE university;

CREATE DATABASE IF NOT EXISTS bank;
-- (Switch to `bank` when running bank-specific statements)
-- USE bank;

-- ================================================================
-- Schema for `university` database (tables with PK & FK constraints)
-- ================================================================
USE university;

-- Departments table (PK)
CREATE TABLE IF NOT EXISTS departments (
  dept_id INT AUTO_INCREMENT PRIMARY KEY,
  dept_name VARCHAR(100) NOT NULL UNIQUE,
  office VARCHAR(50)
);

-- Instructors table (PK) with foreign key to departments
CREATE TABLE IF NOT EXISTS instructors (
  instr_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  dept_id INT,
  hire_date DATE DEFAULT CURRENT_DATE,
  salary DECIMAL(10,2) DEFAULT 50000,
  FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Students table (PK)
CREATE TABLE IF NOT EXISTS students (
  student_id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50),
  email VARCHAR(100) UNIQUE,
  dob DATE,
  gender ENUM('M','F','O') DEFAULT 'O',
  status VARCHAR(10) DEFAULT 'active',
  CHECK (status IN ('active','inactive','graduated'))
);

-- Courses table (PK)
CREATE TABLE IF NOT EXISTS courses (
  course_id VARCHAR(10) PRIMARY KEY,
  title VARCHAR(200) NOT NULL,
  credits INT NOT NULL DEFAULT 3,
  dept_id INT,
  FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Enrollments table (many-to-many: students <-> courses) with composite PK
CREATE TABLE IF NOT EXISTS enrollments (
  student_id INT,
  course_id VARCHAR(10),
  enroll_date DATE DEFAULT CURRENT_DATE,
  grade CHAR(2),
  PRIMARY KEY (student_id, course_id),
  FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
  FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);

-- Office assignments (example of 1:1 optional)
CREATE TABLE IF NOT EXISTS office_assignments (
  instr_id INT PRIMARY KEY,
  room VARCHAR(20),
  FOREIGN KEY (instr_id) REFERENCES instructors(instr_id) ON DELETE CASCADE
);

-- ================================================================
-- Schema for `bank` database (for DCL/TCL, triggers, transactions)
-- ================================================================
USE bank;

CREATE TABLE IF NOT EXISTS customers (
  customer_id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(100) UNIQUE,
  phone VARCHAR(20),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS accounts (
  account_id INT AUTO_INCREMENT PRIMARY KEY,
  customer_id INT,
  account_type ENUM('savings','current') DEFAULT 'savings',
  balance DECIMAL(14,2) NOT NULL DEFAULT 0.00,
  opened_date DATE DEFAULT CURRENT_DATE,
  FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Transactions table for triggers (row-level)
CREATE TABLE IF NOT EXISTS transactions (
  txn_id INT AUTO_INCREMENT PRIMARY KEY,
  account_id INT,
  txn_type ENUM('deposit','withdrawal','transfer') NOT NULL,
  amount DECIMAL(14,2) NOT NULL CHECK (amount >= 0),
  txn_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  remarks VARCHAR(255),
  FOREIGN KEY (account_id) REFERENCES accounts(account_id)
);

-- ================================================================
-- 30 PRACTICE QUESTIONS (with queries). Copy-paste each as needed.
-- Each numbered item shows a question (comment) then the SQL query.
-- ================================================================

/* 1) DDL: Create the 'university' database and a departments table (PK).
   (Already executed above) */

-- Q1: Create database and departments table (if not yet created).
CREATE DATABASE IF NOT EXISTS university_copy;
USE university_copy;
CREATE TABLE IF NOT EXISTS departments_copy (
  dept_id INT AUTO_INCREMENT PRIMARY KEY,
  dept_name VARCHAR(100) NOT NULL UNIQUE
);

/* 2) DDL + PK/FK: Create students, courses, enrollments with primary & foreign keys */

-- Q2: Create students, courses and enrollments (many-to-many).
USE university;
-- (Tables created above) 
-- Validate foreign keys (example)
SELECT
  TABLE_NAME, CONSTRAINT_NAME, REFERENCED_TABLE_NAME
FROM
  information_schema.KEY_COLUMN_USAGE
WHERE
  TABLE_SCHEMA = 'university' AND REFERENCED_TABLE_NAME IS NOT NULL;

/* 3) DML: Insert sample records into students, instructors, departments, courses */

-- Q3: Insert sample departments, instructors, students, courses and enrollments.
USE university;
INSERT INTO departments (dept_name, office) VALUES
  ('Computer Science','CS-101'),
  ('Mathematics','MATH-201'),
  ('Physics','PHY-301');

INSERT INTO instructors (name, dept_id, salary) VALUES
  ('Dr. A Sharma', 1, 75000),
  ('Dr. M Patel', 2, 68000);

INSERT INTO students (first_name, last_name, email, dob, gender) VALUES
  ('Rythm','Kach','rythm@example.com','2002-04-15','M'),
  ('Tanish','Bhongade','tanish@example.com','2001-07-10','M'),
  ('Aditi','Sharma','aditi@example.com','2002-11-25','F');

INSERT INTO courses (course_id, title, credits, dept_id) VALUES
  ('CS101','Intro to Programming',4,1),
  ('CS201','Data Structures',4,1),
  ('MATH101','Calculus I',3,2);

INSERT INTO enrollments (student_id, course_id, grade) VALUES
  (1,'CS101','A'),
  (1,'MATH101','B'),
  (2,'CS101','B'),
  (3,'CS201',NULL);

/* 4) DML: SELECT - view all students (simple read) */

-- Q4: Retrieve all students.
SELECT * FROM students;

/* 5) DML: UPDATE - change student email or marks */

-- Q5: Update a student's email and status.
UPDATE students
SET email = 'rythm.kach@example.com', status = 'active'
WHERE student_id = 1;

/* 6) DML: DELETE - remove a student by condition */

-- Q6: Delete students who are inactive.
DELETE FROM students WHERE status = 'inactive';

/* 7) DCL: Grant and revoke privileges (example) */

-- Q7: Create a user (example) and grant SELECT privilege on university schema.
-- Note: Run as a privileged MySQL user (root). Adjust user/password for your environment.
CREATE USER IF NOT EXISTS 'app_user'@'localhost' IDENTIFIED BY 'app_pass';
GRANT SELECT, INSERT, UPDATE ON university.* TO 'app_user'@'localhost';
-- Revoke example:
REVOKE INSERT ON university.* FROM 'app_user'@'localhost';

/* 8) TCL: Transaction control - commit/rollback/savepoint */

-- Q8: Demonstrate a transaction: transfer money between two accounts (bank DB).
USE bank;
START TRANSACTION;
-- withdraw from account 1
UPDATE accounts SET balance = balance - 500.00 WHERE account_id = 1;
-- deposit to account 2
UPDATE accounts SET balance = balance + 500.00 WHERE account_id = 2;
-- create a savepoint and then commit
SAVEPOINT after_transfer;
-- if all good
COMMIT;
-- if error -> ROLLBACK TO after_transfer or ROLLBACK;

/* 9) Integrity constraints: add NOT NULL, DEFAULT, UNIQUE, CHECK */

-- Q9: Add NOT NULL and DEFAULT to students.last_name; add a UNIQUE constraint to student email.
ALTER TABLE students
  MODIFY last_name VARCHAR(50) NOT NULL,
  MODIFY status VARCHAR(10) NOT NULL DEFAULT 'active';

ALTER TABLE students
  ADD CONSTRAINT uq_students_email UNIQUE (email);

-- Example CHECK: ensure credits > 0
ALTER TABLE courses
  ADD CONSTRAINT chk_credits_positive CHECK (credits > 0);

/* 10) DML: Insertion examples - insertOne vs insertMany concept (SQL uses INSERT/VALUES, multi-row) */

-- Q10: Insert single and multiple rows into courses.
INSERT INTO courses (course_id, title, credits, dept_id)
VALUES ('PHY101','General Physics',3,3);

INSERT INTO courses (course_id, title, credits, dept_id) VALUES
  ('ENG101','English Composition',3, NULL),
  ('CS301','Algorithms',4, 1);

/* 11) String operations - CONCAT, SUBSTRING, LENGTH, UPPER/LOWER */

-- Q11: Show full name using CONCAT, substring of email, length of name.
SELECT
  student_id,
  CONCAT(first_name, ' ', last_name) AS full_name,
  SUBSTRING(email,1,LOCATE('@',email)-1) AS email_user,
  CHAR_LENGTH(CONCAT(first_name, last_name)) AS name_length,
  UPPER(first_name) AS first_upper
FROM students;

/* 12) Aggregation - SUM, AVG, COUNT, GROUP BY, HAVING */

-- Q12: Average marks per course (assuming numeric grades stored or mapping).
-- For demo, compute count of enrollments per course and show only courses with more than 1 student.
SELECT e.course_id, c.title, COUNT(*) AS num_students
FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
GROUP BY e.course_id, c.title
HAVING COUNT(*) > 1;

/* 13) Joins: INNER JOIN, LEFT JOIN, RIGHT JOIN, NATURAL JOIN */

-- Q13a: Inner join students with enrollments to get student names and courses.
SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS name, e.course_id
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id;

-- Q13b: Left join to list all students and their possible enrollments
SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS name, e.course_id
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id;

-- Q13c: Natural join (only works if column names match and you want implicit join)
-- (Example - create two small tables with matching column names if needed)
-- SELECT * FROM some_table NATURAL JOIN another_table;

/* 14) Nested Subqueries: correlated and uncorrelated */

-- Q14a: Find students enrolled in the course with the highest number of enrollments.
SELECT s.student_id, s.first_name, s.last_name
FROM students s
WHERE s.student_id IN (
  SELECT student_id
  FROM enrollments
  WHERE course_id = (
    SELECT course_id
    FROM (
      SELECT course_id, COUNT(*) AS cnt
      FROM enrollments
      GROUP BY course_id
      ORDER BY cnt DESC
      LIMIT 1
    ) AS top_course
  )
);

-- Q14b: Correlated subquery: find students whose enrollment count > average enrollment per student.
SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS name
FROM students s
WHERE (
  SELECT COUNT(*)
  FROM enrollments e
  WHERE e.student_id = s.student_id
) > (
  SELECT AVG(cnt) FROM (
    SELECT COUNT(*) AS cnt FROM enrollments GROUP BY student_id
  ) AS t
);

/* 15) Set operations (UNION / UNION ALL) and emulation of INTERSECT/EXCEPT */

-- Q15a: UNION two SELECTs (students who enrolled in CS101 or MATH101).
SELECT student_id FROM enrollments WHERE course_id = 'CS101'
UNION
SELECT student_id FROM enrollments WHERE course_id = 'MATH101';

-- Q15b: UNION ALL (including duplicates)
SELECT student_id FROM enrollments WHERE course_id = 'CS101'
UNION ALL
SELECT student_id FROM enrollments WHERE course_id = 'CS201';

-- Q15c: INTERSECT emulation: students who took both CS101 and MATH101
SELECT e1.student_id
FROM enrollments e1
WHERE e1.course_id = 'CS101'
AND EXISTS (
  SELECT 1 FROM enrollments e2 WHERE e2.student_id = e1.student_id AND e2.course_id = 'MATH101'
)
GROUP BY e1.student_id;

/* 16) Views: CREATE view, query view, DROP view */

-- Q16: Create a view of students with their course counts.
CREATE OR REPLACE VIEW vw_student_course_count AS
SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS student_name,
       COUNT(e.course_id) AS course_count
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id;

-- Query the view
SELECT * FROM vw_student_course_count;

-- Drop view
DROP VIEW IF EXISTS vw_student_course_count;

/* 17) Indexing: CREATE INDEX, UNIQUE INDEX, DROP INDEX */

-- Q17a: Create a non-unique index on courses.title
CREATE INDEX idx_course_title ON courses (title);

-- Q17b: Create a unique index on students.email (if not yet created)
CREATE UNIQUE INDEX uq_students_email_idx ON students (email);

-- Drop an index
DROP INDEX idx_course_title ON courses;

/* 18) Trigger: row-level trigger for INSERT (bank.transactions) -> update account balance */

-- Q18: Create trigger in `bank` database to update account balance after transaction insert.
USE bank;

-- Make sure to drop existing triggers to avoid duplicate names:
DROP TRIGGER IF EXISTS trg_after_insert_transaction;

DELIMITER //
CREATE TRIGGER trg_after_insert_transaction
AFTER INSERT ON transactions
FOR EACH ROW
BEGIN
  IF NEW.txn_type = 'deposit' THEN
    UPDATE accounts SET balance = balance + NEW.amount WHERE account_id = NEW.account_id;
  ELSEIF NEW.txn_type = 'withdrawal' THEN
    UPDATE accounts SET balance = balance - NEW.amount WHERE account_id = NEW.account_id;
  END IF;
END;
//
DELIMITER ;

-- Test: Insert a transaction (the trigger will update accounts.balance)
-- INSERT INTO transactions (account_id, txn_type, amount) VALUES (1,'deposit',1000.00);

/* 19) Row-level trigger for UPDATE: log previous balance into a history table */

-- Q19: Create a balance_history table and an UPDATE trigger.
USE bank;
CREATE TABLE IF NOT EXISTS balance_history (
  hist_id INT AUTO_INCREMENT PRIMARY KEY,
  account_id INT,
  old_balance DECIMAL(14,2),
  new_balance DECIMAL(14,2),
  changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DROP TRIGGER IF EXISTS trg_before_update_account;
DELIMITER //
CREATE TRIGGER trg_before_update_account
BEFORE UPDATE ON accounts
FOR EACH ROW
BEGIN
  INSERT INTO balance_history (account_id, old_balance, new_balance)
  VALUES (OLD.account_id, OLD.balance, NEW.balance);
END;
//
DELIMITER ;

/* 20) Demonstrate ALTER TABLE to add/remove columns or constraints */

-- Q20: Add a 'middle_name' column to students and then remove it.
ALTER TABLE students ADD COLUMN middle_name VARCHAR(50) NULL;
-- Later, drop it:
ALTER TABLE students DROP COLUMN middle_name;

/* 21) Advanced Aggregation: GROUP_CONCAT, window-like aggregate via variables or use JSON */

-- Q21: List courses each student is enrolled in as comma-separated string.
SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS student_name,
       GROUP_CONCAT(e.course_id ORDER BY e.course_id SEPARATOR ', ') AS courses
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id;

/* 22) Query with HAVING and ORDER BY using aggregates */

-- Q22: Get courses with average grade (if grade mapped to numeric) and show those with avg > X.
-- For demo, assume grade mapping via CASE expression.
SELECT e.course_id, COUNT(*) AS num_students,
       AVG(CASE grade WHEN 'A' THEN 4 WHEN 'B' THEN 3 WHEN 'C' THEN 2 WHEN 'D' THEN 1 ELSE 0 END) AS avg_grade_point
FROM enrollments e
GROUP BY e.course_id
HAVING avg_grade_point > 2.5
ORDER BY avg_grade_point DESC;

/* 23) Natural Join example (works when column names match appropriately) */

-- Q23: Natural join between instructors and departments (if column names match dept_id).
SELECT * FROM instructors NATURAL JOIN departments;

/* 24) Nested queries with EXISTS / NOT EXISTS */

-- Q24: Find students who have enrolled in at least one course.
SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS name
FROM students s
WHERE EXISTS (SELECT 1 FROM enrollments e WHERE e.student_id = s.student_id);

-- Find students who have not enrolled in any course.
SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS name
FROM students s
WHERE NOT EXISTS (SELECT 1 FROM enrollments e WHERE e.student_id = s.student_id);

/* 25) Set operation: Use UNION to combine results from two tables */

-- Q25: Suppose there's a table `guest_lecturers` with similar schema; union with instructors.
-- For demo we will just union first names from instructors and students.
SELECT name AS person_name, 'Instructor' AS role FROM instructors
UNION
SELECT CONCAT(first_name,' ',last_name) AS person_name, 'Student' AS role FROM students;

/* 26) Update with JOIN (update one table based on another) */

-- Q26: Increase salary of instructors in Computer Science by 10%.
UPDATE instructors i
JOIN departments d ON i.dept_id = d.dept_id
SET i.salary = i.salary * 1.10
WHERE d.dept_name = 'Computer Science';

/* 27) Deleting with JOIN / multi-table delete */

-- Q27: Delete enrollments for a course that has been removed (example: remove course 'ENG101').
DELETE e FROM enrollments e
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_id = 'ENG101';

-- Then delete the course itself
DELETE FROM courses WHERE course_id = 'ENG101';

/* 28) Create and use a VIEW that shows top performing students by average grade (conceptual) */

-- Q28: Create view for students' average marks across courses (if marks numeric exist).
-- For our schema we do not have numeric marks in enrollments; imagine we had 'marks' column.
-- Example:
CREATE OR REPLACE VIEW vw_student_avg_marks AS
SELECT s.student_id, CONCAT(s.first_name,' ',s.last_name) AS name,
       AVG(e.grade) AS avg_mark -- replace with numeric column in real schema
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id;

-- Use the view:
-- SELECT * FROM vw_student_avg_marks ORDER BY avg_mark DESC LIMIT 10;

-- Drop view if created in this schema
DROP VIEW IF EXISTS vw_student_avg_marks;

/* 29) Indexing strategy query examples (explain usage) */

-- Q29: Create composite index on enrollments (student_id, course_id) - already primary key,
-- but this shows how:
CREATE INDEX idx_enroll_student_course ON enrollments (student_id, course_id);

-- Show indexes for enrollments:
SHOW INDEX FROM enrollments;

/* 30) Trigger to prevent overdraft - BEFORE INSERT/UPDATE on transactions */

-- Q30: BEFORE INSERT trigger to check withdrawals do not exceed balance.
USE bank;
DROP TRIGGER IF EXISTS trg_before_insert_txn;
DELIMITER //
CREATE TRIGGER trg_before_insert_txn
BEFORE INSERT ON transactions
FOR EACH ROW
BEGIN
  IF NEW.txn_type = 'withdrawal' THEN
    DECLARE cur_balance DECIMAL(14,2);
    SELECT balance INTO cur_balance FROM accounts WHERE account_id = NEW.account_id FOR UPDATE;
    IF cur_balance < NEW.amount THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Insufficient funds for withdrawal';
    END IF;
  END IF;
END;
//
DELIMITER ;

-- Test: Attempting to insert a withdrawal greater than balance will raise an error:
-- INSERT INTO transactions (account_id, txn_type, amount) VALUES (1,'withdrawal',1000000.00);

-- ================================================================
-- END OF 30 QUESTIONS & SAMPLE QUERIES
-- You can adapt data, IDs and values to your local environment.
-- For bank triggers and transactions make sure accounts & customers exist before testing.
-- ================================================================
