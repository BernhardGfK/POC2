drop table if exists households;
create table households (
	household_id int,
	bdl_id int,
	age_id int,
	valid_date date);
load data infile 'hh.txt' into table households;
select * from households limit 10;
