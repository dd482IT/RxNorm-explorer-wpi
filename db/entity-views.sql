create view ent_scd_v as
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

create materialized view ents_ndc_mv as
select
  pc.two_part_ndc ndc,
  (select coalesce(json_agg(d.*), '[]'::json) from ent_scd_v d where d.rxcui in (
     select cd.scd_rxcui from ndc_scd_mv cd where cd.two_part_ndc = pc.two_part_ndc
  )) scds
from mthspl_prod_ndc pc
join mthspl_prod p on p.rxaui = pc.prod_rxaui
group by pc.two_part_ndc
;
create unique index ix_ndcisoents_ndc on ents_ndc_mv (ndc);
