
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

hhaxisprep()
{
vsql << INPUT
drop table tempdb..bdschi_poc2_age
drop table tempdb..bdschi_poc2_bdl
go
INPUT
vsql << INPUT
select value_id, name into tempdb..bdschi_poc2_age from gfkvalues, names where name_id=value_id and valid_flag=1 and language_id=2 and feature_id=8319588
go
alter table tempdb..bdschi_poc2_age add postext varchar(30) NULL
go
update tempdb..bdschi_poc2_age set postext='Young Adults' where name in ('bis 19 Jahre', '20-24 Jahre', '25-29 Jahre')
update tempdb..bdschi_poc2_age set postext='Under 50' where name in ('30-34 Jahre', '35-39 Jahre', '40-44 Jahre', '45-49 Jahre')
update tempdb..bdschi_poc2_age set postext='Over 50' where name in ('50-54 Jahre', '55-59 Jahre', '60-64 Jahre', '65-69 Jahre', '70 Jahre und älter')                      
select * from tempdb..bdschi_poc2_age
go
select value_id, name into tempdb..bdschi_poc2_bdl from gfkvalues, names where name_id=value_id and valid_flag=1 and language_id=2 and feature_id=8319491
go
alter table tempdb..bdschi_poc2_bdl add postext varchar(30) NULL
go
update tempdb..bdschi_poc2_bdl set postext='Nord' where name in ('Schleswig-Holstein', 'Niedersachsen', 'Hamburg', 'Bremen')
update tempdb..bdschi_poc2_bdl set postext='NRW' where name in ('Nordrhein-Westfalen')
update tempdb..bdschi_poc2_bdl set postext='Mitte' where name in ('Saarland','Rheinland-Pfalz', 'Hessen')
update tempdb..bdschi_poc2_bdl set postext='Ost' where name in ('Sachsen/Anhalt', 'Sachsen', 'Thüringen', 'Mecklenburg', 'Brandenburg')
update tempdb..bdschi_poc2_bdl set postext='BW' where name in ('Baden-Württemberg')
update tempdb..bdschi_poc2_bdl set postext='BAY' where name in ('Bayern')
update tempdb..bdschi_poc2_bdl set postext='BER' where name in ('Berlin', 'Berlin-West')
select * from tempdb..bdschi_poc2_bdl
go
INPUT
}

hhaxis()
{
vsql << INPUT | sed 's/^	//;s/	$//;s/ *	/	/g;s/	 */	/g;s/^ *//'
select abdl.value_id bdl_id, nbdl.name, aage.value_id age_id, nage.name, tage.postext, hash(tbdl.postext+tage.postext) pos_id, hash(tbdl.postext) parent_id
from gfkvalues abdl, gfkvalues aage, names  nbdl, names nage, tempdb..bdschi_poc2_age tage, tempdb..bdschi_poc2_bdl tbdl
where nage.name_id=aage.value_id
and nbdl.name_id=abdl.value_id
and aage.feature_id=8319588
and abdl.feature_id=8319491
and nage.valid_flag=1 and nage.language_id=2
and nbdl.valid_flag=1 and nbdl.language_id=2
and tage.value_id=nage.name_id
and tbdl.value_id=nbdl.name_id
group by abdl.value_id, aage.value_id, nbdl.name, nage.name, tage.postext, tbdl.postext
go
select abdl.value_id bdl_id, nbdl.name, aage.value_id age_id, nage.name, tbdl.postext, hash(tbdl.postext) pos_id, hash('TOTAL') parent_id
from gfkvalues abdl, gfkvalues aage, names  nbdl, names nage, tempdb..bdschi_poc2_age tage, tempdb..bdschi_poc2_bdl tbdl
where nage.name_id=aage.value_id
and nbdl.name_id=abdl.value_id
and aage.feature_id=8319588
and abdl.feature_id=8319491
and nage.valid_flag=1 and nage.language_id=2
and nbdl.valid_flag=1 and nbdl.language_id=2
and tage.value_id=nage.name_id
and tbdl.value_id=nbdl.name_id
group by abdl.value_id, aage.value_id, nbdl.name, nage.name, tage.postext, tbdl.postext
go
select abdl.value_id bdl_id, nbdl.name, aage.value_id age_id, nage.name, 'TOTAL', hash('TOTAL') pos_id, NULL parent_id
from gfkvalues abdl, gfkvalues aage, names  nbdl, names nage, tempdb..bdschi_poc2_age tage, tempdb..bdschi_poc2_bdl tbdl
where nage.name_id=aage.value_id
and nbdl.name_id=abdl.value_id
and aage.feature_id=8319588
and abdl.feature_id=8319491
and nage.valid_flag=1 and nage.language_id=2
and nbdl.valid_flag=1 and nbdl.language_id=2
and tage.value_id=nage.name_id
and tbdl.value_id=nbdl.name_id
group by abdl.value_id, aage.value_id, nbdl.name, nage.name, tage.postext, tbdl.postext
go
INPUT
}

artaxis()
{
vsql << INPUT | sed 's/^	//;s/	$//;s/ *	/	/g;s/	 */	/g;s/^ *//'

select ncat.name_id cat_id, ncat.name, abrnd.feature_value brnd_id, nbrnd.name, nbrnd.name, hash(ncat.name+nbrnd.name) pos_id, hash(ncat.name) parent_id
from objects ocat, assign_2020930 abrnd, names ncat, names nbrnd, objects o
where nbrnd.name_id=abrnd.feature_value
and abrnd.object_id=o.object_id
and o.parent_id=ocat.object_id
and nbrnd.valid_flag=1 and nbrnd.language_id=2
and ncat.valid_flag=1 and ncat.language_id=2
and ncat.object_sort=3
and ncat.object_type=2
and ocat.object_id=ncat.name_id
and ocat.cat_id=3
and ocat.class_flag=1
group by ncat.name_id, abrnd.feature_value, ncat.name, nbrnd.name
go

select ncat.name_id cat_id, ncat.name, abrnd.feature_value brnd_id, nbrnd.name, ncat.name, hash(ncat.name) pos_id, hash('TOTALA') parent_id
from objects ocat, assign_2020930 abrnd, names ncat, names nbrnd, objects o
where nbrnd.name_id=abrnd.feature_value
and abrnd.object_id=o.object_id
and o.parent_id=ocat.object_id
and nbrnd.valid_flag=1 and nbrnd.language_id=2
and ncat.valid_flag=1 and ncat.language_id=2
and ncat.object_sort=3
and ncat.object_type=2
and ocat.object_id=ncat.name_id
and ocat.cat_id=3
and ocat.class_flag=1
group by ncat.name_id, abrnd.feature_value, ncat.name, nbrnd.name
go

select ncat.name_id cat_id, ncat.name, abrnd.feature_value brnd_id, nbrnd.name, 'TOTAL', hash('TOTALA') pos_id, NULL parent_id
from objects ocat, assign_2020930 abrnd, names ncat, names nbrnd, objects o
where nbrnd.name_id=abrnd.feature_value
and abrnd.object_id=o.object_id
and o.parent_id=ocat.object_id
and nbrnd.valid_flag=1 and nbrnd.language_id=2
and ncat.valid_flag=1 and ncat.language_id=2
and ncat.object_sort=3
and ncat.object_type=2
and ocat.object_id=ncat.name_id
and ocat.cat_id=3
and ocat.class_flag=1
group by ncat.name_id, abrnd.feature_value, ncat.name, nbrnd.name
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
hhaxis > hhaxis.txt
artaxis > artaxis.txt
exit

rm hh.txt
for year in 2017 2018
do
	for month in 01 02 03 04 05 06 07 08 09 10 11 12
	do
		hh `dat2int 01.$month.$year`  | sed 's/$/	'$year'-'$month'-01/' >> hh.txt
	done
done
