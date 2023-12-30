drop table if exists artaxis;
create table artaxis (
	cat_id int,
	cat_name varchar(30),
	brnd_id int,
	brnd_name varchar(30),
	postext varchar(60),
	pos_id varchar(30),
	parent_id varchar(30));
load data local infile 'artaxis.txt' into table artaxis;
select * from artaxis limit 10;
