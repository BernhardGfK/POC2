create temporary table trips_fs as (
select household_id, pur_date, shop_id, 1 as trips
from purchases
group by household_id, pur_date, shop_id);

select count(*) trip_unwgt, sum(w.weight*trips) trip_fs_wgt
from weights w, trips_fs t
where t.pur_date between w.from_date and w.to_date
and w.household_id=t.household_id
and w.standard=1;

create temporary table trips_rw as (
select household_id, pur_date, shop_id, avg(rw) as trips
from purchases
group by household_id, pur_date, shop_id);

select count(*) trip_unwgt, sum(w.weight*trips) trip_rw
from weights w, trips_rw t
where t.pur_date between w.from_date and w.to_date
and w.household_id=t.household_id
and w.standard=1;

create temporary table avg_weights as (
select household_id, sum(weight)/(select (unix_datetime(max(to_date))/3600/24-unix_datetime(min(from_date))/3600/24+1)/7 as weeks from weights where standard=1) as avg_weight
from weights
where standard=1
group by household_id);

create temporary table trips_avg as (
select household_id, pur_date, shop_id, 1 as trips
from purchases
group by household_id, pur_date, shop_id);

select count(*) trip_unwgt, sum(avg_weight*trips) trip_avg
from avg_weights w, trips_avg t
where w.household_id=t.household_id;
