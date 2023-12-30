-- drop index if exists wgtidx;
create index wgtidx on weights (household_id, from_date, to_date);

create index wgt1idx on weights (household_id, standard, from_date, to_date);

-- drop index if exists artaxindx;
create index artaxindx on artaxis (cat_id, brnd_id);

-- drop index if exists hhaxindx;
create index hhaxindx on hhaxis (bdl_id, age_id);
