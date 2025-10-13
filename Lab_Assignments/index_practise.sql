use DBE;
show tables;
select * from account;

create index myindex
on account (branch_name);

create index myindex2
on account (branch_name, balance);

Drop index myindex2 on account;