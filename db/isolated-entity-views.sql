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
