create temporary table minwgtlen as (
select min(to_date-from_date) min_wgt_len
from weights
where from_date <='2017-01-01'
and to_date >='2018-12-31');

create temporary table cswgt as (
select from_date, to_date
from weights w, minwgtlen mwl
where w.from_date <='2017-01-01'
and w.to_date >='2018-12-31'
and w.to_date-w.from_date=mwl.min_wgt_len
group by from_date, to_date
order by from_date
limit 1);

create temporary table buyers_cs as (
select household_id, 1 as buyers
from purchases
group by household_id);

select count(*) buyers_unwgt, sum(w.weight*buyers) buyers_cs_wgt
from weights w, buyers_cs t, cswgt cw
where w.household_id=t.household_id
and cw.from_date=w.from_date
and cw.to_date=w.to_date;

create temporary table avg_weights as (
select household_id, sum(weight)/(select (unix_datetime(max(to_date))/3600/24-unix_datetime(min(from_date))/3600/24+1)/7 as weeks from weights where standard=1) as avg_weight
from weights
where standard=1
group by household_id);

create temporary table buyers_avg as (
select household_id, 1 as buyers
from purchases
group by household_id);

select count(*) buyer_unwgt, sum(avg_weight*buyers) buyer_avg
from avg_weights w, buyers t
where w.household_id=t.household_id;
