drop table if exists weights;
create table weights (
	household_id int,
	from_date date,
	to_date date,
	weight float,
	standard int);
load data local infile 'wgt.txt' into table weights;
select * from weights limit 10;
