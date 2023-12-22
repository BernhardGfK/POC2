drop table if exists households;
create table households (
	household_id int,
	bdl_id int null,
	age_id int,
	valid_date text);
.mode tabs
.import hh.txt households
.headers on
select * from households limit 10;
