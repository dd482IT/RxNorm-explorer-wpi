create or replace view mthspl_prod_sub_v as
select
  mp.rxaui          prod_rxaui,
  mp.code           prod_code,
  mp.rxnorm_created prod_rxnorm_created,
  mp.name           prod_name,
  mp.suppress       prod_suppress,
  mp.ambiguity_flag prod_ambiguity_flag,
  ps.ingr_type,
  ps.sub_rxaui      sub_rxaui,
  ms.unii           sub_unii,
  ms.biologic_code  sub_biologic_code,
  ms.name           sub_name,
  ms.suppress       sub_suppress
from mthspl_prod_sub ps
join mthspl_prod mp on ps.prod_rxaui = mp.rxaui
join mthspl_sub ms on ms.rxaui = ps.sub_rxaui
;