with buyers as (
select household_id, 1 as buyers
from purchases
group by household_id, pur_date, shop_id
)
select count(*) buyers_unwgt, sum(w.weight*buyers) buyers_cs_wgt
from weights w, buyers t
where w.household_id=t.household_id
and w.standard=0;

with avg_weights as (
select household_id, sum(weight)/(select (julianday(max(to_date))-julianday(min(from_date))+1)/7 as weeks from weights where standard=1) as avg_weight
from weights
where standard=1
group by household_id),
buyers as (
select household_id, 1 as buyers
from purchases
group by household_id)
select count(*) buyer_unwgt, sum(avg_weight*buyers) buyer_avg
from avg_weights w, buyers t
where w.household_id=t.household_id;
