
show()
{
vsql -d -H -s " " << INPUT | formsql
select s.rec_id, s.prev_gen_id, s.deleted, s.col_1 gen_id, s.col_2 copied, s.panel_id, s.col_3 move_date, h.name hhnr, s.col_6 anzahl, s.col_7 menge, s.col_8 wert, a.feature_value articlekey, g.name shopname, c.name prod_group
from move_std s, names h, assign_25146 a, objects o, names c, assign_10524806 ag, names g
where col_4=h.name_id and h.object_type=2 and h.object_sort=2
and col_9=a.object_id
and col_3 between a.from_date and a.to_date
and s.col_9=o.object_id and o.parent_id=c.name_id and c.valid_flag=1 and c.language_id=2
and col_3 between ag.from_date and ag.to_date
and col_5=ag.object_id
and ag.feature_value=g.name_id and g.valid_flag=1 and g.language_id=2
and s.panel_id in (select source_panel_id from rep_pan_definition where target_panel_id=274)
-- and s.col_3 between `dat2int 1.1.2017` and `dat2int 31.12.2018`
and s.col_3 between `dat2int 1.1.2017` and `dat2int 1.1.2017`
and s.col_1=9 and s.col_2=0 and s.deleted=0
go
INPUT
}

#43466550 ist CP_OUT_Markenfaktor -> pruefen
#43466545 ist CP_RW_STD -> pruefen
purchases()
{
vsql << INPUT | sed 's/^	//;s/	$//;s/ //g' > pur.txt
select s.rec_id, s.panel_id, s.col_4 household_id, str_replace(convert(char, dateadd(day, s.col_3-719528, '1970-01-01'), 111), "/", "-") move_date, s.col_5 shop_id, s.col_6 packs, s.col_7 volume, s.col_8 value, s.col_9 article_id, o.parent_id category_id, ab.feature_value brand_id, convert(float(4), mabf.value) brand_factor, convert(float(4), marw.value) rw
from move_std s, assign_25146 a, objects o, assign_2020930 ab, move_add mabf, move_add marw
where col_9=a.object_id
and s.col_9=o.object_id
and s.rec_id=mabf.rec_id and mabf.feat_id=43466550
and s.rec_id=marw.rec_id and marw.feat_id=43466545
and s.col_9=ab.object_id and s.col_3 between ab.from_date and ab.to_date
and s.panel_id in (select source_panel_id from rep_pan_definition where target_panel_id=274)
and s.col_3 between `dat2int 1.1.2017` and `dat2int 31.12.2018`
and s.col_1=9 and s.col_2=0 and s.deleted=0
and s.col_4 < 8320700
go
INPUT
}

weights()
{
vsql << INPUT | sed 's/^	//;s/	$//;s/ //g' > wgt.txt
select w.object_id household_id, str_replace(convert(char, dateadd(day, wi.from_date-719528, '1970-01-01'), 111), "/", "-") from_date, str_replace(convert(char, dateadd(day, wi.to_date-719528, '1970-01-01'), 111), "/", "-") to_date, w.weight, wi.standard
from weight_2 w, weight_info wi
where w.period_id=wi.period_id
and wi.panel_id=274
and wi.from_date <= `dat2int 31.12.2018`
and wi.to_date >= `dat2int 1.1.2017`
and w.object_id < 8320700
go
INPUT
}

hh()
{
vsql << INPUT | sed 's/^	//;s/	$//;s/ //g'
select r.object_id household_id, abdl.feature_value bdl_id, aage.feature_value age_id
from regular_members r, assign_8319491 abdl, assign_8319588 aage
where r.object_id=abdl.object_id
and r.object_id=aage.object_id
and $1 between r.from_date and r.to_date
and $1 between abdl.from_date and abdl.to_date
and $1 between aage.from_date and aage.to_date
and r.panel_id=274
and r.object_id < 8320700
go
INPUT
}

names()
{
vsql << INPUT
select name_id, name
from names
where object_type in (3, 4)
and valid_flag=1
and language_id=2
union all
select object_id name_id, feature_value name
from assign_25146
and to_date >= from_date
union all
select object_id name_id, feature_value name
from assign_2000472
and to_date >= from_date
INPUT
}

#purchases
#weights

rm hh.txt
for year in 2017 2018
do
	for month in 01 02 03 04 05 06 07 08 09 10 11 12
	do
		hh `dat2int 01.$month.$year`  | sed 's/$/	'$year'-'$month'-01/' >> hh.txt
	done
done
