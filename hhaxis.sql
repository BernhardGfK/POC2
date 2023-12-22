drop table if exists hhaxis;
create table hhaxis (
	bdl_id int,
	bdl_name int,
	age_id,
	age_name,
	postext varchar(60),
	pos_id varchar(30),
	parent_id varchar(30));

.mode tabs
.import hhaxis.txt hhaxis
.headers on
select * from hhaxis limit 10;
