/* Some MTHSPL product atoms in rxnconso have an NDC code that does not match the base (non-packaging)
   part of the NDCs specified for the atom in RXNSAT.
*/
select p.rxaui, p.code, (select array_agg(pn.ndc) from mthspl_prod_ndc pn where pn.prod_rxaui = p.rxaui) ndc
from mthspl_prod p
where rxaui in (
  select p.rxaui
  from mthspl_prod_ndc pn
  join mthspl_prod p on p.rxaui = pn.prod_rxaui
  where strpos(pn.ndc, p.code) = 0
)
group by p.rxaui, p.code
;
/* (50 rows)
11828339,76420-604,{42023-159-25}
11828340,76420-604,{42023-159-25}
11828341,76420-604,{42023-159-25}
12400320,75109-018,{75109-011-40}
12400321,75109-017,{75109-010-20}
12400322,75109-018,{75109-008-40}
12400323,75109-016,{75109-013-20}
12400324,75109-017,{75109-013-20}
12400325,75109-016,{75109-009-20}
12400326,75109-018,{75109-009-40}
12400327,75109-017,{75109-007-20}
12400328,75109-018,{75109-007-40}
12400329,75109-017,{75109-012-20}
12400330,75109-016,{75109-015-20}
12400331,75109-016,{75109-014-20}
12401062,75109-019,{75109-010-40}
12401063,75109-020,{75109-010-20}
12401064,75109-019,{75109-008-40}
12401065,75109-021,{75109-013-20}
12401066,75109-021,{75109-009-20}
12401067,75109-019,{75109-007-40}
12401068,75109-020,{75109-007-20}
12401069,75109-020,{75109-012-20}
12401070,75109-021,{75109-014-20}
12412398,79312-103,{79312-102-01}
12412406,79312-103,{79312-101-01}
12513148,59062-5000,{59062-4000-5}
12516135,59062-5200,{59062-1100-2}
2598859,0054-4223,"{0054-4223-25,0054-8223-25}"
2598861,0054-8221,"{0054-4221-25,0054-4221-31,0054-8221-25}"
2598863,0054-8222,"{0054-4222-25,0054-4222-31,0054-8222-25}"
2599753,0054-8596,"{0054-4596-25,0054-8596-11}"
2599754,0054-8595,"{0054-4595-25,0054-8595-11}"
2622289,0054-4146,"{0054-4146-22,0054-4146-23,0054-8146-22}"
2622291,0054-4146,"{0054-4146-22,0054-4146-23,0054-8146-22}"
2622315,0054-4129,"{0054-4129-25,0054-8089-25}"
2622317,0054-4130,"{0054-4130-25,0054-8130-25}"
2653060,0054-4297,"{0054-4297-25,0054-4297-31,0054-8297-25}"
2653061,0054-4299,"{0054-4299-25,0054-4299-31,0054-8299-25}"
2653062,0054-8298,"{0054-3298-63,0054-8298-16}"
2653063,0054-4301,"{0054-4301-25,0054-4301-29,0054-8301-25}"
2751473,0054-8179,"{0054-4179-25,0054-8179-25}"
2751475,0054-8180,"{0054-4180-25,0054-8180-25}"
2751477,0054-8174,"{0054-4181-25,0054-8174-25}"
2751478,0054-8181,"{0054-4182-25,0054-4182-31,0054-8181-25}"
2751479,0054-8176,"{0054-4183-25,0054-8176-25}"
2751480,0054-8175,"{0054-4184-25,0054-8175-25}"
2751481,0054-8183,"{0054-4186-25,0054-8183-25}"
2802942,0143-9939,"{0143-9938-01,0143-9939-05,0143-9939-20}"
2863416,66304-971,"{63304-971-05,63304-971-14,63304-971-70,66304-971-10}"
*/

/*
 some MTHSPL products don't have setids. Discovered from a left join between mthspl_prod and mthspl_prod_setid
 */
select p.rxaui, p.rxcui, p.name, mps.spl_set_id
from mthspl_prod p
left join mthspl_prod_setid mps on p.rxaui = mps.prod_rxaui
where mps.spl_set_id is null
;
/* 20 rows
3052753,197603,"DIFLUNISAL 500 mg ORAL TABLET, FILM COATED",
3030532,855671,PHENYTOIN SODIUM 100 mg ORAL CAPSULE [Extended Phenytoin Sodium],
2996621,848746,ILOPERIDONE 6 mg ORAL TABLET [Fanapt],
2651919,762674,"Aminolevulinic acid hydrochloride 354 MILLIGRAM In 1.5 MILLILITER TOPICAL POWDER, FOR SOLUTION [LEVULAN]",
2638113,727993,Pilocarpine Hydrochloride 17.5 MILLIGRAM In 1 MILLILITER OPHTHALMIC SOLUTION,
2801622,763017,"insulin human 1 MILLIGRAM In 1 BLISTER RESPIRATORY (INHALATION) AEROSOL, POWDER [Exubera]",
2751517,744557,"Fanolesomab 0.25 MILLIGRAM In 1 VIAL INTRAVENOUS INJECTION, POWDER, LYOPHILIZED, FOR SOLUTION",
3052735,200346,CEFDINIR 300 mg ORAL CAPSULE,
2948679,729534,"desogestrel 0.15 MILLIGRAM In 1 TABLET / ethinyl estradiol 0.025 MILLIGRAM In 1 TABLET ORAL TABLET, FILM COATED",
2801624,763018,"insulin human 3 MILLIGRAM In 1 BLISTER RESPIRATORY (INHALATION) AEROSOL, POWDER [Exubera]",
2948678,759741,"desogestrel 0.125 MILLIGRAM In 1 TABLET / ethinyl estradiol 0.025 MILLIGRAM In 1 TABLET ORAL TABLET, FILM COATED",
2798741,545837,"leuprolide acetate 5 MILLIGRAM In 1 MILLILITER SUBCUTANEOUS INJECTION, SOLUTION [Lupron]",
3052784,997406,"FEXOFENADINE HYDROCHLORIDE 60 mg / PSEUDOEPHEDRINE HYDROCHLORIDE 120 mg ORAL TABLET, FILM COATED, EXTENDED RELEASE",
3052935,827750,"propoxyphene napsylate 100 mg ORAL TABLET, FILM COATED [Darvon-N]",
3052742,200371,CITALOPRAM HYDROBROMIDE 20 mg ORAL TABLET,
2752115,284407,LEUPROLIDE ACETATE 72 MILLIGRAM In 1 IMPLANT SUBCUTANEOUS IMPLANT [Viadur],
2752116,1010671,Lidocaine hydrochloride 20 MILLIGRAM In 1 MILLILITER TOPICAL LIQUID [Lidocaine hydrochloride],
2751579,1791511,"Sodium Ascorbate 500 MILLIGRAM In 1 MILLILITER INTRAVENOUS INJECTION, SOLUTION [Cenolate]",
2638106,308719,Betaxolol Hydrochloride 2.5 MILLIGRAM In 1 MILLILITER OPHTHALMIC SUSPENSION,
2948677,654353,"desogestrel 0.1 MILLIGRAM In 1 TABLET / ethinyl estradiol 0.025 MILLIGRAM In 1 TABLET ORAL TABLET, FILM COATED",

 */
--NDC with multiple label types, 111 rows
-- 10286836,2200076,35781-0500,0,LIDOCAINE 40 mg in 1 g,N,,"{793d6fad-31a7-4b28-8395-73825bc18508,9d830535-2202-482d-9d1a-bccd7bbba855}","{HUMAN OTC DRUG LABEL,HUMAN PRESCRIPTION DRUG LABEL}","{International Brand Management, LLC}",,
-- 10768314,834127,53462-003,0,CHLORHEXIDINE GLUCONATE 1.2 mg in 1 mL BUCCAL LIQUID [Chlorhexidine Gluconate 0.12% Oral Rinse],O,,"{3c754532-d9a5-f876-00c4-05a4c9b21efa,6ea1691d-5379-f0c0-1b37-ecf08f6dbc00}","{HUMAN OTC DRUG LABEL,HUMAN PRESCRIPTION DRUG LABEL}",{Sage Products LLC},{ANDA},{ANDA077789}
-- 10776090,1807639,0264-7800,1,"SODIUM CHLORIDE 0.9 g in 100 mL INTRAVENOUS INJECTION, SOLUTION_#1",N,Duplicate,"{055bde33-c7de-43ce-9570-f9ac08cb405f,47a0313f-36df-4fa6-a828-c9e1946ba9b0,963612e4-cc3d-42f6-82e9-31b178440129,9ef8edbd-047a-40fe-a603-d71fce8ada68}","{HUMAN PRESCRIPTION DRUG LABEL,MEDICAL DEVICE}","{Aerospace Accessory Service, Inc,B. Braun Medical Inc.}",{NDA},{NDA019635}
-- 10776091,1807634,0264-7800,1,"SODIUM CHLORIDE 0.9 g in 100 mL INTRAVENOUS INJECTION, SOLUTION_#2",N,Duplicate,"{055bde33-c7de-43ce-9570-f9ac08cb405f,47a0313f-36df-4fa6-a828-c9e1946ba9b0,963612e4-cc3d-42f6-82e9-31b178440129,9ef8edbd-047a-40fe-a603-d71fce8ada68}","{HUMAN PRESCRIPTION DRUG LABEL,MEDICAL DEVICE}","{Aerospace Accessory Service, Inc,B. Braun Medical Inc.}",{NDA},{NDA019635}
select * from mthspl_rxprod_v where array_length(label_types, 1) > 1;


--appl codes has multiple NDCs under it
--appl numbers are not drugs, proof (see below), different doses and different CUIs
--ANDA061395,49,"[[{""fullNDC"": ""0781-9261-85"", ""shortNDC"": ""0781-9261""}, {""fullNDC"": ""0781-9261-95"", ""shortNDC"": ""0781-9261""}], [{""fullNDC"": ""0781-9401-78"", ""shortNDC"": ""0781-9401""}, {""fullNDC"": ""0781-9401-95"", ""shortNDC"": ""0781-9401""}], [{""fullNDC"": ""0781-9401-78"", ""shortNDC"": ""0781-9401""}, {""fullNDC"": ""0781-9401-95"", ""shortNDC"": ""0781-9401""}], [{""fullNDC"": ""0781-3407-78"", ""shortNDC"": ""0781-3407""}, {""fullNDC"": ""0781-3407-95"", ""shortNDC"": ""0781-3407""}], [{""fullNDC"": ""0781-9407-78"", ""shortNDC"": ""0781-9407""}, {""fullNDC"": ""0781-9407-95"", ""shortNDC"": ""0781-9407""}], [{""fullNDC"": ""0781-9407-78"", ""shortNDC"": ""0781-9407""}, {""fullNDC"": ""0781-9407-95"", ""shortNDC"": ""0781-9407""}], [{""fullNDC"": ""0409-3718-01"", ""shortNDC"": ""0409-3718""}, {""fullNDC"": ""0409-3718-10"", ""shortNDC"": ""0409-3718""}], [{""fullNDC"": ""0781-3404-85"", ""shortNDC"": ""0781-3404""}, {""fullNDC"": ""0781-3404-95"", ""shortNDC"": ""0781-3404""}], [{""fullNDC"": ""0409-3726-01"", ""shortNDC"": ""0409-3726""}, {""fullNDC"": ""0409-3726-10"", ""shortNDC"": ""0409-3726""}], [{""fullNDC"": ""0781-9408-80"", ""shortNDC"": ""0781-9408""}, {""fullNDC"": ""0781-9408-95"", ""shortNDC"": ""0781-9408""}], [{""fullNDC"": ""0409-3720-01"", ""shortNDC"": ""0409-3720""}, {""fullNDC"": ""0409-3720-10"", ""shortNDC"": ""0409-3720""}], [{""fullNDC"": ""0781-3409-46"", ""shortNDC"": ""0781-3409""}, {""fullNDC"": ""0781-3409-95"", ""shortNDC"": ""0781-3409""}], [{""fullNDC"": ""0781-9242-78"", ""shortNDC"": ""0781-9242""}, {""fullNDC"": ""0781-9242-95"", ""shortNDC"": ""0781-9242""}], [{""fullNDC"": ""63323-707-20"", ""shortNDC"": ""63323-707""}], [{""fullNDC"": ""63323-707-20"", ""shortNDC"": ""63323-707""}], [{""fullNDC"": ""0781-9250-78"", ""shortNDC"": ""0781-9250""}, {""fullNDC"": ""0781-9250-95"", ""shortNDC"": ""0781-9250""}], [{""fullNDC"": ""63323-708-00"", ""shortNDC"": ""63323-708""}], [{""fullNDC"": ""0781-3404-85"", ""shortNDC"": ""0781-3404""}, {""fullNDC"": ""0781-3404-95"", ""shortNDC"": ""0781-3404""}], [{""fullNDC"": ""26637-321-01"", ""shortNDC"": ""26637-321""}], [{""fullNDC"": ""0781-9408-80"", ""shortNDC"": ""0781-9408""}, {""fullNDC"": ""0781-9408-95"", ""shortNDC"": ""0781-9408""}], [{""fullNDC"": ""0781-9273-80"", ""shortNDC"": ""0781-9273""}, {""fullNDC"": ""0781-9273-95"", ""shortNDC"": ""0781-9273""}], [{""fullNDC"": ""0781-3400-78"", ""shortNDC"": ""0781-3400""}, {""fullNDC"": ""0781-3400-95"", ""shortNDC"": ""0781-3400""}], [{""fullNDC"": ""0409-3725-01"", ""shortNDC"": ""0409-3725""}, {""fullNDC"": ""0409-3725-11"", ""shortNDC"": ""0409-3725""}], [{""fullNDC"": ""0781-9409-46"", ""shortNDC"": ""0781-9409""}, {""fullNDC"": ""0781-9409-95"", ""shortNDC"": ""0781-9409""}], [{""fullNDC"": ""26637-321-01"", ""shortNDC"": ""26637-321""}], [{""fullNDC"": ""0781-9404-85"", ""shortNDC"": ""0781-9404""}, {""fullNDC"": ""0781-9404-95"", ""shortNDC"": ""0781-9404""}], [{""fullNDC"": ""0409-3718-01"", ""shortNDC"": ""0409-3718""}, {""fullNDC"": ""0409-3718-10"", ""shortNDC"": ""0409-3718""}], [{""fullNDC"": ""63323-708-00"", ""shortNDC"": ""63323-708""}], [{""fullNDC"": ""0781-9250-78"", ""shortNDC"": ""0781-9250""}, {""fullNDC"": ""0781-9250-95"", ""shortNDC"": ""0781-9250""}], [{""fullNDC"": ""0409-3719-01"", ""shortNDC"": ""0409-3719""}, {""fullNDC"": ""0409-3719-10"", ""shortNDC"": ""0409-3719""}], [{""fullNDC"": ""0781-9242-78"", ""shortNDC"": ""0781-9242""}, {""fullNDC"": ""0781-9242-95"", ""shortNDC"": ""0781-9242""}], [{""fullNDC"": ""0781-9402-78"", ""shortNDC"": ""0781-9402""}, {""fullNDC"": ""0781-9402-95"", ""shortNDC"": ""0781-9402""}], [{""fullNDC"": ""0781-9402-78"", ""shortNDC"": ""0781-9402""}, {""fullNDC"": ""0781-9402-95"", ""shortNDC"": ""0781-9402""}], [{""fullNDC"": ""0781-3402-78"", ""shortNDC"": ""0781-3402""}, {""fullNDC"": ""0781-3402-95"", ""shortNDC"": ""0781-3402""}], [{""fullNDC"": ""0781-3402-78"", ""shortNDC"": ""0781-3402""}, {""fullNDC"": ""0781-3402-95"", ""shortNDC"": ""0781-3402""}], [{""fullNDC"": ""0781-9261-85"", ""shortNDC"": ""0781-9261""}, {""fullNDC"": ""0781-9261-95"", ""shortNDC"": ""0781-9261""}], [{""fullNDC"": ""0409-3726-01"", ""shortNDC"": ""0409-3726""}, {""fullNDC"": ""0409-3726-10"", ""shortNDC"": ""0409-3726""}], [{""fullNDC"": ""50090-4552-0"", ""shortNDC"": ""50090-4552""}], [{""fullNDC"": ""0781-9273-80"", ""shortNDC"": ""0781-9273""}, {""fullNDC"": ""0781-9273-95"", ""shortNDC"": ""0781-9273""}], [{""fullNDC"": ""0409-3720-01"", ""shortNDC"": ""0409-3720""}, {""fullNDC"": ""0409-3720-10"", ""shortNDC"": ""0409-3720""}], [{""fullNDC"": ""0781-3400-78"", ""shortNDC"": ""0781-3400""}, {""fullNDC"": ""0781-3400-95"", ""shortNDC"": ""0781-3400""}], [{""fullNDC"": ""63323-704-08"", ""shortNDC"": ""63323-704""}], [{""fullNDC"": ""0409-3719-01"", ""shortNDC"": ""0409-3719""}, {""fullNDC"": ""0409-3719-10"", ""shortNDC"": ""0409-3719""}], [{""fullNDC"": ""0781-3407-78"", ""shortNDC"": ""0781-3407""}, {""fullNDC"": ""0781-3407-95"", ""shortNDC"": ""0781-3407""}], [{""fullNDC"": ""0781-9404-85"", ""shortNDC"": ""0781-9404""}, {""fullNDC"": ""0781-9404-95"", ""shortNDC"": ""0781-9404""}], [{""fullNDC"": ""63323-704-08"", ""shortNDC"": ""63323-704""}], [{""fullNDC"": ""0781-3408-80"", ""shortNDC"": ""0781-3408""}, {""fullNDC"": ""0781-3408-95"", ""shortNDC"": ""0781-3408""}], [{""fullNDC"": ""0781-3408-80"", ""shortNDC"": ""0781-3408""}, {""fullNDC"": ""0781-3408-95"", ""shortNDC"": ""0781-3408""}], [{""fullNDC"": ""63323-705-08"", ""shortNDC"": ""63323-705""}]]","[[""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""6632a5bd-45f1-422f-80b0-46e5a628969a""], [""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""f9cc8138-457a-491a-9b58-f59c65281515""], [""f9cc8138-457a-491a-9b58-f59c65281515""], [""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""f9cc8138-457a-491a-9b58-f59c65281515""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""b6445bba-df89-4fd3-ab3d-393256dba07a""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""2fdfe288-f851-4c3d-a542-9f20d6af2b1d""], [""5308ddfa-4a5b-4f7b-83ce-9d1b528e050d""], [""b6445bba-df89-4fd3-ab3d-393256dba07a""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""f9cc8138-457a-491a-9b58-f59c65281515""], [""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""b55a10b4-222e-49a3-8020-86ec344b64e3""], [""c2908a44-1da4-4885-ae5a-23f69189d91a""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""f9cc8138-457a-491a-9b58-f59c65281515""], [""3d1c4b4d-18e2-4e8f-9701-badaa462c733""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""b371e1a5-1fef-4df2-8940-c4fc02b9e2f0""], [""f9cc8138-457a-491a-9b58-f59c65281515""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""64a04e8c-8f78-46b3-8f45-56ef225a4f74""], [""f9cc8138-457a-491a-9b58-f59c65281515""]]","{AMPICILLIN SODIUM 1 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 125 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 125 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 10 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 125 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 10 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 10 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 125 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 250 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 500 mg INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 1 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAMUSCULAR INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin],AMPICILLIN SODIUM 2 g INTRAVENOUS INJECTION, POWDER, FOR SOLUTION [Ampicillin]}","{ampicillin 1000 MG Injection,ampicillin 125 MG Injection,ampicillin 125 MG Injection,ampicillin 500 MG Injection,ampicillin 500 MG Injection,ampicillin 500 MG Injection,ampicillin 500 MG Injection,ampicillin 1000 MG Injection,ampicillin 1000 MG Injection,ampicillin 2000 MG Injection,ampicillin 2000 MG Injection,ampicillin 100 MG/ML Injectable Solution,ampicillin 250 MG Injection,ampicillin 250 MG Injection,ampicillin 250 MG Injection,ampicillin 500 MG Injection,ampicillin 500 MG Injection,ampicillin 1000 MG Injection,ampicillin 1000 MG Injection,ampicillin 2000 MG Injection,ampicillin 2000 MG Injection,ampicillin 125 MG Injection,ampicillin 100 MG/ML Injectable Solution,ampicillin 100 MG/ML Injectable Solution,ampicillin 1000 MG Injection,ampicillin 1000 MG Injection,ampicillin 500 MG Injection,ampicillin 500 MG Injection,ampicillin 500 MG Injection,ampicillin 250 MG Injection,ampicillin 250 MG Injection,ampicillin 250 MG Injection,ampicillin 250 MG Injection,ampicillin 250 MG Injection,ampicillin 250 MG Injection,ampicillin 1000 MG Injection,ampicillin 1000 MG Injection,ampicillin 2000 MG Injection,ampicillin 2000 MG Injection,ampicillin 2000 MG Injection,ampicillin 125 MG Injection,ampicillin 1000 MG Injection,ampicillin 250 MG Injection,ampicillin 500 MG Injection,ampicillin 1000 MG Injection,ampicillin 1000 MG Injection,ampicillin 2000 MG Injection,ampicillin 2000 MG Injection,ampicillin 2000 MG Injection}","{1721473,1721474,1721475,1721476,308207,789980}"
select
  application_code,
  count(*)                              count,
  jsonb_agg(distinct ndcs)              ndcs,
  jsonb_agg(distinct set_ids)           set_ids,
  array_agg(distinct product_name)      product_names,
  array_agg(distinct rxnorm_drug_name)  drug_names,
  array_agg(distinct rxnorm_concept_id) rxcui,
  jsonb_agg(distinct label_types)       label_types
from mthspl_mktcode_rxprod_drug_v
where application_code not like 'B%'
group by application_code having count(*) > 1
order by count desc
;

--ATC DRUG CLASSES WITH MORE THAN ONE AUI OR CUI
--78 have more than one rxaui or rxcui
select distinct c.str, array_agg(distinct c.rxaui), array_agg(distinct c.rxcui), s.atn
from rxnconso c
join rxnsat s on s.rxaui = c.rxaui
where s.sab = 'ATC'
and s.atn = 'IS_DRUG_CLASS'
group by c.str, s.atn
having array_length(array_agg(distinct c.rxaui), 1) > 1 or array_length(array_agg(distinct c.rxcui), 1) > 1




--TODO
-- potential anomaly, one MIN include IN not found in SCDCs for its drug: 1234471
select distinct ingrset.rxcui
from ingrset
join scd on scd.ingrset_rxcui = ingrset.rxcui
join ingrset_ingr seti on ingrset.rxcui = seti.ingrset_rxcui
where not exists (
  select 1
  from scdc
  join scdc_scd on scdc.rxcui = scdc_scd.scdc_rxcui
  where            scd.rxcui = scdc_scd.scd_rxcui
  and scdc.ingr_rxcui = seti.ingr_rxcui
)
and ingrset.tty = 'MIN'
;
--TODO update child table to include single ingredients
-- potential anomaly, one MIN include PIN not found in SCDCs for its drug: 113931
select distinct ingrset.rxcui
from ingrset
join scd on scd.ingrset_rxcui = ingrset.rxcui
join ingrset_pin seti on ingrset.rxcui = seti.ingrset_rxcui
where not exists (
  select 1
  from scdc
  join scdc_scd on scdc.rxcui = scdc_scd.scdc_rxcui
  where scd.rxcui = scdc_scd.scd_rxcui
  and scdc.pin_rxcui = seti.pin_rxcui
)
and ingrset.tty = 'MIN'
;

--(ALL SCDC IN have corresponding IN in ingrset)
select scdc.rxcui, scdc.name, scd.rxcui, scd.name, iset.rxcui, iset.name
from scdc
join scdc_scd on scdc.rxcui = scdc_scd.scdc_rxcui
join scd on scd.rxcui = scdc_scd.scd_rxcui
join ingrset iset on iset.rxcui = scd.ingrset_rxcui and iset.tty = 'MIN'
where not exists (
  select 1
  from ingrset_ingr seti
  where iset.rxcui = seti.ingrset_rxcui
  and seti.ingr_rxcui = scdc.ingr_rxcui
)
and scdc.pin_rxcui is null
;

/* These tables are not needed currently, but are useful to look for anomalies.
create table ingrset_ingr (
  ingrset_rxcui varchar(12) not null,
  ingr_rxcui varchar(12) not null,
  constraint pk_ingrsetingr_cui primary key (ingrset_rxcui, ingr_rxcui),
  constraint fk_ingrsetingr_ingrset foreign key (ingrset_rxcui) references ingrset,
  constraint fk_ingrsetingr_ingr foreign key (ingr_rxcui) references ingr
);

create table ingrset_pin (
  ingrset_rxcui varchar(12) not null,
  pin_rxcui varchar(12) not null,
  constraint pk_ingrsetpin_cui primary key (ingrset_rxcui, pin_rxcui),
  constraint fk_ingrsetpin_ingrset foreign key (ingrset_rxcui) references ingrset,
  constraint fk_ingrsetpin_pin foreign key (pin_rxcui) references pin
);
*/

-- Why single scdf's involve drugs with multiple different ingredient sets?
select scdf.rxcui, array_agg(distinct ingrset.tty) ingrset_ttys, array_agg(scd.ingrset_rxcui), array_agg(scd.name) scd_names
from scd
join scdf on scdf.rxcui = scd.scdf_rxcui
join ingrset on ingrset.rxcui = scd.ingrset_rxcui
group by scdf.rxcui
having count(distinct scd.ingrset_rxcui) > 1
;

/* Ignored scdg/sbdg attribute: RXN_AVAILABLE_STRENGTH
select scdg.rxcui, s.atv
from rxnsat s
join scdg on scdg.rxcui = s.rxcui
where s.sab = 'RXNORM' and s.atn = 'RXN_AVAILABLE_STRENGTH';

Ignoring this attribute because it's not clear/defined what the ingredients are that
have the listed strengths that are /-separated. This information is better found by
navigating from the scdg to the scd to the scdc's.
*/


