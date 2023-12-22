select count(*) tran_unwgt, sum(w.weight*brand_factor) tran_wgt
from weights w, purchases p
where p.pur_date between w.from_date and w.to_date
and w.household_id=p.household_id
and w.standard=1;
