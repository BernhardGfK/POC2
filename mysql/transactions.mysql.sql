drop procedure if exists fill_dates;
drop table if exists dates;
-- One way to create a table in mysql that contains one entry for each day from 2019-01-01 to 2019-12-31 is to use a stored procedure that loops through the dates and inserts them into the table.
-- For example, you can use the following steps:
-- 1. Create a table with a date column, such as:
CREATE TABLE dates (date DATE, fdate DATE, tdate DATE);
-- 2. Create a stored procedure that takes two parameters: the start date and the end date, and inserts the dates between them into the table, such as:
DELIMITER //
CREATE PROCEDURE fill_dates (start_date DATE, end_date DATE)
BEGIN
-- Declare a variable to store the current date
DECLARE cdate DATE;
-- Set the current date to the start date
SET cdate = start_date;
-- Loop until the current date is greater than the end date
WHILE cdate <= end_date DO
-- Insert the current date into the table
INSERT INTO dates (date) VALUES (cdate);
-- Increment the current date by one day
SET cdate = DATE_ADD(cdate, INTERVAL 1 DAY);
END WHILE;
END //
DELIMITER ;
-- 3. Call the stored procedure with the desired date range, such as:
CALL fill_dates ('2017-01-01', '2019-12-31');
-- This way, you will have a table with one entry for each day from 2017-01-01 to 2019-12-31.
-- You can learn more about how to create a table with a range of dates from
-- Stack Overflow https://stackoverflow.com/questions/10132024/how-to-populate-a-table-with-a-range-of-dates
-- W3Schools https://www.w3schools.com/mysql/mysql_create_table.asp
-- or MySQL Docs https://dev.mysql.com/doc/mysql-tutorial-excerpt/8.0/en/creating-tables.html.

create temporary table weight_info as select from_date, to_date from weights where standard=1 group by from_date, to_date;
-- select * from weight_info;

update dates d, weight_info w
set fdate=w.from_date, tdate=w.to_date
where d.date between w.from_date and w.to_date;
-- select * from dates;

set profiling=1;
select count(*) tran_unwgt
from purchases p;
show profiles;

select count(*) tran_unwgt, sum(w.weight*brand_factor) tran_wgt
from weights w, purchases p, dates d
where p.pur_date=d.date 
and d.fdate=w.from_date
and d.tdate=w.to_date
and w.household_id=p.household_id
and w.standard=1;
show profiles;

select count(*) tran_unwgt, sum(w.weight*brand_factor) tran_wgt
from weights w, purchases p
where p.pur_date between w.from_date and w.to_date
and w.household_id=p.household_id
and w.standard=1;
show profiles;

select aa.postext, count(*) tran_unwgt, sum(w.weight*brand_factor) tran_wgt
from weights w, purchases p, artaxis aa
where p.pur_date between w.from_date and w.to_date
and w.household_id=p.household_id
and aa.cat_id=p.category_id
and aa.brnd_id=p.brand_id
and w.standard=1
group by aa.postext;
show profiles;

create temporary table hh_max_valid as (
select household_id, max(valid_date) max_valid_date
from households
group by household_id);

create temporary table hhvalid as (
select h.household_id, h.bdl_id, h.age_id
from households h, hh_max_valid hmv
where h.household_id=hmv.household_id
and h.valid_date=hmv.max_valid_date);

create index hhvalididx on hhvalid (household_id);

select h.postext, count(*) tran_unwgt, sum(w.weight*brand_factor) tran_wgt
from weights w, purchases p, hhaxis h, hhvalid hh
where p.pur_date between w.from_date and w.to_date
and w.household_id=p.household_id
and hh.household_id=p.household_id
and h.age_id=hh.age_id
and h.bdl_id=hh.bdl_id
and w.standard=1
group by h.postext;
show profiles;

select h.postext, aa.postext, count(*) tran_unwgt, sum(w.weight*brand_factor) tran_wgt
from weights w, purchases p, hhaxis h, hhvalid hh, artaxis aa
where p.pur_date between w.from_date and w.to_date
and w.household_id=p.household_id
and hh.household_id=p.household_id
and h.age_id=hh.age_id
and h.bdl_id=hh.bdl_id
and aa.cat_id=p.category_id
and aa.brnd_id=p.brand_id
and w.standard=1
group by h.postext, aa.postext;
show profiles;

