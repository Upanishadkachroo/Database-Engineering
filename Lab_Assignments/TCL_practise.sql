use DBE;
show tables;

SELECT * FROM account;
START TRANSACTION;
INSERT INTO account VALUES (105, 'SBI_Delhi', 100000);
COMMIT;

delete from account where account_number=105;
SELECT * FROM account;

start transaction;
rollback;

start transaction;
insert into account values(106, "SBI_Pune", 5000);

select * from account;

start transaction;
rollback;

START TRANSACTION;

INSERT INTO account VALUES (107, 'SBI_Kolkata', 80000);
SAVEPOINT A;

INSERT INTO account VALUES (108, 'SBI_Chennai', 90000);
SAVEPOINT B;

ROLLBACK TO SAVEPOINT A;  -- Undo only up to A (record 108 undone)
COMMIT;
