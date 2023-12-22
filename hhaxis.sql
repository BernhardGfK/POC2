drop table if exists hhaxis;
create table hhaxis (
	bdl_id int,
	bdl_name varchar(30),
	age_id int,
	age_name varchar(30),
	postext varchar(60),
	pos_id varchar(30),
	parent_id varchar(30));

.mode tabs
.import hhaxis.txt hhaxis
.headers on
select * from hhaxis limit 10;
