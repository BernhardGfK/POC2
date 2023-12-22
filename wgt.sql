drop table if exists weights;
create table weights (
	household_id int,
	from_date text,
	to_date text,
	weight float,
	standard int);
.mode tabs
.import wgt.txt weights
.headers on
select * from weights limit 10;
