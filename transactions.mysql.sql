select count(*) tran_unwgt, sum(w.weight*brand_factor) tran_wgt
from weights w, purchases p
where p.pur_date between w.from_date and w.to_date
and w.household_id=p.household_id
and w.standard=1;

select aa.postext, count(*) tran_unwgt, sum(w.weight*brand_factor) tran_wgt
from weights w, purchases p, artaxis aa
where p.pur_date between w.from_date and w.to_date
and w.household_id=p.household_id
and aa.cat_id=p.category_id
and aa.brnd_id=p.brand_id
and w.standard=1
group by aa.postext;

create temporary table hh_max_valid as (
select household_id, max(valid_date) max_valid_date
from households
group by household_id);

create temporary table hhvalid as (
select h.household_id, h.bdl_id, h.age_id
from households h, hh_max_valid hmv
where h.household_id=hmv.household_id
and h.valid_date=hmv.max_valid_date);

select h.postext, count(*) tran_unwgt, sum(w.weight*brand_factor) tran_wgt
from weights w, purchases p, hhaxis h, hhvalid hh
where p.pur_date between w.from_date and w.to_date
and w.household_id=p.household_id
and hh.household_id=p.household_id
and h.age_id=hh.age_id
and h.bdl_id=hh.bdl_id
and w.standard=1
group by h.postext;

select h.postext, aa.postext, count(*) tran_unwgt, sum(w.weight*brand_factor) tran_wgt
from weights w, purchases p, hhaxis h, hhvalid hh, artaxis aa
where p.pur_date between w.from_date and w.to_date
and w.household_id=p.household_id
and hh.household_id=p.household_id
and h.age_id=hh.age_id
and h.bdl_id=hh.bdl_id
and aa.cat_id=p.category_id
and aa.brnd_id=p.brand_id
and w.standard=1
group by h.postext, aa.postext;
