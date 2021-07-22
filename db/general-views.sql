create view in_unii_v as
select distinct s.in_rxcui, s.unii
from mthspl_sub s
join "in" i on i.rxcui = s.in_rxcui
;

create view pin_unii_v as
select distinct s.pin_rxcui, s.unii
from mthspl_sub s
join pin i on i.rxcui = s.pin_rxcui
;

create or replace view scd_unii_v as
select scd.rxcui as scd_rxcui, iu.unii as unii
from scdc_scd
join scd on scdc_scd.scd_rxcui = scd.rxcui
join scdc on scdc_scd.scdc_rxcui = scdc.rxcui
join "in" i on i.rxcui = scdc.in_rxcui
join in_unii_v iu on iu.in_rxcui = i.rxcui
union
select scd.rxcui as scd_rxcui, piu.unii as unii
from scdc_scd
join scd on scdc_scd.scd_rxcui = scd.rxcui
join scdc on scdc_scd.scdc_rxcui = scdc.rxcui
join pin i on i.rxcui = scdc.pin_rxcui
join pin_unii_v piu on piu.pin_rxcui = i.rxcui
;
comment on view scd_unii_v is 'Pairs of SCD/UNII-CUI for both IN and PIN ingredients.';

