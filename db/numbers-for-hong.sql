--------START OF RXCUI SECTION---------
-- 11,876 rxcuis used by rxnorm,
--case when to have non null
--branded -> generic -> unquantified generic
--make view thats rxcui and makes it more general
select
  d.rxcui             rxnorm_concept_id,
  d.name              rxnorm_drug_name,
  d.prescribable_name prescribable_name,
  d.tty               rxnorm_term_type,
  dgm.non_quantified_rxcui unquantified_rxcui,
  (select d.name from drug_v d where d.rxcui = dgm.non_quantified_rxcui) unquantified_name,
  dgm.generic_rxcui generic_rxcui,
  (select d.name from drug_v d where d.rxcui = dgm.generic_rxcui) generic_name,
  dgm.generic_unquantified_rxcui generic_unquantified_rxcui,
  (select d.name from drug_v d where d.rxcui = dgm.generic_unquantified_rxcui) generic_unquantified_rxcui,
  (
    select coalesce(jsonb_agg(distinct two_part_ndc order by two_part_ndc), '[]'::jsonb)
    from mthspl_prod_ndc pnc
    where pnc.prod_rxaui in (
      select p.rxaui from mthspl_prod p where p.rxcui = d.rxcui
    )
  ) short_ndcs,
  (
    select coalesce(jsonb_agg(distinct code order by code), '[]'::jsonb)
    from mthspl_prod_mktcat_code mkc
    where mkc.prod_rxaui in (
      select p.rxaui from mthspl_prod p where p.rxcui = d.rxcui
    )
    and (mkc.mkt_cat like 'ANDA%' or mkc.mkt_cat like 'NDA%')
  ) application_codes,
  (
    select coalesce(jsonb_agg(distinct spl_set_id order by spl_set_id), '[]'::jsonb)
    from mthspl_prod_setid psi
    where psi.prod_rxaui in (
      select p.rxaui from mthspl_prod p where p.rxcui = d.rxcui
     )
  ) set_ids,
  (
    select coalesce(jsonb_agg(distinct rxp.name order by rxp.name), '[]'::jsonb)
    from mthspl_prod rxp
    where rxp.rxcui = d.rxcui
  ) product_names
from drug_v d
join drug_generalized_mv dgm on d.rxcui = dgm.rxcui
where exists(
        select 1 from mthspl_rxprod_v rxp where rxp.rxcui = d.rxcui
      )
;

--5,830 quantified human rx SCD
create or replace view mthspl_humanrx_generalized_scd_v as
select
  d.rxcui            rxnorm_concept_id,
  d.name             rxnorm_drug_name,
  d.prescribable_name prescribable_name,
  d.tty              rxnorm_term_type,
  dgm.non_quantified_rxcui unquantified_rxcui,
  (select d.name from drug_v d where d.rxcui = dgm.non_quantified_rxcui) unquantified_name,
  (
    select coalesce(jsonb_agg(distinct two_part_ndc order by two_part_ndc), '[]'::jsonb)
    from mthspl_prod_ndc pnc
    where pnc.prod_rxaui in (
      select p.rxaui from mthspl_prod p where p.rxcui = d.rxcui
    )
  ) short_ndcs,
  (
    select coalesce(jsonb_agg(distinct code order by code), '[]'::jsonb)
    from mthspl_prod_mktcat_code mkc
    where mkc.prod_rxaui in (
      select p.rxaui from mthspl_prod p where p.rxcui = d.rxcui
    )
    and (mkc.mkt_cat like 'ANDA%' or mkc.mkt_cat like 'NDA%')
  ) application_codes,
  (
    select coalesce(jsonb_agg(distinct spl_set_id order by spl_set_id), '[]'::jsonb)
    from mthspl_prod_setid psi
    where psi.prod_rxaui in (
      select p.rxaui from mthspl_prod p where p.rxcui = d.rxcui
     )
  ) set_ids,
  (
    select coalesce(jsonb_agg(distinct rxp.name order by rxp.name), '[]'::jsonb)
    from mthspl_prod rxp
    where rxp.rxcui = d.rxcui
  ) product_names
from drug_v d
join drug_generalized_mv dgm on d.rxcui = dgm.rxcui
where exists(
        select 1 from mthspl_rxprod_v rxp where rxp.rxcui = d.rxcui
      )
and d.tty = 'SCD'
and (d.quantified = 'Y' or d.quantified is null)
;

--human rx rxncuis from mthspl not in drug: 2,682
select
  rxp.rxcui,
  coalesce(jsonb_agg(distinct rxp.name), '[]'::jsonb)            product_names,
  coalesce(jsonb_agg(distinct rxp.short_ndc_codes), '[]'::jsonb) short_ndcs,
  coalesce(jsonb_agg(distinct rxp.set_ids), '[]'::jsonb)         set_ids,
  coalesce(jsonb_agg(distinct rxp.mkt_cat_codes), '[]'::jsonb)   appl_codes,
  coalesce(jsonb_agg(distinct rxp.label_types), '[]'::jsonb)     label_types
from mthspl_rxprod_v rxp
where rxp.rxcui not in (
  select rxcui from drug_v d
  )
group by rxp.rxcui
;

--human rx products from mthspl not in drug: 4,128
select *
from mthspl_rxprod_v
where rxcui not in (select rxcui from drug_v)
order by rxcui
;

--14,558 total rxcuis in rxprod
select distinct rxcui
from mthspl_rxprod_v rp
;

--56,334 total rxcuis in prod
select distinct rxcui
from mthspl_prod_v;
--------END OF RXCUI SECTION---------

------START OF APPL CODE SECTION-----
--800 distinct nda/anda codes have no product associated to an rxnorm drug
select distinct pmc.code
from mthspl_prod_mktcat_code pmc
where
  not exists (
    select 1
    from mthspl_prod p
    where p.rxaui = pmc.prod_rxaui
    and p.rxcui in (select d.rxcui from drug_v d)
  )
and (pmc.code like 'ANDA%' or pmc.code like 'NDA%')
and pmc.prod_rxaui in (
  select rxaui from mthspl_rxprod_v
  )
;

--12,137
select *
from mthspl_mktcode_rxprod_drug_v mrd
;

--5,473
select *
from mthspl_mktcode_rxprod_drug_v mrd
where jsonb_array_length(mrd.generic_names) > 1
;

--6,328
select *
from mthspl_mktcode_rxprod_drug_v mrd
where jsonb_array_length(mrd.generic_names) = 1
and mrd.generic_names <> '[]'::jsonb
;
-----END OF APPL CODE SECTION--------

-----START OF NDC SECTION-------
--2,957 distinct short ndc codes have no product associated to an rxnorm drug
select distinct pn.two_part_ndc short_ndc
from mthspl_prod_ndc pn
where
  not exists (
    select 1
    from mthspl_prod p
    where p.rxaui = pn.prod_rxaui
    and p.rxcui in (select d.rxcui from drug_v d)
  )
and pn.prod_rxaui in (
  select rxp.rxaui from mthspl_rxprod_v rxp
  )
;

--68,816
select *
from mthspl_ndc_rxprod_drug_v
;

-- 63,351
select *
from mthspl_ndc_rxprod_drug_v nrd
where jsonb_array_length(nrd.generic_names) = 1
and nrd.generic_names <> '[]'::jsonb
;

--436
select *
from mthspl_ndc_rxprod_drug_v nrd
where jsonb_array_length(nrd.generic_names) > 1
;

------END OF NDC SECTION-----

------START OF SET ID SECTION------
--2,794 distinct setids have no product associated to an rxnorm drug
select distinct ps.spl_set_id set_id
from mthspl_prod_setid ps
where
  not exists (
    select 1
    from mthspl_prod p
    where p.rxaui = ps.prod_rxaui
    and p.rxcui in (select d.rxcui from drug_v d)
  )
and ps.prod_rxaui in (
  select rxp.rxaui from mthspl_rxprod_v rxp
  )
;

--30,186
select *
from mthspl_rxprod_setid_drug_v rsd
where jsonb_array_length(rsd.generic_names) = 1
and rsd.generic_names <> '[]'::jsonb
;

--11,045
select *
from mthspl_rxprod_setid_drug_v rsd
where jsonb_array_length(rsd.generic_names) > 1
;

--43,445
select *
from mthspl_rxprod_setid_drug_v rsd
;
------END OF SET ID SECTION--------

--ingredient level
select * from ingrset where name ilike '%abacavir%';
select * from ingrset where name ilike '%azithromycin%';
--component level
select * from scdc where name ilike '%abacavir%';
select * from scdc where name ilike '%azithromycin%';
--drug dose form level
select * from scdf where name ilike '%abacavir%';
select * from scdf where name ilike '%azithromycin%';
--drug dose form group level
select * from scdg where name ilike '%abacavir%';
select * from scdg where name ilike '%azithromycin%';
--branded component
select * from sbdc where name ilike '%abacavir%';
select * from sbdc where name ilike '%azithromycin%';
--branded drug dose form
select * from sbdf where name ilike '%abacavir%';
select * from sbdf where name ilike '%azithromycin%';
--branded drug dose form group
select * from sbdg where sbdg.name ilike '%Ziagen%' or sbdg.name ilike '%Trizivir%' or sbdg.name ilike '%Epzicom%' or sbdg.name ilike '%Triumeq%';
select * from sbdg where name ilike '%Zithromax%' or name ilike '%ZPAK%' or name ilike '%Zmax%' or name ilike '%Azinthromycin%' or name ilike '%AzaSite%';
--drug level (SCD)
select * from scd_prod_v where rxnorm_drug_name ilike '%abacavir%';
select * from scd_prod_v where rxnorm_drug_name ilike '%azithromycin%';
-- SBD
select * from sbd where name ilike '%abacavir%';
select * from sbd where name ilike '%azithromycin%';
--BN
select * from bn where name ilike '%Ziagen%' or name ilike '%Trizivir%' or name ilike '%Epzicom%' or name ilike '%Triumeq%';
select * from bn where name ilike '%Zithromax%' or name ilike '%ZPAK%' or name ilike '%Zmax%' or name ilike '%Azinthromycin%' or name ilike '%AzaSite%';
--BPCK
select * from bpck where name ilike '%abacavir%';
select * from bpck where name ilike '%azithromycin%';
--GPCK
select * from gpck where name ilike '%abacavir%';
select * from gpck where name ilike '%azithromycin%';
--prod
select * from mthspl_prod_v where name ilike '%abacavir%';
select * from mthspl_prod_v where name ilike '%azithromycin%';


select count(*) from ingrset where tty in ('PIN', 'IN');
select count(*) from ingrset where tty = 'MIN';

select count(distinct scd_rxcui) from mthspl_prod_scd; --10068
select count(distinct sbd_rxcui) from mthspl_prod_sbd; --8318

select count(distinct spl_set_id) from mthspl_prod_setid;--138,586
select count(distinct two_part_ndc) from mthspl_prod_ndc; -- 168,872
select count(distinct code) from mthspl_prod_mktcat_code; --13,055
select count(distinct unii) from mthspl_sub; --12,923
select count(distinct sub_rxaui) from mthspl_prod_sub; --22,217

select i.rxcui, i.name, scdc.*, scd_prod_v.*
from ingr i
join scdc on scdc.ingr_rxcui = i.rxcui
join scdc_scd on scdc_scd.scdc_rxcui = scdc.rxcui
join scd_prod_v on scd_prod_v.rxnorm_concept_id = scdc_scd.scd_rxcui
where i.name like '%abacavir%'
;

select i.rxcui, i.name, s.*, scd_prod_v.*
from ingr i
join scdf_ingr si on i.rxcui = si.ingr_rxcui
join scdf s on si.scdf_rxcui = s.rxcui
join scdf_scd ss on s.rxcui = ss.scdf_rxcui
join scd_prod_v on scd_prod_v.rxnorm_concept_id = ss.scd_rxcui
where i.name like '%abacavir%';

select i.rxcui, i.name, scdg.*, scd_prod_v.*
from ingr i
join scdg_ingr si on si.ingr_rxcui = i.rxcui
join scdg on scdg.rxcui = si.scdg_rxcui
join scdg_scd ss on scdg.rxcui = ss.scdg_rxcui
join scd_prod_v on scd_prod_v.rxnorm_concept_id = ss.scd_rxcui
where i.name like '%abacavir%';


create or replace view scd_prod_v as
select
  d.rxcui             rxnorm_concept_id,
  d.name              rxnorm_drug_name,
  d.prescribable_name as prescribable_name,
  dgm.non_quantified_rxcui unquantified_rxcui,
  (select d.name from drug_v d where d.rxcui = dgm.non_quantified_rxcui) unquantified_name,
  d.ingrset_rxcui,
  (
    select coalesce(jsonb_agg(distinct suv.unii), '[]'::jsonb)
    from scd_unii_v suv
    where suv.scd_rxcui = d.rxcui
  ) uniis,
  (select df.name from df where df.rxcui = d.df_rxcui),
  d.rxterm_form,
  d.avail_strengths,
  d.qual_distinct, d.quantity, d.human_drug, d.vet_drug,
  (
    select coalesce(jsonb_agg(distinct two_part_ndc order by two_part_ndc), '[]'::jsonb)
    from mthspl_prod_ndc pnc
    where pnc.prod_rxaui in (
      select p.rxaui from mthspl_rxprod_v p where p.rxcui = d.rxcui
    )
  ) short_ndcs,
  (
    select coalesce(jsonb_agg(distinct uniis_str(pnc.prod_rxaui)), '[]'::jsonb)
    from mthspl_prod_ndc pnc
    where pnc.prod_rxaui in (
      select p.rxaui from mthspl_rxprod_v p where p.rxcui = d.rxcui
    )
  ) short_ndc_uniis,
  (
    select coalesce(jsonb_agg(distinct code order by code), '[]'::jsonb)
    from mthspl_prod_mktcat_code mkc
    where mkc.prod_rxaui in (
      select p.rxaui from mthspl_rxprod_v p where p.rxcui = d.rxcui
    )
    and (mkc.mkt_cat like 'ANDA%' or mkc.mkt_cat like 'NDA%')
  ) application_codes,
  (
    select coalesce(jsonb_agg(distinct spl_set_id order by spl_set_id), '[]'::jsonb)
    from mthspl_prod_setid psi
    where psi.prod_rxaui in (
      select p.rxaui from mthspl_rxprod_v p where p.rxcui = d.rxcui
     )
  ) set_ids,
  (
    select coalesce(jsonb_agg(distinct rxp.name order by rxp.name), '[]'::jsonb)
    from mthspl_rxprod_v rxp
    where rxp.rxcui = d.rxcui
  ) product_names
from scd d
join drug_generalized_mv dgm on d.rxcui = dgm.rxcui
where exists(
        select 1 from mthspl_rxprod_v rxp where rxp.rxcui = d.rxcui
)
;

--azithromycin
--abacavir

select *
from temp_mkstat_v
where jsonb_array_length(prod_uniis) > 1 and market_catergory ilike '%NDA%'
and rxnorm_cuis <> '[]'::jsonb
order by market_catergory desc
;
--["HYDROCHLOROTHIAZIDE / LOSARTAN / LOSARTAN POTASSIUM", "TOPIRAMATE"]
--ANDA078235,ANDA,"[""HYDROCHLOROTHIAZIDE 25 mg / LOSARTAN POTASSIUM 100 mg ORAL TABLET, FILM COATED"", ""TOPIRAMATE 100 mg ORAL TABLET, FILM COATED"", ""TOPIRAMATE 200 mg ORAL TABLET, FILM COATED"", ""TOPIRAMATE 25 mg ORAL TABLET, FILM COATED"", ""TOPIRAMATE 50 mg ORAL TABLET, FILM COATED"", ""TOPIRAMATE 50 mg ORAL TABLET, FILM COATED [Topamax]""]"

--multiple setid per ndc
select short_ndc, product_name, prod_uniis, set_ids, rxnorm_drug_names
from mthspl_ndc_prod_drug_v
group by short_ndc, product_name, prod_uniis, set_ids, rxnorm_drug_names
having jsonb_array_length(set_ids) > 1;

--multiple appl code per ndc
select short_ndc, product_name, prod_uniis, application_codes, rxnorm_drug_names
from mthspl_ndc_prod_drug_v
group by short_ndc, product_name, prod_uniis, application_codes, rxnorm_drug_names
having jsonb_array_length(application_codes) > 1;

create or replace view temp_mkstat_v as
select
  pmcc.code                                                     application_code,
  pmcc.mkt_cat                                                  market_catergory,
  coalesce(jsonb_agg(distinct p.name), '[]'::jsonb)             product_name,
  coalesce(jsonb_agg(distinct p.code), '[]'::jsonb)             product_code,
  (select coalesce(jsonb_agg(distinct pn.two_part_ndc), '[]'::jsonb)
   from mthspl_prod_ndc pn
   where pn.prod_rxaui in (
     select pmc.prod_rxaui
     from mthspl_prod_mktcat_code pmc
     where pmc.code = pmcc.code
   ))                                                           ndcs,
  (select coalesce(jsonb_agg(distinct spl_set_id), '[]'::jsonb)
   from mthspl_prod_setid ps
   where ps.prod_rxaui in (
     select pmc.prod_rxaui
     from mthspl_prod_mktcat_code pmc
     where pmc.code = pmcc.code
   ))                                                           set_ids,
  (select coalesce(jsonb_agg(distinct label_type), '[]'::jsonb)
   from mthspl_prod_labeltype plt
   where plt.prod_rxaui in (
     select pmc.prod_rxaui
     from mthspl_prod_mktcat_code pmc
     where pmc.code = pmcc.code
   ))                                                           label_types,
  (select coalesce(jsonb_agg(distinct labeler), '[]'::jsonb)
   from mthspl_prod_labeler pl
   where pl.prod_rxaui in (
     select pmc.prod_rxaui
     from mthspl_prod_mktcat_code pmc
     where pmc.code = pmcc.code
   ))                                                           labelers,
  coalesce(jsonb_agg(distinct uniis_str(pmcc.prod_rxaui)), '[]'::jsonb) prod_uniis,
  (select coalesce(jsonb_agg(distinct jsonb_build_object(
       'ingrType', s.ingr_type,
       'rxaui', s.sub_rxaui,
       'rxcui', s.sub_rxcui,
       'unii', s.sub_unii,
       'biologicCode', s.sub_biologic_code,
       'name', s.sub_name,
       'suppress', s.sub_suppress)), '[]'::jsonb)
   from mthspl_prod_sub_v s
   where s.prod_rxaui in (
     select pmc.prod_rxaui
     from mthspl_prod_mktcat_code pmc
     where pmc.code = pmcc.code
   ))                                                           product_substances,
   coalesce(jsonb_agg(distinct sub_name(pmcc.prod_rxaui)), '[]'::jsonb) sub_name,
   coalesce(jsonb_agg(distinct i.name)
    filter (where i.name is not null), '[]'::jsonb)                ingrset_name,
  coalesce(jsonb_agg(distinct d.rxcui)
    filter (where d.rxcui is not null), '[]'::jsonb)                        rxnorm_cuis,
  coalesce(jsonb_agg(distinct d.tty)
    filter (where d.tty is not null), '[]'::jsonb)                          rxnorm_term_types,
  coalesce(jsonb_agg(distinct d.name)
    filter (where d.name is not null), '[]'::jsonb)                         rxnorm_drug_names,
  coalesce(jsonb_agg(distinct d.prescribable_name)
    filter (where d.prescribable_name is not null), '[]'::jsonb)             rxnorm_prescribable_names,
  coalesce(jsonb_agg(distinct dgm.non_quantified_rxcui)
    filter (where dgm.non_quantified_rxcui is not null), '[]'::jsonb)       rxnorm_unquantified_cuis,
  coalesce(jsonb_agg(distinct drug_name(dgm.non_quantified_rxcui))
    filter (where dgm.non_quantified_rxcui is not null), '[]'::jsonb)      unquantified_names,
  coalesce(jsonb_agg(distinct dgm.generic_rxcui)
    filter (where dgm.generic_rxcui is not null), '[]'::jsonb)              rxnorm_generic_cuis,
  coalesce(jsonb_agg(distinct drug_name(dgm.generic_rxcui))
    filter (where dgm.generic_rxcui is not null), '[]'::jsonb)      generic_names,
  coalesce(jsonb_agg(distinct dgm.generic_unquantified_rxcui)
    filter (where dgm.generic_unquantified_rxcui is not null), '[]'::jsonb) rxnorm_unquantified_generic_cuis,
  coalesce(jsonb_agg(distinct drug_name(dgm.generic_unquantified_rxcui))
    filter (where dgm.generic_unquantified_rxcui is not null), '[]'::jsonb) generic_unqualified_names
from mthspl_prod_mktcat_code pmcc
join mthspl_prod p on p.rxaui = pmcc.prod_rxaui
left join scd d on d.rxcui = p.rxcui
left join ingrset i on i.rxcui = d.ingrset_rxcui
left join drug_generalized_mv dgm on d.rxcui = dgm.rxcui
where p.rxaui in (
    select mpl.prod_rxaui
    from mthspl_prod_labeltype mpl
    where mpl.label_type = 'HUMAN PRESCRIPTION DRUG LABEL' or mpl.label_type = 'HUMAN PRESCRIPTION DRUG LABEL WITH HIGHLIGHTS'
)
group by pmcc.code, pmcc.mkt_cat
;