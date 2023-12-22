drop table if exists purchases;
create table purchases (
    rec_id int,
	panel_id,
	household_id int,
	pur_date text,
	shop_id int,
	packs int,
	volume float,
	value float,
	article_id int,
	category_id int,
	brand_id int,
	brand_factor real,
	rw real);
.mode tabs
.import pur.txt purchases
.headers on
select * from purchases limit 10;
