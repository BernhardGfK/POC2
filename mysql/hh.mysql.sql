drop table if exists households;
create table households (
	household_id int,
	bdl_id int,
	age_id int,
	feat2_id int,
	feat3_id int,
	feat4_id int,
	feat5_id int default null,
	feat6_id int default null,
	feat7_id int default null,
	feat8_id int default null,
	feat9_id int default null,
	valid_date date);
load data local infile 'hh.txt' into table households;
select * from households limit 10;
