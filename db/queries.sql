select * from rxndoc where value in ('CVF');

select distinct(atn) from rxnsat where sab='MTHSPL';
select distinct(rela) from rxnrel where sab='MTHSPL';

select * from rxnconso where sab='MTHSPL' and lui is not null or sui is not null;

-- Substance and drug product attributes in MTHSPL.

select count(distinct rxaui)
from rxnsat a where a.sab='MTHSPL' and a.rxaui in (select rxaui from mthspl_prod p);
-- 185229 drug products having attributes in rxnsat
-- Attributes associated with MTHSPL/SU concepts: only SPL_SET_ID.
select a.atn, count(*) count, count(distinct a.rxaui) aui_count, count(distinct a.atv) val_count
from rxnsat a
where
    a.sab = 'MTHSPL' and
    a.rxaui in (select rxaui from mthspl_sub)
group by a.atn
order by a.atn
; -- SPL_SET_ID
-- Attributes associated with RXNCONSO/MTHSPL/DP atoms (37).
select a.atn, count(*) count, count(distinct a.rxaui) aui_count, count(distinct a.atv) val_count
from rxnsat a
where
    a.sab = 'MTHSPL' and
    a.rxaui in (select p.rxaui from mthspl_prod p)
group by a.atn
order by a.atn
;

select p.rxaui, count(*) aui_count, array_agg(atv) vals
from mthspl_prod p
       join rxnsat a on a.sab='MTHSPL' and a.rxaui = p.rxaui
where a.atn IN ('NDA', 'ANDA', 'BLA')
group by p.rxaui
having count(*) > 1
;
-- 10269088,2,"{NDA021425,NDA020220}"
-- 10269090,2,"{NDA021425,NDA020220}"
-- 10269092,2,"{NDA021425,NDA020220}"
-- 10337840,2,"{ANDA091170,ANDA202571}"
-- ..
select * from rxnsat a where a.rxaui = '10337840' and a.atn IN ('NDA', 'ANDA', 'BLA');
-- 351114,,,10337840,AUI,68001-366,,,ANDA,MTHSPL,ANDA091170,N
-- 351114,,,10337840,AUI,68001-366,,,ANDA,MTHSPL,ANDA202571,N

select distinct prod_rxaui, array_agg(mkt_cat)
from mthspl_prod_mktcat
group by prod_rxaui
having count(*) > 1
;
-- 10788044,"{OTC monograph final,Unapproved drug other}"
-- 11433328,"{NDA,NDA authorized generic}"
-- 11444924,"{NDA,NDA authorized generic}"
-- 11795949,"{ANDA,Unapproved drug other}"
-- 11795950,"{ANDA,Unapproved drug other}"
-- 11795951,"{ANDA,Unapproved drug other}"
-- 11818776,"{Export only,OTC monograph final}"
-- 11821542,"{ANDA,Export only}"
-- 11821543,"{ANDA,Export only}"
-- 12513198,"{NDA,Unapproved drug other}"
-- 12513199,"{NDA,Unapproved drug other}"
-- 12540111,"{OTC monograph final,OTC monograph not final}"
-- 3041434,"{ANDA,NDA}"
-- 3279437,"{NADA,Unapproved medical gas}"
-- 3501995,"{NDA,Unapproved medical gas}"
-- 3507620,"{OTC monograph final,OTC monograph not final}"
-- 4652426,"{ANDA,Unapproved drug other}"
-- 4652427,"{ANDA,Unapproved drug other}"
-- 4655278,"{ANDA,Unapproved drug other}"
-- 8250891,"{ANDA,Unapproved drug other}"
-- 8250892,"{ANDA,Unapproved drug other}"
-- 8250893,"{ANDA,Unapproved drug other}"
-- 8250894,"{ANDA,Unapproved drug other}"
-- 8257322,"{Export only,Unapproved drug other}"
-- 9710205,"{ANDA,Export only}"


-- Active ingredients of drug products in MTHSPL.
-- Note that the order or the atom id's is backwards vs how the relation reads.
select * from rxnrel where rela = 'active_ingredient_of' and sab='MTHSPL';
-- The order of the atom id's is reversed vs how the relation predicates reads:
select distinct tty from rxnconso where rxaui in (
  select rxaui1 from rxnrel where rela = 'active_ingredient_of' and sab='MTHSPL'
);
-- MTH_RXN_DP
-- DP
select distinct tty from rxnconso where rxaui in (
  select rxaui2 from rxnrel where rela = 'active_ingredient_of' and sab='MTHSPL'
);
-- SU
select distinct tty from rxnconso where rxaui in (
  select rxaui1 from rxnrel where rela = 'has_active_ingredient' and sab='MTHSPL'
);
-- SU
select distinct tty from rxnconso where rxaui in (
  select rxaui2 from rxnrel where rela = 'has_active_ingredient' and sab='MTHSPL'
);
-- MTH_RXN_DP
-- DP

-- TODO: Modify this to fetch attributes for drug products in MTHSPL.
select
  cast(a.rxaui as int),
  cast(a.rxcui as int),
  a.atv setid,
  a.suppress
from rxnsat a
where
    a.sab = 'MTHSPL'
  and a.rxaui in (select rxaui from rxnconso where sab='MTHSPL' and tty='SU')




-- Examine tty counts within MTHSPL.
select tty, count(*) mthspl_atom_count
from rxnconso
where sab='MTHSPL'
  and code <> 'NOCODE'
group by tty
;
-- DP	183412     (NDC)
-- MTH_RXN_DP 1816 (NDC, subset of DP)
-- SU	21460      (UNII)
-- What do these tty's mean?
select value, expl
from rxndoc
where type = 'expanded_form' and dockey='TTY' and
 value in ('DP', 'MTH_RXN_DP', 'SU');
/*
DP	Drug Product
MTH_RXN_DP	RxNorm Created DP
SU	Active Substance
*/

-- SU
-- Some mthspl_substance rxcui values do not refer to SAB=RXNORM ingredient records?
select rxcui, rxaui, sab, tty, code, str, suppress
from rxnconso
where sab='MTHSPL' and tty='SU' and
  rxcui not in (
  select rxcui from rxnconso where sab='RXNORM' and tty IN ('IN','PIN', 'MIN')
);
-- 663	11443826	MTHSPL	SU	N7U7BXP2OI	AMINO ACIDS, ESSENTIAL	N
-- 1843	9833961	MTHSPL	SU	3B7C0987O9	BUTTER	N
-- 4396	7266398	MTHSPL	SU	M09888Y92S	SILK FIBROIN	N
-- ...
-- So, will need a substance table that is specific to sab=MTHSPL.

-- What

select * from rxnconso where sab='RXNORM' and
  rxcui = '1000082'
;



-- Examine tty counts within MTHSPL.
select tty, count(*) mthspl_atom_count
from rxnconso
where sab='MTHSPL'
and code <> 'NOCODE'
group by tty
;
-- DP	183412     (NDC)
-- MTH_RXN_DP 1816 (NDC, subset of DP)
-- SU	21460      (UNII)

-- The tty=MTH_RXN_DP NDCs are a subset of those of tty=DP within sab=MTHSPL.
select *
from rxnconso
where sab='MTHSPL' and tty = 'MTH_RXN_DP' and code <> 'NOCODE' and
  code not in (
    select code from rxnconso where sab='MTHSPL' and tty = 'DP' and code <> 'NOCODE'
  )
; -- no rows



-- Case Study - Find footprint of an MTHSPL atom and its concept in RXNORM tables.

-- MTHSPL/DP atom: rxaui = 10771876, rxcui = 91349
select rxcui, rxaui, code, str, suppress from rxnconso where sab='MTHSPL' and tty='DP' and rxaui='10771876';
-- 91349	10771876	76176-111	HYDROGEN PEROXIDE 3 mL in 100 mL TOPICAL LIQUID [PHARMACYS PRESCRIPTION HYDROGEN PEROXIDE]	N

-- What is the drug concept for this atom?
select tty, str from drug_concept_v where rxcui = '91349';
-- SCD	hydrogen peroxide 30 MG/ML Topical Solution

-- Q: What records exist for this atom's concept within RXNCONSO/MTHSPL?
select rxcui, tty, rxaui, code, str, suppress from rxnconso where sab='MTHSPL' and rxcui='91349';
-- A: 131 records are assigned the same CUI within MTHSPL, all DP as well.

-- Q: Are there also RXNCONSO records for this concept outside of MTHSPL?
select rxcui, tty, sab, rxaui, code, str, suppress
from rxnconso
where rxcui='91349' and sab<>'MTHSPL'
order by sab, tty
;
/* A: Yes, 38 records, including 3 records within sab=RXNORM with ttys of SCD,SY,PSN.
91349	BD	GS	12405560	123248	Publix Hydrogen Peroxide 3% Topical Solution	N
91349	BD	GS	12405612	123250	Sunmark Hydrogen Peroxide 3% Topical Solution	N
...
91349	BD	MMSL	707035	4350	Hydrogen Peroxide, 3% topical solution	N
91349	CD	MMSL	707036	4350	hydrogen peroxide topical 3% topical solution	N
91349	BD	MMX	9175001	106611	Hydrogen Peroxide 3% Topical application Solution [HEALTH MART HYDROGEN PEROXIDE]	N
91349	BD	MMX	10772181	105525	Hydrogen Peroxide 3% Solution [SUNMARK HYDROGEN PEROXIDE]	O
...
91349	CDA	NDDF	9783900	009801	hydrogen peroxide 3 % MISCELL SOLUTION, NON-ORAL	N
91349	CDC	NDDF	9783901	009801	hydrogen peroxide 3 % MISCELL SOLUTION, NON-ORAL	N
91349	CDD	NDDF	9783918	009801	hydrogen peroxide@3 %@MISCELL@SOLUTION, NON-ORAL	N
91349	PSN	RXNORM	6393039	91349	hydrogen peroxide 3 % Topical Solution	N
91349	SCD	RXNORM	12335792	91349	hydrogen peroxide 30 MG/ML Topical Solution	N
91349	SY	RXNORM	3504279	91349	hydrogen peroxide 3 % Topical Solution	N
91349	FN	SNOMEDCT_US	11440095	6259002	Product containing precisely hydrogen peroxide 30 milligram/1 milliliter conventional release cutaneous solution (clinical drug)	N
91349	PT	SNOMEDCT_US	11437055	6259002	Hydrogen peroxide 30 mg/mL cutaneous solution	N
91349	AB	VANDF	2842859	4009353	HYDROGEN PEROXIDE 3% TOP SOLN	N
91349	CD	VANDF	707040	4009353	HYDROGEN PEROXIDE 3% SOLN,TOP	N
*/

-- Q: Does the specific atom (AUI) have any relationships declared in RXNREL?
select rxaui1, rel, rela, rxaui2, sab
from rxnrel
where rxaui1 = '10771876' or rxaui2 = '10771876'
order by rxaui1, rel, rela, rxaui2
; /* A: Yes, 9 records:
10771876	RO	active_ingredient_of	3266101	MTHSPL
10771876	RO	active_moiety_of	3266101	MTHSPL
10771876	RO	inactive_ingredient_of	2994597	MTHSPL
10771876	RO	inactive_ingredient_of	3265408	MTHSPL
12335792	SY		10771876	RXNORM
2994597	RO	has_inactive_ingredient	10771876	MTHSPL
3265408	RO	has_inactive_ingredient	10771876	MTHSPL
3266101	RO	has_active_ingredient	10771876	MTHSPL
3266101	RO	has_active_moiety	10771876	MTHSPL
*/
-- The referenced synonym of SY row above in RXNCONSO:
select rxcui, rxaui, sab, tty, code, str from rxnconso where rxaui = '10771876';
-- 91349	10771876	MTHSPL	DP	76176-111	HYDROGEN PEROXIDE 3 mL in 100 mL TOPICAL LIQUID [PHARMACYS PRESCRIPTION HYDROGEN PEROXIDE]

-- Q: What relationships exist in RXNREL for the concept of this atom?
select rxcui1, rel, rela, rxcui2, sab
from rxnrel
where rxcui1 = '91349' or rxcui2 = '91349'
order by rxcui1, rel, rela, rxcui2
;/* A: 10 rows:
1164617	RN	isa	91349	RXNORM
210535	RB	has_tradename	91349	RXNORM
316986	RO	has_dose_form	91349	RXNORM
330565	RO	consists_of	91349	RXNORM
372426	RN	isa	91349	RXNORM
91349	RB	inverse_isa	1164617	RXNORM
91349	RB	inverse_isa	372426	RXNORM
91349	RN	tradename_of	210535	RXNORM
91349	RO	constitutes	330565	RXNORM
91349	RO	dose_form_of	316986	RXNORM
*/
-- Information about related concepts above in RXNCONSO/sab=RXNORM.
select rxcui,tty, str
from rxnconso
where sab='RXNORM' and rxcui in ('1164617','210535','316986','330565','372426')
; /*
1164617	SCDG	hydrogen peroxide Topical Product
210535	SY	Proxacol 30 MG/ML Topical Solution
210535	SBD	hydrogen peroxide 30 MG/ML Topical Solution [Proxacol]
316986	DF	Topical Solution
330565	SCDC	hydrogen peroxide 30 MG/ML
372426	SCDF	hydrogen peroxide Topical Solution
*/





SELECT distinct rc1.tty, rr.rela, rc2.tty
FROM rxnconso rc1, rxnrel rr, rxnconso rc2
WHERE
  rc1.sab = 'MTHSPL'
  AND rc1.rxcui = rr.rxcui2
  AND rr.rxcui1 = rc2.rxcui
  AND rc2.sab = 'RXNORM'
order by rc1.tty, rr.rela, rc2.tty
;



select * from splndc_drugconcept_v
where spl_ndc = '65597-115'
;
--	1000000	amlodipine 5 MG / hydrochlorothiazide 12.5 MG / olmesartan medoxomil 40 MG Oral Tablet [Tribenzor]	SBD	N



-- RXNREL : sab=MTHSPL <-> sab=RXNORM
-- What relationships exist in RXNREL between sab=MTHSPL and sab=RXNORM concepts?
SELECT distinct rc1.tty, rr.rela, rc2.tty
FROM rxnconso rc1, rxnrel rr, rxnconso rc2
WHERE
  rc1.sab = 'MTHSPL'
  AND rc1.rxcui = rr.rxcui2
  AND rr.rxcui1 = rc2.rxcui
  AND rc2.sab = 'RXNORM'
  order by rc1.tty, rr.rela, rc2.tty
;
-- DP	consists_of	SBDC
-- DP	consists_of	SCDC
-- DP	consists_of	TMSY
-- DP	contained_in	BPCK
-- DP	contained_in	GPCK
-- DP	contained_in	PSN
-- DP	contained_in	SY
-- DP	contained_in	TMSY
-- DP	contains	PSN
-- DP	contains	SBD
-- DP	contains	SCD
-- DP	contains	SY
-- DP	contains	TMSY
-- DP	has_dose_form	DF
-- DP	has_dose_form	SY
-- DP	has_ingredient	BN
-- DP	has_ingredient	TMSY
-- DP	has_ingredients	MIN
-- DP	has_ingredients	TMSY
-- DP	has_quantified_form	PSN
-- DP	has_quantified_form	SBD
-- DP	has_quantified_form	SCD
-- DP	has_quantified_form	SY
-- DP	has_quantified_form	TMSY
-- DP	has_tradename	BPCK
-- DP	has_tradename	PSN
-- DP	has_tradename	SBD
-- DP	has_tradename	SY
-- DP	has_tradename	TMSY
-- DP	isa	SBDF
-- DP	isa	SBDG
-- DP	isa	SCDF
-- DP	isa	SCDG
-- DP	isa	SY
-- DP	isa	TMSY
-- DP	quantified_form_of	PSN
-- DP	quantified_form_of	SBD
-- DP	quantified_form_of	SCD
-- DP	quantified_form_of	SY
-- DP	quantified_form_of	TMSY
-- DP	tradename_of	GPCK
-- DP	tradename_of	PSN
-- DP	tradename_of	SCD
-- DP	tradename_of	SY
-- DP	tradename_of	TMSY
-- MTH_RXN_DP	consists_of	SBDC
-- MTH_RXN_DP	consists_of	SCDC
-- MTH_RXN_DP	consists_of	TMSY
-- MTH_RXN_DP	contained_in	BPCK
-- MTH_RXN_DP	contained_in	GPCK
-- MTH_RXN_DP	contained_in	PSN
-- MTH_RXN_DP	contained_in	SY
-- MTH_RXN_DP	contained_in	TMSY
-- MTH_RXN_DP	contains	PSN
-- MTH_RXN_DP	contains	SBD
-- MTH_RXN_DP	contains	SCD
-- MTH_RXN_DP	contains	SY
-- MTH_RXN_DP	contains	TMSY
-- MTH_RXN_DP	has_dose_form	DF
-- MTH_RXN_DP	has_ingredient	BN
-- MTH_RXN_DP	has_ingredient	TMSY
-- MTH_RXN_DP	has_ingredients	MIN
-- MTH_RXN_DP	has_ingredients	TMSY
-- MTH_RXN_DP	has_tradename	BPCK
-- MTH_RXN_DP	has_tradename	PSN
-- MTH_RXN_DP	has_tradename	SBD
-- MTH_RXN_DP	has_tradename	SY
-- MTH_RXN_DP	has_tradename	TMSY
-- MTH_RXN_DP	isa	SBDF
-- MTH_RXN_DP	isa	SBDG
-- MTH_RXN_DP	isa	SCDF
-- MTH_RXN_DP	isa	SCDG
-- MTH_RXN_DP	isa	TMSY
-- MTH_RXN_DP	quantified_form_of	PSN
-- MTH_RXN_DP	quantified_form_of	SBD
-- MTH_RXN_DP	quantified_form_of	SCD
-- MTH_RXN_DP	quantified_form_of	SY
-- MTH_RXN_DP	quantified_form_of	TMSY
-- MTH_RXN_DP	tradename_of	GPCK
-- MTH_RXN_DP	tradename_of	PSN
-- MTH_RXN_DP	tradename_of	SCD
-- MTH_RXN_DP	tradename_of	SY
-- MTH_RXN_DP	tradename_of	TMSY
-- SU	form_of	IN
-- SU	form_of	SY
-- SU	form_of	TMSY
-- SU	has_form	PIN
-- SU	has_form	SY
-- SU	has_form	TMSY
-- SU	has_tradename	BN
-- SU	has_tradename	TMSY
-- SU	ingredient_of	SCDC
-- SU	ingredient_of	SCDF
-- SU	ingredient_of	SCDG
-- SU	ingredient_of	SY
-- SU	ingredient_of	TMSY
-- SU	part_of	MIN
-- SU	part_of	SY
-- SU	part_of	TMSY
-- SU	precise_ingredient_of	BN
-- SU	precise_ingredient_of	SCDC
-- SU	precise_ingredient_of	TMSY

-- Q: Do RXNREL relationships exist crossing types between atoms and concepts? A: No
select * from rxnrel where
rxaui1 is not null and rxcui2 is not null or
rxcui1 is not null and rxaui2 is not null
; -- no results
-- Q: Do differing stypes occur in any row? A: No
select * from rxnrel where stype1 <> stype2;
-- No results.
-- Q: Are the CUI and AUI ever specified in the same row in RXNREL? A: No
select * from rxnrel where
  rxaui1 is not null and rxcui1 is not null or
  rxaui2 is not null and rxcui2 is not null
; -- no results

select * from splndc_drugconcept_v order by spl_ndc;

-- Around 1400 SPL NDCs have multiple associated drug concepts within sab=RXNORM.
select *, json_array_length(rxn_concepts) rxn_drug_count
from splndc_drugconcepts_json_v
order by json_array_length(rxn_concepts) desc, spl_ndc;




-- RXNCONSO - Drug names and unique identifiers
-- Has original source data atoms and their CUI memberships, with RXAUI as key.
-- ** Also contains the SAB=RXNORM atoms/concepts and their names and term types. **
-- Groups of atoms (rows) having the concept id are synonymous.
-- SPL NDC codes are listed in "CODE" column with sab='MTHSPL' and tty='DP'.

-- General Tylenol concept.
select rxaui, rxcui, sab, tty, code, str
from rxnconso
where rxcui = '202433' -- Tylenol
;
-- 1135801	202433	MMSL	BN	Tylenol
-- 1135802	202433	RXNORM	BN	Tylenol
-- 7972528	202433	MSH	PEP	Tylenol

-- Specific branded drug example: Tylenol tablet at 500 mg dosage
select rxaui, rxcui, sab, tty, code, str
from rxnconso
where rxcui = '209459'
order by sab, tty
;
/*
2650581	209459	GS	BD	24111	Tylenol Extra Strength 500mg Gelcap
2650584	209459	GS	BD	24114	Tylenol Extra Strength 500mg Tablet
...
10335274	209459	GS	BD	116908	Tylenol Extra Strength 500mg Tablet
1161545	209459	MMSL	BD	3826	Tylenol, 500 mg oral tablet
8702824	209459	MMSL	BD	3826	Tylenol Extra Strength Cool, 500 mg oral tablet
...
...
8713060	209459	MTHSPL	DP	50580-488	Acetaminophen 500 mg ORAL TABLET, COATED [TYLENOL Extra Strength]
8257852	209459	MTHSPL	DP	67751-167	ACETAMINOPHEN 500 mg ORAL TABLET [Tylenol Extra Strength]
8233711	209459	MTHSPL	DP	50580-449	Acetaminophen 500 mg ORAL TABLET, FILM COATED [TYLENOL Extra Strength]
7254163	209459	MTHSPL	DP	29485-1887	Acetaminophen 500 mg ORAL TABLET, COATED [TYLENOL Acetaminophen Extra Strength]
6799100	209459	MTHSPL	DP	50580-378	Acetaminophen 500 mg ORAL TABLET, FILM COATED [Tylenol Extra Strength]
8257058	209459	MTHSPL	DP	50580-412	Acetaminophen 500 mg ORAL TABLET, FILM COATED [TYLENOL Extra Strength]
9268328	209459	MTHSPL	DP	50090-0005	ACETAMINOPHEN 500 mg ORAL TABLET, FILM COATED [TYLENOL Extra Strength]
9718135	209459	MTHSPL	DP	67414-449	ACETAMINOPHEN 500 mg ORAL TABLET [Tylenol Extra Strength Caplet]
10286741	209459	MTHSPL	DP	50580-590	acetaminophen 500 mg ORAL TABLET, FILM COATED [TYLENOL Extra Strength]
10290640	209459	MTHSPL	DP	50580-692	acetaminophen 500 mg ORAL TABLET, FILM COATED [TYLENOL Extra Strength]
10337230	209459	MTHSPL	DP	50269-449	ACETAMINOPHEN 500 mg ORAL TABLET [Tylenol Extra Strength]
11432302	209459	MTHSPL	DP	73097-012	ACETAMINOPHEN 500 mg ORAL TABLET, FILM COATED [Tylenol Extra Strength]
11443201	209459	MTHSPL	DP	50580-937	Acetaminophen 500 mg ORAL TABLET, FILM COATED [Tylenol Extra Strength]
11800368	209459	MTHSPL	DP	50269-008	ACETAMINOPHEN 500 mg ORAL TABLET [Tylenol Extra Strength]
11806509	209459	MTHSPL	DP	67751-167	ACETAMINOPHEN 500 mg ORAL TABLET, FILM COATED [Tylenol Extra Strength]
12412590	209459	MTHSPL	DP	50580-457	acetaminophen 500 mg ORAL TABLET, FILM COATED [TYLENOL Extra Strength]
12615526	209459	MTHSPL	DP	50090-5469	ACETAMINOPHEN 500 mg ORAL TABLET, FILM COATED [Tylenol Extra Strength]
5043026	209459	MTHSPL	DP	66715-9747	Acetaminophen 500 mg ORAL TABLET, COATED [TYLENOL EXTRA STRENGTH]
4255819	209459	MTHSPL	DP	50580-451	Acetaminophen 500 mg ORAL TABLET, COATED [TYLENOL Extra Strength]
6364043	209459	RXNORM	PSN	209459	Tylenol Extra Strength 500 MG Oral Tablet
12356683	209459	RXNORM	SBD	209459	acetaminophen 500 MG Oral Tablet [Tylenol]
3858294	209459	RXNORM	SY	209459	APAP 500 MG Oral Tablet [Tylenol]
1161544	209459	RXNORM	SY	209459	Tylenol 500 MG Oral Tablet
3090103	209459	RXNORM	SY	209459	Tylenol Extra Strength 500 MG Oral Tablet
*/

-- Q: Are any SPL-sourced NDC codes associated with more than one rxn atom? A: Yes
select code spl_ndc, count(*) atom_count
from rxnconso
where sab='MTHSPL' and tty='DP'
group by code
having count(*) > 1
;
-- > 200 rows
-- Example: The NDC is mapped to the same concept in each row, but the description differs slightly.
select * from rxnconso where code = '00003-0293';
/*
1085680	ENG	... 10330868 ... MTHSPL	DP	00003-0293	TRIAMCINOLONE ACETONIDE 40 mg in 1 mL INFILTRATION INJECTION, SOLUTION		N
1085680	ENG	... 10330869 ... MTHSPL	DP	00003-0293	TRIAMCINOLONE ACETONIDE 40 mg in 1 mL INTRAMUSCULAR INJECTION, SOLUTION		N
*/

select * from splndc_rxnc_json_v
where json_array_length(rxn_concepts) > 1
;


-- Q: Can RXNCONSO be used to lookup a concept as a single atom/row?
-- A: No, generally there will be multiple rows for the concept even within sab=RXNORM.
-- But within sab=RXNORM there is a single atom/row for each tty of interest (SBD/SCD etc) if
-- tty is not one of SY,TMSY,ET.
-- So CUI and TTY determine the AUI (and thus the RXNCONSO row) within SAB=RXNORM if term types
-- SY, TMSY, ET are excluded.
select rxcui, tty rxn_tty, count(*) atom_count
from rxnconso
where sab='RXNORM' and tty not in ('SY', 'TMSY', 'ET')
group by rxcui, tty
having count(*) > 1
; -- No results
-- Example
select rxcui, tty, str from rxnconso where rxcui = '2480108' and sab='RXNORM';
/*
2480108	SBD	1 ML triamcinolone acetonide 40 MG/ML Injection [Kenalog]
2480108	SY	Kenalog 40 MG per 1 ML Injection
2480108	PSN	Kenalog 40 MG in 1 ML Injection
*/

-- Q: Does any CUI have an entry in sab=RXNORM for two or more drug / drug component / pack term types
--    (SBD,SCD,SCDC,SBDC,BPCK,GPCK)?
-- A: No. So drug and drug component concepts are particular to being branded or not, a component or not, and
--    a pack or not.
select rxcui, count(*) atom_count
from rxnconso
where sab='RXNORM' and tty in ('SBD','SCD','SCDC','SBDC','BPCK','GPCK')
group by rxcui
having count(*) > 1
; -- no rows

-- Verify that cui's are unique within the drug concepts view.
select drug_concept_v.rxcui
from drug_concept_v
group by drug_concept_v.rxcui
having count(*) > 1
; -- no results



-- TODO

select array_agg(distinct tty) from rxnconso where sab = 'RXNORM';
-- {BN,BPCK,DF,DFG,ET,GPCK,IN,MIN,PIN,PSN,SBD,SBDC,SBDF,SBDG,SCD,SCDC,SCDF,SCDG,SY,TMSY}

-- Q: Is every atom assigned to a concept? A: Yes
select count(*) from rxnconso where rxcui is null; -- 0
-- Q: Is every atom assigned to at most one concept?
-- TODO select rxaui from rxnconso where

--   UNII codes are available as 'CODE' value for SAB=MTHSPL TTY=SU atoms
--     But some of these are biologic drug substance codes. Maybe look elsewhere for UNII codes
--     if needed, there is mention of "UNII_CODE" attribute without mention of which table (not RXNSAT).
select rxaui, rxcui, code substance, str
from rxnconso
where sab = 'MTHSPL' and tty = 'SU'
;
-- 22,042 rows

select * from rxnsat where atn like 'UNI%';
-- no rows
select * from rxndoc where value = 'SU';



-- RXNREL.RRF - Relationships
-- Contains all of the relationships that exist between atoms and between concepts.
-- Only relates CUI to CUI or AUI to AUI, never crosses types:
select * from rxnrel
where rxcui1 is not null and rxaui2 is not null
 or rxaui1 is not null and rxcui2 is not null
;
-- (no rows)


-- RXNSAT : Attributes table.
select distinct atn
from rxnsat
where sab = 'RXNORM'
;
/*
AMBIGUITY_FLAG
NDC
ORIG_CODE
ORIG_SOURCE
RXN_ACTIVATED
RXN_AVAILABLE_STRENGTH
RXN_BN_CARDINALITY
RXN_BOSS_AI
RXN_BOSS_AM
RXN_BOSS_FROM
RXN_BOSS_STRENGTH_DENOM_UNIT
RXN_BOSS_STRENGTH_DENOM_VALUE
RXN_BOSS_STRENGTH_NUM_UNIT
RXN_BOSS_STRENGTH_NUM_VALUE
RXN_HUMAN_DRUG
RXN_IN_EXPRESSED_FLAG
RXN_OBSOLETED
RXN_QUALITATIVE_DISTINCTION
RXN_QUANTITY
RXN_STRENGTH
RXN_VET_DRUG
RXTERM_FORM
*/

select rxcui, rxaui, atv NDC
from rxnsat
where atn = 'NDC' and sab = 'RXNORM'
;



select pairs.rxcui, count(*)
from (
	select distinct rxcui, rxaui
	from rxnsat
	where atn = 'NDC' and sab = 'RXNORM'
) pairs
group by pairs.rxcui
having count(*) > 1
; 
-- no results