/*
select 'DROP TABLE IF EXISTS ' || table_name || ' CASCADE;'
from information_schema.tables
where table_schema = 'rxnorm'
and table_name not like 'rxn%'
and (table_name not like 'mthspl%' or table_name in ('mthspl_prod_scd' , 'mthspl_prod_sbd'))
and table_name not like '%v'
;
*/


--TTYs in sab = RXNORM
-- SBD --created table and added attributes
-- SCD --created table and added attributes
-- BPCK --created table and added attributes
-- GPCK --created table and added attributes
-- BN --created table brand name, with cardinality from rxnsat
-- IN --created table and child table for uniis
-- MIN --created table and child table for uniis
-- PIN --created table and child table for uniis
--SBDC created table, no attr
--SBDF created table, no attr
--SCDC created table clin_drug_comp, with attributes from rxnsat.
--SCDF created table, has no attributes but does have rel
--SCDG created table with one attribute
--SBDG created table, no attr
--DFG created table, no atr
--DF created table, two atr
--ET created table, no atr
----PSN done
----SY --done
----TMSY --ignored
-- All relationships mapped
/*
BN,RO,reformulation_of,BN --DONE
PIN,RN,form_of,IN --DONE
BN,RN,tradename_of,IN --DONE
BN,RN,has_precise_ingredient,PIN --DONE
SBD,RN,quantified_form_of,SBD --DONE WITH VIEW
SCD,RN,quantified_form_of,SCD --DONE WITH VIEW
BPCK,RO,has_dose_form,DF --DONE
GPCK,RO,has_dose_form,DF --DONE
SBD,RO,has_dose_form,DF --DONE
MIN,RO,ingredients_of,SCD --DONE
SBDF,RO,has_dose_form,DF --DONE
SCD,RO,has_dose_form,DF --DONE
SCDF,RO,has_dose_form,DF --DONE
DF,RN,isa,DFG --DONE
BPCK,RN,tradename_of,GPCK --DONE
IN,RO,part_of,MIN  --DONE
PIN,RO,part_of,MIN  --DONE
BPCK,RN,contains,SBD --DONE
SBDC,RO,constitutes,SBD --DONE
SCDC,RO,constitutes,SBD  --DONE
BN,RO,ingredient_of,SBD --DONE
BN,RO,ingredient_of,SBDC --DONE
SBD,RN,isa,SBDF --DONE
BN,RO,ingredient_of,SBDF --DONE
SBD,RN,isa,SBDG --DONE
SBDF,RN,isa,SBDG --DONE
DFG,RO,doseformgroup_of,SBDG --DONE
BN,RO,ingredient_of,SBDG --DONE
BPCK,RN,contains,SCD --DONE
GPCK,RN,contains,SCD --DONE
SBD,RN,tradename_of,SCD --DONE
SCDC,RO,constitutes,SCD  --DONE
SBDC,RN,tradename_of,SCDC  --DONE
IN,RO,ingredient_of,SCDC  --DONE
PIN,RO,precise_ingredient_of,SCDC  --DONE
SCD,RN,isa,SCDF  --DONE
SBDF,RN,tradename_of,SCDF --DONE
IN,RO,ingredient_of,SCDF --DONE
SCD,RN,isa,SCDG  --DONE
`SCDF`,RN,isa,SCDG --DONE
SBDG,RN,tradename_of,SCDG  --DONE
DFG,RO,doseformgroup_of,SCDG  --DONE
IN,RO,ingredient_of,SCDG  --DONE
*/



--different sab sources
select c.sab, count(*) src_count
from rxnconso c
where length(c.tty) < 3
group by c.sab
having count(*) > 1000
;

--different types of label types
select count(label_type), label_type from mthspl_prod_labeltype group by label_type;

--different atn used by the sabs
select distinct atn, sab
from rxnsat
order by atn
;
--query returns class type, but class type is a single integer
--1,DRUG_CLASS_TYPE,3819,2628027
select atv, atn, rxcui, rxaui
from rxnsat
where atn = 'DRUG_CLASS_TYPE'
;

-- query returns parent class, but parent class is a single integer
--11,PARENT_CLASS,91079,2627499
select atv, atn, rxcui, rxaui
from rxnsat
where atn = 'PARENT_CLASS'
;

-----------------------------------------------------------------
-- query returns if it is a drug class, returns a yes or no
--Y,IS_DRUG_CLASS,1599783,6821785
select atv, atn, rxcui, rxaui
from rxnsat
where atn = 'IS_DRUG_CLASS'
;

--Selecting drug classes from ATC
select distinct str, tty, rxcui, rxaui, sab from rxnconso where rxcui in (
    select rxnsat.rxcui from rxnsat where atn = 'IS_DRUG_CLASS'
    );
--Antihypertensives for pulmonary arterial hypertension
select * from rxnconso where rxaui = '6821785';
------------------------------------------------------------------

--gives drug classes we want
--[RE513] DECONGESTANT/ANTITUSSIVE/EXPECTORANT,VA_CLASS_NAME,1430404,2627939
select distinct atv, atn, rxcui, rxaui
from rxnsat
where atn = 'VA_CLASS_NAME'
;

--how many ttys in MTHSPL
select count(tty), tty
from rxnconso
where sab = 'MTHSPL'
group by tty
order by count(tty)
;

--all the prescription drug products, 43,322 total setids
select count(distinct spl_set_id) from mthspl_prod_setid where prod_rxaui in (
    select prod_rxaui
    from mthspl_prod_labeltype
    where label_type = 'HUMAN PRESCRIPTION DRUG LABEL' or label_type = 'HUMAN PRESCRIPTION DRUG LABEL WITH HIGHLIGHTS'
)
;

--43,364 setids that are prescription products
select count(distinct spl_set_id) from mthspl_prod_setid where prod_rxaui in (
    select rxaui from mthspl_rxprod_v
)
;

--query that shows all with more than one label type
select * from mthspl_rxprod_v where array_length(label_types, 1) > 1;
--0 rows
select rxaui, count(*) from mthspl_rxprod_v
group by rxaui having count(*) > 1
;

--appl codes has multiple NDCs under it
--appl numbers are not drugs, proof (see below), different doses and different CUIs
--ANDA061395,49,"[[{""fullNDC"": ""0781-9261-85"", ""shortNDC"": ""0781-9261""}, {""fullNDC"": ""0781-9261-95"", ""shortNDC"": ""0781-9261""}], [{""fullNDC"": ""0781-9401-78"", ""shortNDC"": ""0781-9401""}, {""fullNDC"": ""0781-9401-95"", ""shortNDC"": ""0781-9401""}], [{""fullNDC"": ""0781-9401-78"", ""shortNDC"": ""0781-9401""}, {""fullNDC"": ""0781-9401-95"", ""shortNDC"": ""0781-9401""}], [{""fullNDC"": ""0781-3407-78"", ""shortNDC"": ""0781-3407""}, {""fullNDC"": ""0781-3407-95"", ""shortNDC"": ""0781-3407""}], [{""fullNDC"": ""0781-9407-78"", ""shortNDC"": ""0781-9407""}, {""fullNDC"": ""0781-9407-95"", ""shortNDC"": ""0781-9407""}], [{""fullNDC"": ""0781-9407-78"", ""shortNDC"": ""0781-9407""}, {""fullNDC"": ""0781-9407-95"", ""shortNDC"": ""0781-9407""}], [{""fullNDC"": ""0409-3718-01"", ""shortNDC"": ""0409-3718""}, {""fullNDC"": ""0409-3718-10"", ""shortNDC"": ""0409-3718""}], [{""fullNDC"": ""0781-3404-85"", ""shortNDC"": ""0781-3404""}, {""fullNDC"": ""0781-3404-95"", ""shortNDC"": ""0781-3404""}], [{""fullNDC"": ""0409-3726-01"", ""shortNDC"": ""0409-3726""}, {""fullNDC"": ""0409-3726-10"", ""shortNDC"": ""0409-3726""}], [{""fullNDC"": ""0781-9408-80"", ""shortNDC"": ""0781-9408""}, {""fullNDC"": ""0781-9408-95"", ""shortNDC"": ""0781-9408""}], [{""fullNDC"": ""0409-3720-01"", ""shortNDC"": ""0409-3720""}, {""fullNDC"": ""0409-3720-10"", ""shortNDC"": ""0409-3720""}], [{""fullNDC"": ""0781-3409-46"", ""shortNDC"": ""0781-3409""}, {""fullNDC"": ""0781-3409-95"", ""shortNDC"": ""0781-3409""}], [{""fullNDC"": ""0781-9242-78"", ""shortNDC"": ""0781-9242""}, {""fullNDC"": ""0781-9242-95"", ""shortNDC"": ""0781-9242""}], [{""fullNDC"": ""63323-707-20"", ""shortNDC"": ""63323-707""}], [{""fullNDC"": ""63323-707-20"", ""shortNDC"": ""63323-707""}], [{""fullNDC"": ""0781-9250-78"", ""shortNDC"": ""0781-9250""}, {""fullNDC"": ""0781-9250-95"", ""shortNDC"": ""0781-9250""}], [{""fullNDC"": ""63323-708-00"", ""shortNDC"": ""63323-708""}], [{""fullNDC"": ""0781-3404-85"", ""shortNDC"": ""0781-3404""}, {""fullNDC"": ""0781-3404-95"", ""shortNDC"": ""0781-3404""}], [{""fullNDC"": ""26637-321-01"", ""shortNDC"": ""26637-321""}], [{""fullNDC"": ""0781-9408-80"", ""shortNDC"": ""0781-9408""}, {""fullNDC"": ""0781-9408-95"", ""shortNDC"": ""0781-9408""}], [{""fullNDC"": ""0781-9273-80"", ""shortNDC"": ""0781-9273""}, {""fullNDC"": ""0781-9273-95"", ""shortNDC"": ""0781-9273""}], [{""fullNDC"": ""0781-3400-78"", ""shortNDC"": ""0781-3400""}, {""fullNDC"": ""0781-3400-95"", ""shortNDC"": ""0781-3400""}], [{""fullNDC"": ""0409-3725-01"", ""shortNDC"": ""0409-3725""}, {""fullNDC"": ""0409-3725-11"", ""shortNDC"": ""0409-3725""}], [{""fullNDC"": ""0781-9409-46"", ""shortNDC"": ""0781-9409""}, {""fullNDC"": ""0781-9409-95"", ""shortNDC"": ""0781-9409""}], [{""fullNDC"": ""26637-321-01"", ""shortNDC"": ""26637-321""}], [{""fullNDC"": ""0781-9404-85"", ""shortNDC"": ""0781-9404""}, {""fullNDC"": ""0781-9404-95"", ""shortNDC"": ""0781-9404""}], [{""fullNDC"": ""0409-3718-01"", ""shortNDC"": ""0409-3718""}, {""fullNDC"": ""0409-3718-10"", ""shortNDC"": ""0409-3718""}], [{""fullNDC"": ""63323-708-00"", ""shortNDC"": ""63323-708""}], [{""fullNDC"": ""0781-9250-78"", ""shortNDC"": ""0781-9250""}, {""fullNDC"": ""0781-9250-95"", ""shortNDC"": ""0781-9250""}], [{""fullNDC"": ""0409-3719-01"", ""shortNDC"": ""0409-3719""}, {""fullNDC"": ""0409-3719-10"", ""shortNDC"": ""0409-3719""}], [{""fullNDC"": ""0781-9242-78"", ""shortNDC"": ""0781-9242""}, {""fullNDC"": ""0781-9242-95"", ""shortNDC"": ""0781-9242""}], [{""fullNDC"": ""0781-9402-78"", ""shortNDC"": ""0781-9402""}, {""fullNDC"": ""0781-9402-95"", ""shortNDC"": ""0781-9402""}], [{""fullNDC"": ""0781-9402-78"", ""shortNDC"": ""0781-9402""}, {""fullNDC"": ""0781-9402-95"", ""shortNDC"": ""0781-9402""}], [{""fullNDC"": ""0781-3402-78"", ""shortNDC"": ""0781-3402""}, {""fullNDC"": ""0781-3402-95"", ""shortNDC"": ""0781-3402""}], [{""fullNDC"": ""0781-3402-78"", ""shortNDC"": ""0781-3402""}, {""fullNDC"": ""0781-3402-95"", ""shortNDC"": ""0781-3402""}], [{""fullNDC"": ""0781-9261-85"", ""shortNDC"": ""0781-9261""}, {""fullNDC"": ""0781-9261-95"", ""shortNDC"": ""0781-9261""}], [{""fullNDC"": ""0409-3726-01"", ""shortNDC"": ""0409-3726""}, {""fullNDC"": ""0409-3726-10"", ""shortNDC"": ""0409-3726""}], [{""fullNDC"": ""50090-4552-0"", ""shortNDC"": ""50090-4552""}], [{""fullNDC"": ""0781-9273-80"", ""shortNDC"": ""0781-9273""}, {""fullNDC"": ""0781-9273-95"", ""shortNDC"": ""0781-9273""}], [{""fullNDC"": ""0409-3720-01"", ""shortNDC"": ""0409-3720""}, {""fullNDC"": ""0409-3720-10"", ""shortNDC"": ""0409-3720""}], [{""fullNDC"": ""0781-3400-78"", ""shortNDC"": ""0781-3400""}, {""fullNDC"": ""0781-3400-95"", ""shortNDC"": ""0781-3400""}], [{""fullNDC"": ""63323-704-08"", ""shortNDC"": ""63323-704""}], [{""fullNDC"": ""0409-3719-01"", ""shortNDC"": ""0409-3719""}, {""fullNDC"": ""0409-3719-10"", ""shortNDC"": ""0409-3719""}], [{""fullNDC"": ""0781-3407-78"", ""shortNDC"": ""0781-3407""}, {""fullNDC"": ""0781-3407-95"", ""shortNDC"": ""0781-3407""}], [{""fullNDC"": ""0781-9404-85"", ""shortNDC"": ""0781-9404""}, {""fullNDC"": ""0781-9404-95"", ""shortNDC"": ""0781-9404""}], [{""fullNDC"": ""63323-704-08"", ""shortNDC"": ""63323-704""}], [{""fullNDC"": ""0781-3408-80"", ""shortNDC"": ""0781-3408""}, {""fullNDC"": ""0781-3408-95"", ""shortNDC"": ""0781-3408""}], [{""fullNDC"": ""0781-3408-80"", ""shortNDC"": ""0781-3408""}, {""fullNDC"": ""0781-3408-95"", ""shortNDC"": ""0781-3408""}], [{""fullNDC"": ""63323-705-08"", ""shortNDC"": ""63323-705""}]]","[[""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""6632a5bd-45f1-422f-80b0-46e5a628969a""], [""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""f9cc8138-457a-491a-9b58-f59c65281515""], [""f9cc8138-457a-491a-9b58-f59c65281515""], [""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""f9cc8138-457a-491a-9b58-f59c65281515""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""b6445bba-df89-4fd3-ab3d-393256dba07a""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""2fdfe288-f851-4c3d-a542-9f20d6af2b1d""], [""5308ddfa-4a5b-4f7b-83ce-9d1b528e050d""], [""b6445bba-df89-4fd3-ab3d-393256dba07a""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""f9cc8138-457a-491a-9b58-f59c65281515""], [""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""b55a10b4-222e-49a3-8020-86ec344b64e3""], [""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""f9cc8138-457a-491a-9b58-f59c65281515""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""f9cc8138-457a-491a-9b58-f59c65281515""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""f9cc8138-457a-491a-9b58-f59c65281515""]]","{AMPICILLIN SODIUM 1 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 125 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 125 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 10 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 125 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 10 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 10 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 125 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin]}","{ampicillin 1000 MG Injection,ampicillin 125 MG Injection,ampicillin 125 MG Injection,ampicillin 500 MG Injection,ampicillin 500 MG Injection,ampicillin 500 MG Injection,ampicillin 500 MG Injection,ampicillin 1000 MG Injection,ampicillin 1000 MG Injection,ampicillin 2000 MG Injection,ampicillin 2000 MG Injection,ampicillin 100 MG/ML Injectable Solution,ampicillin 250 MG Injection,ampicillin 250 MG Injection,ampicillin 250 MG Injection,ampicillin 500 MG Injection,ampicillin 500 MG Injection,ampicillin 1000 MG Injection,ampicillin 1000 MG Injection,ampicillin 2000 MG Injection,ampicillin 2000 MG Injection,ampicillin 125 MG Injection,ampicillin 100 MG/ML Injectable Solution,ampicillin 100 MG/ML Injectable Solution,ampicillin 1000 MG Injection,ampicillin 1000 MG Injection,ampicillin 500 MG Injection,ampicillin 500 MG Injection,ampicillin 500 MG Injection,ampicillin 250 MG Injection,ampicillin 250 MG Injection,ampicillin 250 MG Injection,ampicillin 250 MG Injection,ampicillin 250 MG Injection,ampicillin 250 MG Injection,ampicillin 1000 MG Injection,ampicillin 1000 MG Injection,ampicillin 2000 MG Injection,ampicillin 2000 MG Injection,ampicillin 2000 MG Injection,ampicillin 125 MG Injection,ampicillin 1000 MG Injection,ampicillin 250 MG Injection,ampicillin 500 MG Injection,ampicillin 1000 MG Injection,ampicillin 1000 MG Injection,ampicillin 2000 MG Injection,ampicillin 2000 MG Injection,ampicillin 2000 MG Injection}","{1721473,1721474,1721475,1721476,308207,789980}"

--VERIFIED NDC occurring in multiple setids
--0409-1559-10,10,"[[""67578b56-7540-487e-1fba-481255620e78""], [""fd895819-b7d4-43bd-b804-f7b0722a00e9""]]","[[""NDA016964""], null]","[""BUPIVACAINE HYDROCHLORIDE 2.5 mg in 1 mL EPIDURAL INJECTION, SOLUTION [Marcaine]"", ""BUPIVACAINE HYDROCHLORIDE 2.5 mg in 1 mL EPIDURAL INJECTION, SOLUTION [Marcaine]_#1"", ""BUPIVACAINE HYDROCHLORIDE 2.5 mg in 1 mL INFILTRATION INJECTION, SOLUTION [Marcaine]"", ""BUPIVACAINE HYDROCHLORIDE 2.5 mg in 1 mL INFILTRATION INJECTION, SOLUTION [Marcaine]_#1"", ""BUPIVACAINE HYDROCHLORIDE 2.5 mg in 1 mL INTRACAUDAL INJECTION, SOLUTION [Marcaine]"", ""BUPIVACAINE HYDROCHLORIDE 2.5 mg in 1 mL INTRACAUDAL INJECTION, SOLUTION [Marcaine]_#1"", ""BUPIVACAINE HYDROCHLORIDE 2.5 mg in 1 mL PERINEURAL INJECTION, SOLUTION [Marcaine]"", ""BUPIVACAINE HYDROCHLORIDE 2.5 mg in 1 mL PERINEURAL INJECTION, SOLUTION [Marcaine]_#1"", ""Bupivacaine Hydrochloride 2.5 mg in 1 mL EPIDURAL INJECTION, SOLUTION [Marcaine]"", ""Bupivacaine Hydrochloride 2.5 mg in 1 mL INFILTRATION INJECTION, SOLUTION [Marcaine]""]","[""10 ML bupivacaine hydrochloride 2.5 MG/ML Injection [Marcaine]"", ""bupivacaine hydrochloride 2.5 MG/ML Injection [Marcaine]""]","[""1725079"", ""1725081""]","[[""HUMAN PRESCRIPTION DRUG LABEL""]]"

--HOW TO USE RXNDOC
select * from rxndoc where dockey = 'TTY' and value = 'TMSY';

-- with -- CTE (common table expression)
--   drug_prod_rxauis as (
--     select rxaui from mthspl_rxprod_v where rxcui in (select rxcui from drug)
--   )

--TRADENAME_OF: relates SBD -> SCD

--have already been run
create index ix_mthsplsetid_setid on mthspl_prod_setid(spl_set_id);
create index ix_drug_rxcui on drug (rxcui);

--make child table of drug: drug_tradename_drug
--SCD -> SBD tradename_of
--SBD -> SCD has_tradename
--three columns, drug id 1, drug id 2

--22,437 has_tradename, 22,437 tradename_of
select rel.rxcui1, rel.rela, rel.rxcui2, d.name drug1, d.tty tty1, dr.name drug2, dr.tty tty2
from rxnrel rel
join drug d on d.rxcui = rel.rxcui1
join drug dr on dr.rxcui = rel.rxcui2
where rel.rela = 'has_tradename'
;
--16,098 not fitting pattern of either  NOTE quantified form
select rel.rxcui1, rel.rela, rel.rxcui2, d.name drug1, d.tty tty1, dr.name drug2, dr.tty tty2
from rxnrel rel
join drug d on d.rxcui = rel.rxcui1
join drug dr on dr.rxcui = rel.rxcui2
where not (rel.rela = 'has_tradename' or rel.rela = 'tradename_of')
;
--none have a one to many from SBD -> SCD, but many SBD -> SCD one generic
select rel.rxcui1, rel.rela, jsonb_agg(rel.rxcui2), d.name drug1, d.tty tty1, jsonb_agg(dr.name) drug2 , jsonb_agg(dr.tty) tty2
from rxnrel rel
join drug d on d.rxcui = rel.rxcui1
join drug dr on dr.rxcui = rel.rxcui2
where rel.rela = 'has_tradename'
group by rel.rxcui1, rel.rela, d.name, d.tty
--having jsonb_array_length(jsonb_agg(rel.rxcui2)) > 1
;

--3,010 SCD have more than one SBD linked to it, 14,333 have one or more linked to it
select jsonb_agg(rel.rxcui1), rel.rela, rel.rxcui2, jsonb_agg(d.name) drug1, jsonb_agg(d.tty) tty1, dr.name drug2 , dr.tty tty2
from rxnrel rel
join drug d on d.rxcui = rel.rxcui1
join drug dr on dr.rxcui = rel.rxcui2
where rel.rela = 'has_tradename'
group by rel.rxcui2, rel.rela, dr.name, dr.tty
--having jsonb_array_length(jsonb_agg(rel.rxcui1)) > 1
;

--looks like unquanitified drug doesn't have a prod
select * from mthspl_prod where rxcui = '1000153';

--RXNORM BRANDED AND TRADENAME SECTION
--4,299 unquantified, 187 in rx mthspl
select * from drug d where d.quantified = 'N' and d.rxcui in (select rxcui from mthspl_rxprod_v);
--5,478 quantified, 2,550 in rx mthspl
select * from drug d where d.quantified = 'Y' and d.rxcui in (select rxcui from mthspl_rxprod_v);

--23,253 SCD not a tradename
select distinct *
from drug d
where d.rxcui not in (select rxcui2 from drug_tradename_drug)
and d.tty = 'SCD';

--of 23,253, 1,102 are quantified, 772 are not
select distinct *
from drug d
where d.rxcui not in (select rxcui2 from drug_tradename_drug)
and d.tty = 'SCD'
and d.quantified = 'Y';

--37,179 SCD in Drug
select distinct *
from drug d
where d.tty = 'SCD'
;

--13,926 SCD that are tradename of an SBD from drug_tradename_drug
select distinct array_agg(distinct rxcui1), rxcui2 from drug_tradename_drug
where tty2 = 'SCD'
group by rxcui2;

--21,785 SBD, matches with drug tradename drug
select *
from drug d
where d.tty = 'SBD'
;

--732 BPCK in drug tradename drug
select distinct * from drug_tradename_drug where not tty1 = 'SBD';

--3,553 non branded in rx mthspl
select array_agg(rxcui1), rxcui2 from drug_tradename_drug where rxcui2 in (select rxcui from mthspl_rxprod_v) group by rxcui2;
--5,870 branded in rx mthspl
select array_agg(rxcui2), rxcui1 from drug_tradename_drug where rxcui1 in (select rxcui from mthspl_rxprod_v) group by rxcui1;


--brett victor (innovating on principle) chris granger (eve) and zero knowledege proof (ZKP)

select distinct c.*, s.atn, s.atv --atv tells ATC drug class level
from rxnconso c
join rxnsat s on s.rxaui = c.rxaui
where s.sab = 'ATC'
and s.atn = 'IS_DRUG_CLASS'
-- or s.atn = 'ATC_LEVEL'
;

--1,175 distinct drug classes, 78 have more than one rxaui or rxcui
select distinct c.str, array_agg(distinct c.rxaui), array_agg(distinct c.rxcui), s.atn
from rxnconso c
join rxnsat s on s.rxaui = c.rxaui
where s.sab = 'ATC'
and s.atn = 'IS_DRUG_CLASS'
group by c.str, s.atn
having array_length(array_agg(distinct c.rxaui), 1) > 1 or array_length(array_agg(distinct c.rxcui), 1) > 1
;


select count(s.atn ), s.atn from rxnsat s where s.sab = 'VANDF' group by atn;

select distinct c.*, s.atn, s.atv
from rxnconso c
join rxnsat s on s.rxaui = c.rxaui
where s.sab = 'VANDF'
--and atn = 'DRUG_CLASS_TYPE' --578 atv number means "major" "minor" or "sub class" 0, 1 ,2 respectively
--and atn = 'PARENT_CLASS' --543
--and atn = 'VA_CLASS_NAME' --31,226
;

select distinct
  r.rxcui1,
  r.rxcui2,
  r.sab rel_sab,
  c.sab conso_sab1,
  c.str conso_str1,
  s.atn sat_atn1,
  r.rela,
  cc.sab conso_sab2,
  cc.str conso_str2,
  ss.atn sat_atn2,
  ss.atv sat_atv2,
  ss.sab sat_sab2
from rxnrel r
join rxnconso c on c.rxcui = r.rxcui1
join rxnconso cc on cc.rxcui = r.rxcui2
join rxnsat s on s.rxcui = c.rxcui
join rxnsat ss on ss.rxcui = cc.rxcui
where s.sab = 'ATC'
and c.sab = 'ATC'
and ss.sab = 'MTHSPL'
and cc.sab = 'MTHSPL'
and ss.atn = 'SPL_SET_ID'
and s.atn = 'IS_DRUG_CLASS'
;

select count(str), str, array_agg(distinct c.sab)
from rxnrel r
join rxnconso c on r.rxcui1 = c.rxcui
join rxnsat s on s.rxcui = c.rxcui
and s.atn = 'IS_DRUG_CLASS'
and s.sab = 'ATC'
-- and c.sab = 'ATC'
group by str
;

select distinct str from rxnconso where sab = 'SNOMEDCT_US';

select distinct r.rxcui1, r.rxcui2, r.rela, r.sab,
  c1.tty, c1.str, c1.sab,
  c2.tty, c2.str, c2.sab
from rxnrel r
join rxnconso c1 on r.rxcui1 = c1.rxcui
join rxnconso c2 on r.rxcui2 = c2.rxcui
where r.sab = 'RXNORM'
;

select * from rxndoc d
where d.dockey = 'ATN'
;

----------------RXNORM SECTION-----------------
--relationships in sab = RXNORM
select count(r.rela), r.rela, r.rel
from rxnrel r
where r.sab = 'RXNORM'
group by r.rela, r.rel
;

--attributes in sab = RXNORM
select count(s.atn), s.atn
from rxnsat s
where s.sab = 'RXNORM'
group by s.atn
;

--ttys in sab = RXNORM
select count(tty), tty
from rxnconso c
where sab = 'RXNORM'
group by tty
;
-----EXPLORING MIN----
--check goodnotes for notes
select distinct count(*), cc.rxcui, array_agg(r.rela), array_agg(distinct c.rxcui)
from rxnrel r
left join rxnconso c on c.rxcui = r.rxcui1
join rxnconso cc on cc.rxcui = r.rxcui2
where c.sab = 'RXNORM' and c.tty = 'MIN'
and cc.sab = 'RXNORM'
and r.rela = 'has_ingredients'
and cc.tty = 'SCD'
group by cc.rxcui
;

-- consists_of: deals with SCDCs (drug component) (TODO)
-- contained_in: deals with packs (? consider)
-- has_dose_form: tells ROA (TODO)
-- has_ingredients: deals with MINs (TODO)
-- has_quantified_form: deals with other SCDs (DONE)
-- has_tradename: deals with SBDs (DONE)
-- isa: deals with SCDF (drug + form), SCDG (drug group) + tmsy, (TODO)
-- quantified_form_of: deals with other SCDs (DONE)
select *
from rxnrel r
left join rxnconso c on c.rxcui = r.rxcui1
join rxnconso cc on cc.rxcui = r.rxcui2
where c.sab = 'RXNORM'
and cc.sab = 'RXNORM'
and cc.tty = 'SCD'
and r.sab = 'RXNORM'
and r.rela = 'isa'
;

-- has_ingredient: deals with PSN, SBD, SBDC, SBDF, SBDG, + sy and tmsy:
-- has_tradename: deals with IN + sy and tmsy, ? don't know exactly
-- precise_ingredient_of: deals with PIN + sy and tmsy
-- reformulated_to: maybe not irrelevant
-- reformulation_of: maybe not irrelevant
select c2.tty, c2.str, c2.rxcui, r.rel, r.rela, c.rxcui, c.tty, c.str
from rxnrel r
join rxnconso c on c.rxcui = r.rxcui1
join rxnconso c2 on c2.rxcui = r.rxcui2
where c.sab = 'RXNORM' and c.tty = 'BN'
and c2.sab = 'RXNORM'
and r.rela = 'has_ingredient'
;

--brand name most general concept, table needed
select distinct c2.tty, r.rel, r.rela, c1.tty
from rxnrel r
join rxnconso c1 on c1.rxcui = r.rxcui1
join rxnconso c2 on c2.rxcui = r.rxcui2
where c1.sab = 'RXNORM'
and c1.tty = 'BN'
and c2.sab = 'RXNORM'
;
-- BN,RO,reformulated_to,BN
-- IN,RB,has_tradename,BN
-- PIN,RB,precise_ingredient_of,BN
--
-- SBD,RO,has_ingredient,BN
-- SBDC,RO,has_ingredient,BN
-- SBDF,RO,has_ingredient,BN
-- SBDG,RO,has_ingredient,BN
-- SY,RB,has_tradename,BN
-- SY,RB,precise_ingredient_of,BN
-- SY,RO,has_ingredient,BN
-- TMSY,RB,has_tradename,BN
-- TMSY,RB,precise_ingredient_of,BN
-- TMSY,RO,has_ingredient,BN


--The only relationships that use rxaui are RO:included_in/includes and SY:null,
select distinct rel, rela from rxnrel r
where r.sab = 'RXNORM'
and r.rxaui1 is not null
;

--ttys compared by cuis, filtering by selecting narrower (RN) relationships from pair from rel
select distinct c2.tty, r.rel, r.rela, c1.tty
from rxnrel r
join rxnconso c1 on c1.rxcui = r.rxcui1
join rxnconso c2 on c2.rxcui = r.rxcui2
where r.sab = 'RXNORM'
and c1.sab = 'RXNORM' and c2.sab = 'RXNORM'
and (r.rel, r.rela) not in (
  ('RB', 'inverse_isa'),
  ('RO', 'has_ingredient'),
  ('RO', 'consists_of'),
  ('RB', 'has_tradename'),
  ('RO', 'dose_form_of'),
  ('RO', 'has_doseformgroup'),
  ('RO', 'has_ingredients'),
  ('RO', 'has_part'),
  ('RB', 'precise_ingredient_of'),
  ('RO', 'included_in'),
  ('RB', 'has_quantified_form'),
  ('RO', 'has_precise_ingredient'),
  ('RB', 'has_form'),
  ('RB', 'contained_in'),
  ('RO', 'reformulated_to')
)
and c1.tty <> 'PSN' and c2.tty <> 'PSN'
and c1.tty <> 'TMSY' and c2.tty <> 'TMSY'
and c1.tty <> 'SY' and c2.tty <> 'SY'
order by c1.tty, r.rel, r.rela, c2.tty
;

--311167 attributes to rxnorm SCDs
select count(*)
from rxnsat s
join rxnconso c on c.rxcui = s.rxcui
where s.sab = 'RXNORM'
and c.tty = 'SCD'
;

-- RXN_ACTIVATED
-- RXN_BN_CARDINALITY --only one per brand name
-- RXN_OBSOLETED
select c.tty, c.rxaui, c.str, c.rxcui, s.atn, s.atv, s.rxaui
from rxnconso c
join rxnsat s on s.rxcui = c.rxcui
where c.sab = 'RXNORM' and c.tty = 'BN'
and s.sab = 'RXNORM'
and s.atn = 'RXN_BN_CARDINALITY'
;

--37,719 distinct rxcuis that are SCD
select distinct rxcui from rxnconso where tty = 'SCD' and sab = 'RXNORM'
;

-------SCDC---------
select distinct c2.tty, r.rel, r.rela, c1.tty
from rxnrel r
join rxnconso c1 on c1.rxcui = r.rxcui1
join rxnconso c2 on c2.rxcui = r.rxcui2
where c1.sab = 'RXNORM'
and c1.tty = 'SCDC'
and c2.sab = 'RXNORM'
;

select jsonb_agg(c2.str || ' |--| ' || c2.rxcui) "SCDs", c1.rxcui scdc_rxcui, c1.str SCDC_name
from rxnrel r
join rxnconso c1 on c1.rxcui = r.rxcui1
join rxnconso c2 on c2.rxcui = r.rxcui2
where c1.sab = 'RXNORM'
and c1.tty = 'SCDC'
and c2.sab = 'RXNORM'
and r.rela = 'consists_of'
and c2.tty = 'SCD'
and c2.rxcui = '1000354'
group by c1.rxcui, c1.str
-- having count(*) > 1
;

-- 1000354 SCD
-- 343477 SCDC
select *
from clin_drug_comp
where name = 'estrogens, conjugated (USP) 0.625 MG'
;


--Every SCDC in rxnsat has both attributes BOSS_AI and BOSS_AM: 0 rows
--make field
select c.tty, c.str, s.atn, s.atv
-- select c.rxcui
from rxnconso c
join rxnsat s on s.rxcui = c.rxcui
where c.sab = 'RXNORM' and c.tty = 'SCDC'
and s.sab = 'RXNORM'
-- and s.atn = 'RXN_IN_EXPRESSED_FLAG'
and s.atn like 'RXN_BOSS%'
-- and (s.atn = 'RXN_BOSS_AI' or s.atn = 'RXN_BOSS_AM')
-- group by c.rxcui
-- having count(*) > 1
;


select count(atn), atn
from rxnconso c
join rxnsat s on s.rxcui = c.rxcui
where c.sab = 'RXNORM' and c.tty = 'SCDC'
and s.sab = 'RXNORM'
group by atn
;

--SBDC does not have the attributes SCDCs have, need seperate table
select count(atn), atn
from rxnconso c
join rxnsat s on s.rxcui = c.rxcui
where c.sab = 'RXNORM' and c.tty = 'SBDC'
and s.sab = 'RXNORM'
group by atn
;


-- select distinct s.atv
select c.tty, c.sab, c.str, s.atn, s.atv
from rxnsat s
join rxnconso c on c.rxaui = s.rxaui
where s.atn = 'RXTERM_FORM'
;

select * from rxnsat s
join rxnconso c on c.rxaui = s.rxaui
where s.atn = 'RXN_STRENGTH'
;

select * from rxnsat s
join rxnconso c on c.rxaui = s.rxaui
where s.atn = 'RXN_QUANTITY'
;

select * from rxnsat s
join rxnconso c on c.rxaui = s.rxaui
where s.atn = 'RXN_QUALITATIVE_DISTINCTION'
;

--ttys of: SCDC, SBDC, and TMSY--ignore TMSY
--SBDCs are different than SCDC when linking to an SBD in drug with multiple ingredients
select r.rxcui2, r.sab, c.tty, c.sab, c.str, r.rel, r.rela, d.rxcui, d.rxaui, d.tty, d.name
from drug d
join rxnrel r on r.rxcui1 = d.rxcui
join rxnconso c on r.rxcui2 = c.rxcui
where r.rela = 'constitutes'
and c.sab = 'RXNORM'
and c.tty not like 'TMSY'
and d.tty = 'SBD'
;
--example:1000083

--ttys of: SCDC, SCDF, SCDG, and TMSY--ignore TMSY
select r.rxcui2, r.sab, c.tty, c.sab, c.str, r.rela, i.name, i.tty, i.rxcui
from old_ingredient i
join rxnrel r on r.rxcui1 = i.rxcui
join rxnconso c on r.rxcui2 = c.rxcui
where r.rela = 'has_ingredient'
and c.sab = 'RXNORM'
;

--BN and SCDC and TMSY example:393327
select r.rxcui2, r.sab, c.tty, c.sab, c.str, r.rela, i.name, i.tty, i.rxcui
from old_ingredient i
join rxnrel r on r.rxcui1 = i.rxcui
join rxnconso c on r.rxcui2 = c.rxcui
where r.rela = 'has_precise_ingredient'
and c.sab = 'RXNORM'
;

--split the ingredients into different tables?
--extra step may be needed to get unii codes for MIN from mthspl
--or use part_of relationship and relate single ingredients to MIN and get uniis
select i.*, s.unii
from old_ingredient i
join mthspl_sub s on s.rxcui = i.rxcui
and i.tty = 'IN'
;

select * from old_ingredient where tty = 'MIN'
;

select count(atn), atn
-- select c.rxcui, c.str
-- select c.rxcui, c.str, s.atn, s.atv
from rxnconso c
join rxnsat s on s.rxcui = c.rxcui
where c.tty = 'BPCK'
and c.sab = 'RXNORM' and s.sab = 'RXNORM'
-- and s.atn = 'RXN_QUALITATIVE_DISTINCTION'
group by atn
-- group by c.rxcui, c.str
-- having array_length(array_agg(s.atn), 1) > 1
;
--257 SCD have both human and vet drug

-- select count(atn), atn
-- select c.rxcui, c.str
select c.rxcui, c.str, s.atn, s.atv
from rxnconso c
join rxnsat s on s.rxcui = c.rxcui
where c.tty = 'SBD'
and c.sab = 'RXNORM' and s.sab = 'RXNORM'
and s.atn = 'RXN_QUANTITY'
-- group by atn
-- group by c.rxcui, c.str
-- having count(*) > 1
-- having array_length(array_agg(s.atn), 1) > 1
;
--8 SBD have both human and vet

select c2.sab, c2.tty, c2.str, r.rel, r.rela, c1.str
-- select count(r.rela), r.rela
from rxnrel r
join rxnconso c1 on c1.rxcui = r.rxcui1
join rxnconso c2 on c2.rxcui = r.rxcui2
where c1.sab = 'RXNORM' and c1.tty = 'MIN'
and c2.sab = 'RXNORM'
and r.rela = 'has_ingredients'
-- and r.sab = 'RXNORM'
-- group by r.rela
;

select c2.sab, c2.rxcui, c2.tty, c2.str, r.rel, r.rela, c1.str, c1.rxcui
-- select count(r.rela), r.rela
from rxnrel r
join rxnconso c1 on c1.rxcui = r.rxcui1
join rxnconso c2 on c2.rxcui = r.rxcui2
where c1.sab = 'RXNORM' and c1.tty = 'PIN'
and c2.sab = 'RXNORM'
;

--TODO DEMO for Hong multi ingredients + UNII
--DEMO of use of multi ingredients
select c2.sab, c2.tty, c2.str, r.rel, r.rela, c1.str, array_agg(miu.unii) uniis
-- select count(r.rela), r.rela
from rxnrel r
join rxnconso c1 on c1.rxcui = r.rxcui1
join rxnconso c2 on c2.rxcui = r.rxcui2
join multi_ingredient_unii miu on c1.rxcui = miu.rxcui
where c1.sab = 'RXNORM' and c1.tty = 'MIN'
and c2.sab = 'RXNORM'
and r.rela = 'has_ingredients'
and c2.tty in ('SCD', 'SBD', 'GPCK', 'BPCK')
group by c2.sab, c2.tty, c2.str, r.rel, r.rela, c1.str
order by c1.str desc
-- and r.sab = 'RXNORM'
-- group by r.rela
;

--DEMO of multi ingredient + unii
select mi.*, miu.unii,
   (select array_agg(distinct i.name)
   from ingredient i
   join ingredient_unii iu on iu.rxcui = i.rxcui
   where iu.unii = miu.unii)
from multi_ingredient mi
join multi_ingredient_unii miu on mi.rxcui = miu.rxcui
;

--SHOWS RELATIONS OF INGREDIENTS
select c2.sab, c2.tty, c2.str, r.rel, r.rela, c1.str--, array_agg(miu.unii) uniis
-- select count(r.rela), r.rela
from rxnrel r
join rxnconso c1 on c1.rxcui = r.rxcui1
join rxnconso c2 on c2.rxcui = r.rxcui2
join ingredient_unii miu on c1.rxcui = miu.rxcui
where c1.sab = 'RXNORM' and c1.tty = 'IN'
and c2.sab = 'RXNORM'
-- and r.rela = 'has_ingredient'
-- and c2.tty in ('SCD', 'SBD', 'GPCK', 'BPCK')
-- group by c2.sab, c2.tty, c2.str, r.rel, r.rela, c1.str
-- -- order by c1.str desc
-- group by r.rela
;

-- form_of
-- has_ingredient
-- has_part
-- tradename_of



--TODO DEMO
--multiple PINs have the same UNII, holds true for IN also
select distinct iu.unii, array_agg(i.name) ingredient_names, array_agg(i.rxcui)rxcuis
from precise_ingredient i
join precise_ingredient_unii iu on iu.rxcui = i.rxcui
group by iu.unii
having count(*) > 1
;

select distinct iu.unii, array_agg(i.name) ingredient_names, array_agg(i.rxcui) rxcuis
from ingredient i
join ingredient_unii iu on iu.rxcui = i.rxcui
group by iu.unii
having count(*) > 1
;

select pi.name, array_agg(piu.unii) uniis
from ingredient_unii piu
join ingredient pi on piu.rxcui = pi.rxcui
group by pi.name
having count(*) > 1
;

--precise ingredients can have multiple UNIIs
select pi.name, array_agg(piu.unii) uniis
from precise_ingredient_unii piu
join precise_ingredient pi on piu.rxcui = pi.rxcui
group by pi.name
having count(*) > 1
;

----code for checking syn in SBDs and SCDs
select c2.tty, c2.name, r.rel, r.rela, c1.tty, c1.str
from rxnrel r
join rxnconso c1 on c1.rxaui = r.rxaui1
join sbd c2 on c2.rxaui = r.rxaui2
where rxcui1 is null
and r.sab = 'RXNORM' and c1.sab = 'RXNORM'
and c1.tty = 'SY'
;

--trust child table for precise ingredient, not atr field precise_ingr in scdc
select sd.name, pi.*
from scdc_prec_ingr spi
join scdc sd on sd.rxcui = spi.scdc_rxcui
join prec_ingr pi on spi.ingr_rxcui = pi.rxcui
where sd.rxn_in_expressed_flag is null
;

select distinct count(r.rela), r.rela
-- select c2.rxcui, c2.tty, c2.str, r.rel, r.rela, c1.tty, c1.str
-- select distinct r.rela, c1.rxcui
-- select distinct c2.rxcui, r.rela, c1.rxcui
from rxnrel r
join rxnconso c1 on c1.rxcui = r.rxcui1
join rxnconso c2 on c2.rxcui = r.rxcui2
where c1.sab = 'RXNORM' and c2.sab = 'RXNORM'
and c1.tty = 'SBD' and c2.tty = 'SBD'
group by r.rela
-- group by c2.rxcui, r.rela, c1.rxcui
-- group by r.rela, c1.rxcui
-- having count(*) > 1
;


-- if to one, make it an attribute not child table
--TODO
-- SCDF: ingr (DONE), DF: dose_form_of (DONE), SCD: isa (DONE), SCDG: inverse_isa (DONE), SBDF: tradename_of (DONE)
-- revist SCDC: ingr (DONE), PIN: (DONE), SBD: consists_of (DONE), SCD: consists_of (DONE), SBDC: tradename_of (DONE)
-- SCDG: SCDF (DONE), IN: ingredient_of (DONE), DFG: doseformgroup_of (DONE), SCD: isa (DONE), SBDG: tradename_of (DONE)
-- SCD: BPCK: contains (DONE), GPCK: contains (DONE), DF: dose_form_of (DONE), MIN: ingredients_of (DONE), quantified form (?)
-- SBD: DF: dose_form_of (DONE), do SBDC (DONE),SBDF, and SBDG different direction, BN: ingredient_of (DONE)
-- SY table for SBD (DONE)
-- SBDC: BN: ingredient_of (DONE), SBD: consists_of (DONE),
-- SBDF: SBDG: inverse_isa (DONE), BN: ingredient_of (DONE), DF: dose_form_of (DONE), SBD: isa (DONE)
-- SBDG: BN: ingredient_of (DONE), DFG: doseformgroup_of (DONE), SBD: isa (DONE),
-- GPCK: BPCK: tradename_of (DONE), DF: dose_form_of (not needed), SCD: contained_in (DONE)
-- BPCK: SBD/SCD: contained_in (DONE)
-- table for single ingredient like MIN -> SCD relationship. --attached as field instead
-- MIN with both PIN and IN?
-- Make sure SCD without MIN only have one IN or PIN.
--  If so, create artificial MIN associated with the just one ingredient

-- TODO finish ingrset: done

select * from temp_ingrset


