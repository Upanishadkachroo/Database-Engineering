use DBE;
show tables;
select * from account;

DELIMITER //
-- DELIMITER
CREATE TRIGGER trigger_before_insert
BEFORE INSERT ON account
FOR EACH ROW 
BEGIN
      IF NEW.balance < 0 THEN
         SET NEW.balance = 0;
      END IF;
END

show triggers;

customer INSERT INTO account (account_no, branch_name, balance)
VALUES (101, 'Pune', -500);

SELECT * FROM account;


DELIMITER //
CREATE TRIGGER trigger_before_update
BEFORE UPDATE ON account
for each row
begin
   if new.balance<0 then
       set new.balance=old.balance;
	end if;
end;

DELIMITER;

-- Create an AFTER DELETE trigger
DELIMITER //

CREATE TRIGGER trigger_after_delete
AFTER DELETE ON account
FOR EACH ROW
BEGIN
    INSERT INTO log_table (action, account_no, action_time)
    VALUES ('Record Deleted', OLD.account_no, NOW());
END;
//

DELIMITER ;


DROP TRIGGER DBE.trigger_before_update;

