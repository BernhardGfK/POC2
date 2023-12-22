drop table if exists purchases;
create table purchases (
	household_id int,
	pur_date text,
	shop_id int,
	article_id int,
	category_id int,
	beand_id int,
	value real,
	brand_factor real,
	rw real);
.mode tabs
.import pur.txt purchases
.headers on
select * from purchases limit 10;
