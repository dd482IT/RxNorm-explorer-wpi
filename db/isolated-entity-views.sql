create view isoent_scd_v as
select
  scd.rxcui "rxcui",
  scd.name "name",
  scd.prescribable_name "prescribableName",
  scd.rxterm_form "rxtermForm",
  df.name "dosageForm",
  scd.ingrset_rxcui "ingrSetRxcui",
  scd.avail_strengths "availableStrengths",
  scd.qual_distinct "qualDistinct",
  scd.quantity "quantity",
  scd.human_drug = 1 "humanDrug",
  scd.vet_drug = 1 "vetDrug",
  scd.unquantified_form_rxcui "unquantifiedFormRxcui",
  scd.suppress "suppress"
from scd
join df on df.rxcui = scd.df_rxcui
;

-- TODO: Define more drug related isolated entities above, then include in ndc_isoents_mv below.

create materialized view ndc_isoents_mv as
select
  pc.two_part_ndc,
  (select coalesce(json_agg(row_to_json(scd.*)), '[]'::json)
   from isoent_scd_v scd
   where scd.rxcui in (
     select cd.scd_rxcui from ndc_scd_mv cd where cd.two_part_ndc = pc.two_part_ndc
   )
  ) scds
from mthspl_prod_ndc pc
join mthspl_prod p on p.rxaui = pc.prod_rxaui
-- join
group by pc.two_part_ndc
;
create unique index ix_ndcisoents_ndc on ndc_isoents_mv (two_part_ndc);
