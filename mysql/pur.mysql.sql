drop table if exists purchases;
create table purchases (
	rec_id int,
	household_id int,
	pur_date date,
	shop_id int,
	packs int,
	value float,
	volume float,
	category_id int,
	brand_id int,
	feat2_id int default null,
	feat3_id int default null,
	feat4_id int default null,
	feat5_id int default null,
	feat6_id int default null,
	feat7_id int default null,
	feat8_id int default null,
	feat9_id int default null,
	brand_factor float,
	rw float);
load data local infile 'pur.txt' into table purchases;
select * from purchases limit 10;
