insert into mthspl_sub (rxaui, rxcui, unii, biologic_code, name, suppress)
select
  c.rxaui,
  c.rxcui,
  case when length(c.code) = 10 then c.code end,
  case when length(c.code) >= 17 then c.code end,
  c.str as name,
  c.suppress
from rxnconso c
where c.sab = 'MTHSPL' and c.tty = 'SU'
;

insert into mthspl_prod (rxaui, rxcui, code, rxnorm_created, name, suppress, ambiguity_flag)
select
  c.rxaui,
  c.rxcui,
  case when c.code <> 'NOCODE' then c.code end,
  case when c.tty = 'MTH_RXN_DP' then 1 else 0 end,
  c.str as name,
  c.suppress,
  (select a.atv from rxnsat a where a.rxaui = c.rxaui and a.atn = 'AMBIGUITY_FLAG') ambiguity_flag
from rxnconso c
where c.sab='MTHSPL' and c.tty in ('DP','MTH_RXN_DP')
;

insert into mthspl_sub_setid (sub_rxaui, set_id, suppress)
select a.rxaui, a.atv, a.suppress
from mthspl_sub s
join rxnsat a on a.rxaui = s.rxaui and a.atn = 'SPL_SET_ID'
;

insert into mthspl_ingrtype (ingr_type, description) values('I', 'inactive ingredient');
insert into mthspl_ingrtype (ingr_type, description) values('A', 'active ingredient');
insert into mthspl_ingrtype (ingr_type, description) values('M', 'active moiety');

insert into mthspl_prod_sub (prod_rxaui, ingr_type, sub_rxaui)
select
  r.rxaui2 prod_rxaui,
  case when r.rela='has_active_ingredient' then 'A'
       when r.rela='has_active_moiety' then 'M'
       else 'I' end ingr_type,
  r.rxaui1 sub_rxaui
from rxnrel r
where
  r.sab='MTHSPL' and
  r.rela IN ('has_active_ingredient','has_inactive_ingredient','has_active_moiety')
;

insert into mthspl_prod_dmspl
select distinct p.rxaui, a.atv dm_spl_id
from mthspl_prod p
join rxnsat a on a.rxaui = p.rxaui and a.atn = 'DM_SPL_ID'
;

insert into mthspl_prod_setid
select distinct p.rxaui, a.atv dm_spl_id
from mthspl_prod p
join rxnsat a on a.rxaui = p.rxaui and a.atn = 'SPL_SET_ID'
;

insert into mthspl_prod_ndc
select p.rxaui, a.atv full_ndc, regexp_replace(a.atv , '-[0-9]+$', '') two_part_ndc
from mthspl_prod p
join rxnsat a on a.rxaui = p.rxaui and a.atn = 'NDC'
;

insert into mthspl_prod_labeler
select p.rxaui, a.atv
from mthspl_prod p
join rxnsat a on a.rxaui = p.rxaui and a.atn = 'LABELER'
;

insert into mthspl_prod_labeltype
select p.rxaui, a.atv
from mthspl_prod p
join rxnsat a on a.rxaui = p.rxaui and a.atn = 'LABEL_TYPE'
;

insert into mthspl_prod_mktcat
select p.rxaui, a.atv
from mthspl_prod p
join rxnsat a on a.rxaui = p.rxaui and a.atn = 'MARKETING_CATEGORY'
;

insert into mthspl_prod_mktstat
select p.rxaui, a.atv
from mthspl_prod p
join rxnsat a on a.rxaui = p.rxaui and a.atn = 'MARKETING_STATUS'
;

insert into mthspl_prod_mkteffth
select p.rxaui, a.atv
from mthspl_prod p
join rxnsat a on a.rxaui = p.rxaui and a.atn = 'MARKETING_EFFECTIVE_TIME_HIGH'
;

insert into mthspl_prod_mktefftl
select p.rxaui, a.atv
from mthspl_prod p
join rxnsat a on a.rxaui = p.rxaui and a.atn = 'MARKETING_EFFECTIVE_TIME_LOW'
;

insert into mthspl_prod_dcsa
select p.rxaui, a.atv
from mthspl_prod p
join rxnsat a on a.rxaui = p.rxaui and a.atn = 'DCSA'
;

insert into mthspl_prod_nhric
select p.rxaui, a.atv
from mthspl_prod p
join rxnsat a on a.rxaui = p.rxaui and a.atn = 'NHRIC'
;

insert into mthspl_mktcat (name) values('NDA');
insert into mthspl_mktcat (name) values('ANDA');
insert into mthspl_mktcat (name) values('NADA');
insert into mthspl_mktcat (name) values('CONDITIONAL_NADA');
insert into mthspl_mktcat (name) values('NDA_AUTHORIZED_GENERIC');
insert into mthspl_mktcat (name) values('ANADA');
insert into mthspl_mktcat (name) values('BLA');
insert into mthspl_mktcat (name) values('DIETARY_SUPPLEMENT');
insert into mthspl_mktcat (name) values('EXEMPT_DEVICE');
insert into mthspl_mktcat (name) values('OTC_MONOGRAPH_FINAL');
insert into mthspl_mktcat (name) values('OTC_MONOGRAPH_NOT_FINAL');
insert into mthspl_mktcat (name) values('LEGALLY_MARKETED_UNAPPROVED_NEW_ANIMAL_DRUGS_FOR_MINOR_SPECIES');
insert into mthspl_mktcat (name) values('PREMARKET_APPLICATION');
insert into mthspl_mktcat (name) values('PREMARKET_NOTIFICATION');
insert into mthspl_mktcat (name) values('UNAPPROVED_DRUG_OTHER');
insert into mthspl_mktcat (name) values('UNAPPROVED_HOMEOPATHIC');
insert into mthspl_mktcat (name) values('UNAPPROVED_MEDICAL_GAS');

insert into mthspl_prod_mktcat_code(prod_rxaui, mkt_cat, code)
select pa.rxaui, mc.name, pa.atv
from (
  select p.rxaui, a.atn, a.atv
  from mthspl_prod p
  join rxnsat a on a.rxaui = p.rxaui
) pa
join mthspl_mktcat mc on mc.name = pa.atn
;

insert into mthspl_pillattr (attr) values('IMPRINT_CODE');
insert into mthspl_pillattr (attr) values('COATING');
insert into mthspl_pillattr (attr) values('COLOR');
insert into mthspl_pillattr (attr) values('COLORTEXT');
insert into mthspl_pillattr (attr) values('SCORE');
insert into mthspl_pillattr (attr) values('SHAPE');
insert into mthspl_pillattr (attr) values('SHAPETEXT');
insert into mthspl_pillattr (attr) values('SIZE');
insert into mthspl_pillattr (attr) values('SYMBOL');

insert into mthspl_prod_pillattr(prod_rxaui, attr, attr_val)
select pa.rxaui, a.attr, pa.atv
from (
  select p.rxaui, a.atn, a.atv
  from mthspl_prod p
  join rxnsat a on a.rxaui = p.rxaui
) pa
join mthspl_pillattr a on a.attr = pa.atn
;
-------------------------------------------------------------------------------------------------------------------

--code snippet for quantified
/*
case when exists(
    select 1 from rxnrel rel
    where rel.rela = 'has_quantified_form' and rel.rxcui1 = c.rxcui
    ) then 'Y'
    when exists(select 1 from rxnrel rel
    where rel.rela = 'quantified_form_of' and rel.rxcui1 = c.rxcui
    ) then 'N'
    end quantified,
*/

insert into df (rxcui, rxaui, name, origin, code)
select
  c.rxcui,
  c.rxaui,
  c.str,
  (select s.atv from rxnsat s where s.sab = 'RXNORM' and s.atn = 'ORIG_SOURCE' and s.rxcui = c.rxcui),
  (select s.atv from rxnsat s where s.sab = 'RXNORM' and s.atn = 'ORIG_CODE' and s.rxcui = c.rxcui)
from rxnconso c
where c.sab = 'RXNORM'
and c.tty = 'DF'
;

insert into dfg (rxcui, rxaui, name)
select
  c.rxcui,
  c.rxaui,
  c.str
from rxnconso c
where c.sab = 'RXNORM'
and c.tty = 'DFG'
;

insert into df_dfg (df_rxcui, dfg_rxcui)
select
  df.rxcui,
  dfg.rxcui
from rxnrel r
join df on df.rxcui = r.rxcui1
join dfg on dfg.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'inverse_isa'
;

insert into et (rxcui, rxaui, name)
select
  c.rxcui,
  c.rxaui,
  c.str
from rxnconso c
where c.sab = 'RXNORM'
and c.tty = 'ET'
;


insert into ingr (rxcui, rxaui, name, suppress)
select distinct
  c.rxcui,
  c.rxaui,
  c.str as name,
  c.suppress
from rxnconso c
where sab='RXNORM'
and tty = 'IN'
;

insert into pin (rxcui, rxaui, name, suppress)
select distinct
  c.rxcui,
  c.rxaui,
  c.str as name,
  c.suppress
from rxnconso c
where sab='RXNORM'
and tty = 'PIN'
;

insert into ingr_pin (ingr_rxcui, pin_rxcui)
select
  i.rxcui,
  p.rxcui
from rxnrel r
join ingr i on i.rxcui = r.rxcui1
join pin p on p.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'form_of'
;

insert into min (rxcui, rxaui, name, suppress)
select distinct
  c.rxcui,
  c.rxaui,
  c.str as name,
  c.suppress
from rxnconso c
where sab='RXNORM'
and tty = 'MIN'
;

insert into ingr_unii(ingr_rxcui, unii)
select distinct
  i.rxcui,
  s.unii
from ingr i
join mthspl_sub s on s.rxcui = i.rxcui
where s.unii is not null
;

insert into pin_unii (pin_rxcui, unii)
select distinct
  pi.rxcui,
  s.unii
from pin pi
join mthspl_sub s on s.rxcui = pi.rxcui
where s.unii is not null
;

--temp table
insert into temp_ingrset (drug_rxcui, ingr_rxcui, ingr_rxaui, ingr_name, ingr_suppress, ingr_tty)
with scd_nomin as ( -- SCDs with no MIN
  select scd.rxcui
  from rxnconso scd
  where scd.sab = 'RXNORM' and scd.tty = 'SCD' and scd.rxcui not in (
   select scd.rxcui
   from rxnrel r
   join rxnconso scd on scd.rxcui = r.rxcui1
   join rxnconso min on min.rxcui = r.rxcui2
   where r.sab = 'RXNORM' and r.rela = 'ingredients_of'
   and scd.sab = 'RXNORM' and scd.tty = 'SCD'
   and min.sab = 'RXNORM' and min.tty = 'MIN'
  )
),
scd_scdc as ( -- SCDCs that have no MIN
  select scdc.rxcui scdc_rxcui, scdc.str scdc_str, r.rela, scd.rxcui scd_rxcui, scd.str scd_str
  from rxnrel r
  join rxnconso scd on scd.rxcui = r.rxcui1
  join rxnconso scdc on scdc.rxcui = r.rxcui2
  join scd_nomin sn on sn.rxcui = scd.rxcui
  where r.sab = 'RXNORM' and r.rela = 'constitutes'
  and scd.sab = 'RXNORM' and scd.tty = 'SCD'
  and scdc.sab = 'RXNORM' and scdc.tty = 'SCDC'
)
select distinct scd.*, i.*
from scd_nomin scd,
lateral (
  select ingr.rxcui, ingr.rxaui, ingr.str, ingr.suppress, ingr.tty
  from rxnrel r
  join scd_scdc on scd_scdc.scdc_rxcui = r.rxcui1
  join rxnconso ingr on ingr.rxcui = r.rxcui2
  where r.sab = 'RXNORM' and r.rela in ('ingredient_of', 'precise_ingredient_of')
  and ingr.sab = 'RXNORM' and ingr.tty in ('IN', 'PIN')
  and scd.rxcui = scd_scdc.scd_rxcui
  order by ingr.tty desc --prefer PIN over IN
  limit 1
) i
;

insert into temp_ingrset (drug_rxcui, ingr_rxcui, ingr_rxaui, ingr_name, ingr_suppress, ingr_tty)
select scd.rxcui, m.rxcui, m.rxaui, m.name, m.suppress, 'MIN'
from rxnrel r
join min m on m.rxcui = r.rxcui2
join rxnconso scd on scd.rxcui = r.rxcui1
where r.rela = 'ingredients_of' and r.sab = 'RXNORM'
and scd.tty = 'SCD' and scd.sab = 'RXNORM'
;

insert into ingrset (rxcui, rxaui, name, suppress, tty)
select distinct ingr_rxcui, ingr_rxaui, ingr_name, ingr_suppress, ingr_tty from temp_ingrset
;

insert into scd (rxcui, rxaui, tty, name, prescribable_name, rxterm_form, df_rxcui, ingrset_rxcui, avail_strengths, qual_distinct, suppress, quantity, human_drug, vet_drug, unquantified_form_rxcui)
select
  c.rxcui,
  c.rxaui,
  c.tty,
  c.str,
  (select psn.str from rxnconso psn where psn.tty = 'PSN' and psn.rxcui = c.rxcui) psn,
  (select s.atv from rxnsat s where s.sab = 'RXNORM' and s.rxcui = c.rxcui and s.atn = 'RXTERM_FORM'),
  (select df.rxcui
   from rxnrel r
   join df on df.rxcui = r.rxcui2
   where r.sab = 'RXNORM' and r.rela = 'dose_form_of'
   and r.rxcui1 = c.rxcui
  ),
  (select ingr_rxcui from temp_ingrset where drug_rxcui = c.rxcui) ingr_rxcui,
  (select s.atv from rxnsat s where s.sab = 'RXNORM' and s.rxcui = c.rxcui and s.atn = 'RXN_AVAILABLE_STRENGTH'),
  (select s.atv from rxnsat s where s.sab = 'RXNORM' and s.rxcui = c.rxcui and s.atn = 'RXN_QUALITATIVE_DISTINCTION'),
  c.suppress,
  (select s.atv from rxnsat s where s.sab = 'RXNORM' and s.rxcui = c.rxcui and s.atn = 'RXN_QUANTITY'),
   case when
     exists (select s.atv from rxnsat s where s.sab = 'RXNORM' and s.rxcui = c.rxcui and s.atn = 'RXN_HUMAN_DRUG')
    then 1
   else 0 end,
   case when
    exists (select s.atv from rxnsat s where s.sab = 'RXNORM' and s.rxcui = c.rxcui and s.atn = 'RXN_VET_DRUG')
    then 1
   else 0 end,
   (select scd2.rxcui
   from rxnrel r
   join rxnconso scd2 on scd2.rxcui = r.rxcui1
    where r.sab = 'RXNORM' and r.rela = 'quantified_form_of'
      and scd2.sab = 'RXNORM' and scd2.tty = 'SCD'
      and c.rxcui = r.rxcui2
  )
from rxnconso c
where c.sab='RXNORM'
and c.tty = 'SCD'
;

insert into sbd (rxcui, rxaui, tty, name, prescribable_name, rxterm_form, df_rxcui, avail_strengths, qual_distinct, suppress, quantity, human_drug, vet_drug, unquantified_form_rxcui)
select
  c.rxcui,
  c.rxaui,
  c.tty,
  c.str,
  (select psn.str from rxnconso psn where psn.tty = 'PSN' and psn.rxcui = c.rxcui) psn,
  (select s.atv from rxnsat s where s.sab = 'RXNORM' and s.rxcui = c.rxcui and s.atn = 'RXTERM_FORM'),
  (select df.rxcui
   from rxnrel r
   join df on df.rxcui = r.rxcui2
   where r.sab = 'RXNORM' and r.rela = 'dose_form_of'
   and r.rxcui1 = c.rxcui
  ),
  (select s.atv from rxnsat s where s.sab = 'RXNORM' and s.rxcui = c.rxcui and s.atn = 'RXN_AVAILABLE_STRENGTH'),
  (select s.atv from rxnsat s where s.sab = 'RXNORM' and s.rxcui = c.rxcui and s.atn = 'RXN_QUALITATIVE_DISTINCTION'),
  c.suppress,
  (select s.atv from rxnsat s where s.sab = 'RXNORM' and s.rxcui = c.rxcui and s.atn = 'RXN_QUANTITY'),
  case when exists (
    select s.atv from rxnsat s where s.sab = 'RXNORM' and s.rxcui = c.rxcui and s.atn = 'RXN_HUMAN_DRUG'
  )
  then 1
  else 0 end,
  case when exists (
    select s.atv from rxnsat s where s.sab = 'RXNORM' and s.rxcui = c.rxcui and s.atn = 'RXN_VET_DRUG'
  )
  then 1
  else 0 end,
  (select sbd2.rxcui
   from rxnrel r
   join rxnconso sbd2 on sbd2.rxcui = r.rxcui1
   where r.sab = 'RXNORM' and r.rela = 'quantified_form_of'
   and sbd2.sab = 'RXNORM' and sbd2.tty = 'SBD'
   and c.rxcui = r.rxcui2
  )
from rxnconso c
where
  c.sab='RXNORM' and
  c.tty = 'SBD'
;

insert into gpck (rxcui, rxaui, tty, name, prescribable_name, df_rxcui, suppress, human_drug)
select
  c.rxcui,
  c.rxaui,
  c.tty,
  c.str,
  (select psn.str from rxnconso psn where psn.tty = 'PSN' and psn.rxcui = c.rxcui) psn,
  (select df.rxcui
   from rxnrel r
   join df on df.rxcui = r.rxcui2
   where r.sab = 'RXNORM' and r.rela = 'dose_form_of'
   and c.rxcui = r.rxcui1
  ),
  c.suppress,
  case when exists (
    select s.atv from rxnsat s where s.sab = 'RXNORM' and s.rxcui = c.rxcui and s.atn = 'RXN_HUMAN_DRUG'
  )
  then 1
  else 0 end
from rxnconso c
where
  c.sab='RXNORM' and
  c.tty = 'GPCK'
;

insert into bpck (rxcui, rxaui, tty, name, prescribable_name, df_rxcui, suppress, human_drug)
select
  c.rxcui,
  c.rxaui,
  c.tty,
  c.str,
  (select psn.str from rxnconso psn where psn.tty = 'PSN' and psn.rxcui = c.rxcui) psn,
  (select df.rxcui
   from rxnrel r
   join df on df.rxcui = r.rxcui2
   where r.sab = 'RXNORM' and r.rela = 'dose_form_of'
   and c.rxcui = r.rxcui1
  ),
  c.suppress,
  case when exists (
    select s.atv from rxnsat s where s.sab = 'RXNORM' and s.rxcui = c.rxcui and s.atn = 'RXN_HUMAN_DRUG'
  )
  then 1
  else 0 end
from rxnconso c
where
  c.sab='RXNORM' and
  c.tty = 'BPCK'
;

insert into bn (rxcui, rxaui, name, rxn_cardinality, reformulated_to_rxcui)
select
  c.rxcui,
  c.rxaui,
  c.str,
  (select s.atv from rxnsat s where s.atn = 'RXN_BN_CARDINALITY' and s.rxcui = c.rxcui),
  (select c2.rxcui
   from rxnrel r
   join rxnconso c2 on c2.rxcui = r.rxcui2
   where r.sab = 'RXNORM' and r.rela = 'reformulated_to'
   and c2.sab = 'RXNORM' and c2.tty = 'BN'
   and c.rxcui = r.rxcui1
  )
from rxnconso c
where c.tty = 'BN'
and sab = 'RXNORM'
;

insert into scdc (rxcui, rxaui, name, boss_active_ingr_name, boss_active_moi_name, boss_source, rxn_in_expressed_flag, strength, boss_str_num_unit, boss_str_num_val, boss_str_denom_unit, boss_str_denom_val, ingr_rxcui, pin_rxcui)
select
  c.rxcui,
  c.rxaui,
  c.str,
  (select s.atv from rxnsat s where s.atn = 'RXN_BOSS_AI' and s.rxcui = c.rxcui),
  (select s.atv from rxnsat s where s.atn = 'RXN_BOSS_AM' and s.rxcui = c.rxcui),
  (select s.atv from rxnsat s where s.atn = 'RXN_BOSS_FROM' and s.rxcui = c.rxcui),
  (select s.atv from rxnsat s where s.atn = 'RXN_IN_EXPRESSED_FLAG' and s.rxcui = c.rxcui),
  (select s.atv from rxnsat s where s.atn = 'RXN_STRENGTH' and s.rxcui = c.rxcui),
  (select s.atv from rxnsat s where s.atn = 'RXN_BOSS_STRENGTH_NUM_UNIT' and s.rxcui = c.rxcui),
  (select s.atv from rxnsat s where s.atn = 'RXN_BOSS_STRENGTH_NUM_VALUE' and s.rxcui = c.rxcui),
  (select s.atv from rxnsat s where s.atn = 'RXN_BOSS_STRENGTH_DENOM_UNIT' and s.rxcui = c.rxcui),
  (select s.atv from rxnsat s where s.atn = 'RXN_BOSS_STRENGTH_DENOM_VALUE' and s.rxcui = c.rxcui),
  (select i.rxcui
   from rxnrel r
   join ingr i on i.rxcui = r.rxcui2
   where r.rela = 'ingredient_of' and r.sab = 'RXNORM'
   and r.rxcui1 = c.rxcui
   ),
   (select pin.rxcui
   from rxnrel r
   join pin on pin.rxcui = r.rxcui2
   where r.rela = 'precise_ingredient_of' and r.sab = 'RXNORM'
   and r.rxcui1 = c.rxcui
   )
from rxnconso c
where c.tty = 'SCDC' and c.sab = 'RXNORM'
;

insert into scdf (rxcui, rxaui, name, df_rxcui)
select
  c.rxcui,
  c.rxaui,
  c.str,
  (select df.rxcui
   from rxnrel r
   join df on df.rxcui = r.rxcui2
   where r.sab = 'RXNORM' and r.rela = 'dose_form_of'
   and c.rxcui = r.rxcui1
  )
from rxnconso c
where c.sab = 'RXNORM'
and c.tty = 'SCDF'
;

insert into scdg (rxcui, rxaui, name, dfg_rxcui)
select
  c.rxcui,
  c.rxaui,
  c.str,
  (select dfg.rxcui
   from rxnrel r
   join dfg on dfg.rxcui = r.rxcui2
   where r.sab = 'RXNORM' and r.rela = 'doseformgroup_of'
   and c.rxcui = r.rxcui1
  )
from rxnconso c
where c.sab = 'RXNORM'
and c.tty = 'SCDG'
;

insert into scdg_astr (scdg_rxcui, RXN_AVAILABLE_STRENGTH)
select
  scdg.rxcui,
  s.atv
from rxnsat s
join scdg on scdg.rxcui = s.rxcui
where s.sab = 'RXNORM'
and s.atn = 'RXN_AVAILABLE_STRENGTH'
;

insert into sbdc (rxcui, rxaui, name)
select
  c.rxcui,
  c.rxaui,
  c.str
from rxnconso c
where c.sab = 'RXNORM'
and c.tty = 'SBDC'
;

insert into sbdf (rxcui, rxaui, name, df_rxcui)
select
  c.rxcui,
  c.rxaui,
  c.str,
   (select df.rxcui
   from rxnrel r
   join df on df.rxcui = r.rxcui2
   where r.sab = 'RXNORM' and r.rela = 'dose_form_of'
   and c.rxcui = r.rxcui1
  )
from rxnconso c
where c.sab = 'RXNORM'
and c.tty = 'SBDF'
;

insert into sbdg (rxcui, rxaui, name, dfg_rxcui)
select
  c.rxcui,
  c.rxaui,
  c.str,
  (select dfg.rxcui
   from rxnrel r
   join dfg on dfg.rxcui = r.rxcui2
   where r.sab = 'RXNORM' and r.rela = 'doseformgroup_of'
   and c.rxcui = r.rxcui1
  )
from rxnconso c
where c.sab = 'RXNORM'
and c.tty = 'SBDG'
;

insert into sbdg_astr (sbdg_rxcui, RXN_AVAILABLE_STRENGTH)
select
  sbdg.rxcui,
  s.atv
from rxnsat s
join sbdg on sbdg.rxcui = s.rxcui
where s.sab = 'RXNORM'
and s.atn = 'RXN_AVAILABLE_STRENGTH'
;

insert into scd_sy (drug_rxcui, drug_rxaui, synonym, sy_rxaui)
select
  cd.rxcui,
  cd.rxaui,
  c1.str,
  c1.rxaui
from rxnrel r
join rxnconso c1 on c1.rxaui = r.rxaui1
join scd cd on cd.rxaui = r.rxaui2
where rxcui1 is null
and r.sab = 'RXNORM' and c1.sab = 'RXNORM'
and c1.tty = 'SY'
;

insert into sbd_sy (drug_rxcui, drug_rxaui, synonym, sy_rxaui)
select
  bd.rxcui,
  bd.rxaui,
  c1.str,
  c1.rxaui
from rxnrel r
join rxnconso c1 on c1.rxaui = r.rxaui1
join sbd bd on bd.rxaui = r.rxaui2
where rxcui1 is null
and r.sab = 'RXNORM' and c1.sab = 'RXNORM'
and c1.tty = 'SY'
;

insert into sbd_scd (rxcui1, rxcui2)
select
  rel.rxcui1,
  rel.rxcui2
from rxnrel rel
join sbd bd on bd.rxcui = rel.rxcui1
join scd cd on cd.rxcui = rel.rxcui2
where rel.rela = 'has_tradename'
;

insert into mthspl_prod_scd (prod_rxaui, scd_rxcui)
select
  p.rxaui,
  cd.rxcui
from mthspl_prod p
join scd cd on cd.rxcui = p.rxcui
;

insert into mthspl_prod_sbd (prod_rxaui, sbd_rxcui)
select
  p.rxaui,
  bd.rxcui
from mthspl_prod p
join sbd bd on bd.rxcui = p.rxcui
;

insert into scdc_sbd (scdc_rxcui, sbd_rxcui)
select
  scdc.rxcui,
  sbd.rxcui
from rxnrel r
join scdc on scdc.rxcui = r.rxcui1
join sbd on sbd.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'consists_of'
;

insert into scdc_scd (scdc_rxcui, scd_rxcui)
select
  scdc.rxcui,
  scd.rxcui
from rxnrel r
join scdc on scdc.rxcui = r.rxcui1
join scd on scd.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'consists_of'
;

insert into scdc_sbdc (scdc_rxcui, sbdc_rxcui)
select
  scdc.rxcui,
  sbdc.rxcui
from rxnrel r
join scdc on scdc.rxcui = r.rxcui1
join sbdc on sbdc.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'tradename_of'
;


insert into scdf_ingr (scdf_rxcui, ingr_rxcui)
select
 scdf.rxcui,
 i.rxcui
from rxnrel r
join scdf on scdf.rxcui = r.rxcui1
join ingr i on i.rxcui = r.rxcui2
where r.rela = 'ingredient_of'
and r.sab = 'RXNORM'
;

insert into scdf_scdg (scdf_rxcui, scdg_rxcui)
select
 scdf.rxcui,
 scdg.rxcui
from rxnrel r
join scdf on scdf.rxcui = r.rxcui1
join scdg on scdg.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'inverse_isa'
;

insert into scdf_scd (scdf_rxcui, scd_rxcui)
select
  scdf.rxcui,
  scd.rxcui
from rxnrel r
join scdf on scdf.rxcui = r.rxcui1
join scd on scd.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'isa'
;

insert into scdf_sbdf (scdf_rxcui, sbdf_rxcui)
select
  scdf.rxcui,
  sbdf.rxcui
from rxnrel r
join scdf on scdf.rxcui = r.rxcui1
join sbdf on sbdf.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'tradename_of'
;

insert into scdg_ingr (scdg_rxcui, ingr_rxcui)
select
  scdg.rxcui,
  ingr.rxcui
from rxnrel r
join scdg on scdg.rxcui = r.rxcui1
join ingr on ingr.rxcui = r.rxcui2
where r.rela = 'ingredient_of'
and r.sab = 'RXNORM'
;

insert into scdg_scd (scdg_rxcui, scd_rxcui)
select
  scdg.rxcui,
  scd.rxcui
from rxnrel r
join scdg on scdg.rxcui = r.rxcui1
join scd on scd.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'isa'
;

insert into scdg_sbdg (scdg_rxcui, sbdg_rxcui)
select
  scdg.rxcui,
  sbdg.rxcui
from rxnrel r
join scdg on scdg.rxcui = r.rxcui1
join sbdg on sbdg.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'tradename_of'
;


insert into gpck_bpck (gpck_rxcui, bpck_rxcui)
select
  g.rxcui,
  b.rxcui
from rxnrel r
join gpck g on g.rxcui = r.rxcui1
join bpck b on b.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'tradename_of'
;

insert into gpck_scd (gpck_rxcui, scd_rxcui)
select
  g.rxcui,
  s.rxcui
from rxnrel r
join gpck g on g.rxcui = r.rxcui1
join scd s on s.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'contained_in'
;

insert into bpck_scd (bpck_rxcui, scd_rxcui)
select
  b.rxcui,
  s.rxcui
from rxnrel r
join bpck b on b.rxcui = r.rxcui1
join scd s on s.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'contained_in'
;

insert into bpck_sbd (bpck_rxcui, sbd_rxcui)
select
  b.rxcui,
  s.rxcui
from rxnrel r
join bpck b on b.rxcui = r.rxcui1
join sbd s on s.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'contained_in'
;

insert into sbd_bn (sbd_rxcui, brand_rxcui)
select
  s.rxcui,
  b.rxcui
from rxnrel r
join sbd s on s.rxcui = r.rxcui1
join bn b on b.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'ingredient_of'
;

insert into sbdc_bn (sbdc_rxcui, brand_rxcui)
select
  s.rxcui,
  b.rxcui
from rxnrel r
join sbdc s on s.rxcui = r.rxcui1
join bn b on b.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'ingredient_of'
;

insert into sbdc_sbd (sbdc_rxcui, sbd_rxcui)
select
  s.rxcui,
  b.rxcui
from rxnrel r
join sbdc s on s.rxcui = r.rxcui1
join sbd b on b.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'consists_of'
;

insert into sbdf_bn (sbdf_rxcui, brand_rxcui)
select
  f.rxcui,
  b.rxcui
from rxnrel r
join sbdf f on f.rxcui = r.rxcui1
join bn b on b.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'ingredient_of'
;

insert into sbdf_sbdg (sbdf_rxcui, sbdg_rxcui)
select
  f.rxcui,
  g.rxcui
from rxnrel r
join sbdf f on f.rxcui = r.rxcui1
join sbdg g on g.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'inverse_isa'
;

insert into sbdf_sbd (sbdf_rxcui, sbd_rxcui)
select
  f.rxcui,
  d.rxcui
from rxnrel r
join sbdf f on f.rxcui = r.rxcui1
join sbd d on d.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'isa'
;

insert into sbdg_bn (sbdg_rxcui, brand_rxcui)
select
  g.rxcui,
  b.rxcui
from rxnrel r
join sbdg g on g.rxcui = r.rxcui1
join bn b on b.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'ingredient_of'
;

insert into sbdg_sbd (sbdg_rxcui, sbd_rxcui)
select
  g.rxcui,
  d.rxcui
from rxnrel r
join sbdg g on g.rxcui = r.rxcui1
join sbd d on d.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'isa'
;

insert into bn_ingr (brand_rxcui, ingr_rxcui)
select
  b.rxcui,
  i.rxcui
from rxnrel r
join bn b on b.rxcui = r.rxcui1
join ingr i on i.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'has_tradename'
;

insert into bn_pin (brand_rxcui, pin_rxcui)
select
  b.rxcui,
  p.rxcui
from rxnrel r
join bn b on b.rxcui = r.rxcui1
join pin p on p.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and r.rela = 'precise_ingredient_of'
;
--------------------------------------ATC SECTION------------------------------------------------
insert into atc_drug_class(rxcui, rxaui, atc_code, drug_class, drug_class_level)
select distinct
  c.rxcui,
  c.rxaui,
  c.code,
  c.str,
  (select s.atv from rxnsat s where s.rxaui = c.rxaui and s.atn = 'ATC_LEVEL')
from rxnconso c
join rxnsat s on s.rxaui = c.rxaui
where s.sab = 'ATC'
and s.atn = 'IS_DRUG_CLASS'
;