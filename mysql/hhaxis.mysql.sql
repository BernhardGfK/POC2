drop table if exists hhaxis;
create table hhaxis (
	bdl_id int,
	bdl_name varchar(30),
	age_id int,
	age_name varchar(30),
	postext varchar(60),
	pos_id varchar(30),
	parent_id varchar(30));
load data local infile 'hhaxis.txt' into table hhaxis;
select * from hhaxis limit 10;
