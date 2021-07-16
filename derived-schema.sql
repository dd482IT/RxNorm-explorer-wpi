----------sab = mthspl-----------
create table mthspl_sub (
  rxaui varchar(12) not null primary key,
  rxcui varchar(12) not null,
  unii varchar(10),
  biologic_code varchar(18),
  name varchar(2000) not null,
  suppress varchar(1) not null,
  constraint mthspl_sub_notuniiandbiocode_ck check (unii is null or biologic_code is null)
);
create index mthspl_sub_cui on mthspl_sub(rxcui);
create index mthspl_sub_unii on mthspl_sub(unii);
create index mthspl_sub_code on mthspl_sub(biologic_code);

create table mthspl_prod (
  rxaui varchar(12) not null primary key,
  rxcui varchar(12) not null,
  code varchar(13), -- Most of these are NDCs without packaging (3rd part), some are not NDCs at all.
  rxnorm_created int not null check (rxnorm_created in (0,1)),
  name varchar(4000) not null,
  suppress varchar(1) not null,
  ambiguity_flag varchar(9)
);
create index mthspl_prod_cui on mthspl_prod(rxcui);
create index mthspl_prod_code on mthspl_prod(code);

create table mthspl_sub_setid (
  sub_rxaui varchar(12) not null references mthspl_sub,
  set_id varchar(46) not null,
  suppress varchar(1) not null,
  primary key (sub_rxaui, set_id)
);
create index mthspl_subsetid_setid_x on mthspl_sub_setid(set_id);

create table mthspl_ingrtype (
  ingr_type varchar(1) not null primary key,
  description varchar(1000) not null
);

create table mthspl_prod_sub (
  prod_rxaui varchar(12) not null references mthspl_prod,
  ingr_type varchar(1) not null references mthspl_ingrtype,
  sub_rxaui varchar(12) not null references mthspl_sub,
  primary key (prod_rxaui, ingr_type, sub_rxaui)
);
create index mthspl_prodsub_subaui_ix on mthspl_prod_sub(sub_rxaui);

create table mthspl_prod_dmspl (
  prod_rxaui varchar(12) not null references mthspl_prod,
  dm_spl_id varchar(46) not null,
  primary key (prod_rxaui, dm_spl_id)
);
create index mthspl_proddmspl_dmsplid_ix on mthspl_prod_dmspl(dm_spl_id);

create table mthspl_prod_setid (
  prod_rxaui varchar(12) not null references mthspl_prod,
  spl_set_id varchar(46) not null,
  primary key (prod_rxaui, spl_set_id)
);
create index mthsplprodsetid_setid_ix on mthspl_prod_setid(spl_set_id);

create table mthspl_prod_ndc (
  prod_rxaui varchar(12) not null references mthspl_prod,
  full_ndc varchar(12) not null,
  two_part_ndc varchar(12) not null,
  primary key (prod_rxaui, full_ndc)
);
create index mthsplprodndc_fullndc_ix on mthspl_prod_ndc(full_ndc);
create index mthsplprodndc_twopartndc_ix on mthspl_prod_ndc(two_part_ndc);

create table mthspl_prod_labeler (
  prod_rxaui varchar(12) not null references mthspl_prod,
  labeler varchar(2000) not null,
  primary key (prod_rxaui, labeler)
);

create table mthspl_prod_labeltype (
  prod_rxaui varchar(12) not null references mthspl_prod,
  label_type varchar(500) not null,
  primary key (prod_rxaui, label_type)
);
create index mthsplprodlblt_lblt_ix on mthspl_prod_labeltype(label_type);

create table mthspl_prod_mktstat (
  prod_rxaui varchar(12) not null references mthspl_prod,
  mkt_stat varchar(500) not null,
  primary key (prod_rxaui, mkt_stat)
);
create index mthsplprodmktstat_mktstat_ix on mthspl_prod_mktstat(mkt_stat);

create table mthspl_prod_mkteffth (
  prod_rxaui varchar(12) not null references mthspl_prod,
  mkt_eff_time_high varchar(8) not null,
  primary key (prod_rxaui, mkt_eff_time_high)
);
create index mthsplprodmkteffth_mkteffth_ix on mthspl_prod_mkteffth(mkt_eff_time_high);

create table mthspl_prod_mktefftl (
  prod_rxaui varchar(12) not null references mthspl_prod,
  mkt_eff_time_low varchar(8) not null,
  primary key (prod_rxaui, mkt_eff_time_low)
);
create index mthsplprodmktefftl_mktetl_ix on mthspl_prod_mktefftl(mkt_eff_time_low);

create table mthspl_prod_mktcat (
  prod_rxaui varchar(12) not null references mthspl_prod,
  mkt_cat varchar(500) not null,
  primary key (prod_rxaui, mkt_cat)
);
create index mthsplprodmktcat_mktcat_ix on mthspl_prod_mktcat(mkt_cat);

create table mthspl_mktcat (
  name varchar(500) primary key
);

create table mthspl_prod_mktcat_code (
  prod_rxaui varchar(12) not null references mthspl_prod,
  mkt_cat varchar(500) not null references mthspl_mktcat,
  code varchar(20) not null,
  primary key (prod_rxaui, mkt_cat, code)
);
create index mthsplprodmktcatcode_mktcat_ix on mthspl_prod_mktcat_code(mkt_cat);
create index mthsplprodmktcatcode_code_ix on mthspl_prod_mktcat_code(code);

create table mthspl_pillattr (
  attr varchar(500) primary key
);

create table mthspl_prod_pillattr (
  prod_rxaui varchar(12) not null references mthspl_prod,
  attr varchar(500) not null references mthspl_pillattr,
  attr_val varchar(1000) not null,
  primary key (prod_rxaui, attr, attr_val)
);
create index mthsplprodpillattr_attr_ix on mthspl_prod_pillattr(attr);
create index mthsplprodpillattr_attrval_ix on mthspl_prod_pillattr(attr_val);

create table mthspl_prod_dcsa (
  prod_rxaui varchar(12) not null references mthspl_prod,
  dcsa varchar(4) not null,
  primary key (prod_rxaui, dcsa)
);
create index mthsplproddcsa_dcsa_ix on mthspl_prod_dcsa(dcsa);

create table mthspl_prod_nhric (
  prod_rxaui varchar(12) not null references mthspl_prod,
  nhric varchar(13) not null,
  primary key (prod_rxaui, nhric)
);
create index mthsplproddcsa_nhric_ix on mthspl_prod_nhric(nhric);

----------------------------------------------sab = RXNORM-------------------------------------------
create table ingr (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  suppress varchar(1) not null
);

create table ingr_unii (
  ingr_rxcui varchar(12) not null,
  unii varchar(10) not null,
  constraint pk_ingrunii_cuiunii primary key (ingr_rxcui, unii),
  constraint fk_ingrunii_ingr foreign key (ingr_rxcui) references ingr
);
create index ix_ingrunii_unii on ingr_unii(unii);

create table pin (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  suppress varchar(1) not null
);

create table pin_unii (
  pin_rxcui varchar(12) not null,
  unii varchar(10) not null,
  constraint pk_pinunii_cuiunii primary key (pin_rxcui, unii),
  constraint fk_pinunii_pin foreign key (pin_rxcui) references pin
);
create index ix_pinunii_rxcui on pin_unii(pin_rxcui);

create table ingr_pin (
  ingr_rxcui varchar(12) not null,
  pin_rxcui varchar(12) not null,
  constraint pk_ingrpin_cui primary key (ingr_rxcui, pin_rxcui),
  constraint fk_ingrpin_ingr foreign key (ingr_rxcui) references ingr,
  constraint fk_ingrpin_pin foreign key (pin_rxcui) references pin
);

create table min (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  suppress varchar(1) not null
);


create table ingrset (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  suppress varchar(1) not null,
  tty varchar(100) not null
);

drop table if exists temp_ingrset;
create table temp_ingrset (
  drug_rxcui varchar(12) not null,
  ingr_rxcui varchar(12) not null,
  ingr_rxaui varchar(12) not null,
  ingr_name varchar(2000) not null,
  ingr_suppress varchar(1) not null,
  ingr_tty varchar(100) not null,
  constraint pk_tingrset_cui primary key (drug_rxcui, ingr_rxcui)
);
create index ixt_tempingrset on temp_ingrset(ingr_rxcui);

create table df (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null,
  origin varchar(500),
  code varchar(500)
);

create table dfg (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null
);

create table df_dfg (
  df_rxcui varchar(12) not null,
  dfg_rxcui varchar(12) not null,
  constraint pk_dfdfg_cui primary key (df_rxcui, dfg_rxcui),
  constraint fk_dfdfg_df foreign key (df_rxcui) references df,
  constraint fk_dfdfg_dfg foreign key (dfg_rxcui) references dfg
);

create table scd (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null unique,
  tty varchar(11) not null,
  name varchar(2000) not null,
  prescribable_name varchar(2000),
  rxterm_form varchar(100),
  df_rxcui varchar(2000) not null,
  ingrset_rxcui varchar(12) not null,
  avail_strengths varchar(500),
  qual_distinct varchar(500),
  suppress varchar(1) not null,
  quantity varchar(100),
  human_drug int2,
  vet_drug int2,
  unquantified_form_rxcui varchar(12),
  constraint fk_scd_ingrset foreign key (ingrset_rxcui) references ingrset,
  constraint fk_scd_df foreign key (df_rxcui) references df,
  constraint fk_scd_qform_scd foreign key (unquantified_form_rxcui) references scd
);

create table sbd (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null unique,
  tty varchar(11) not null,
  name varchar(2000) not null,
  prescribable_name varchar(2000),
  rxterm_form varchar(100),
  df_rxcui varchar(12) not null,
  avail_strengths varchar(500),
  qual_distinct varchar(500),
  suppress varchar(1) not null,
  quantity varchar(100),
  human_drug int2,
  vet_drug int2,
  unquantified_form_rxcui varchar(12),
  constraint fk_sbd_df foreign key (df_rxcui) references df,
  constraint fk_sbd_qform_sbd foreign key (unquantified_form_rxcui) references sbd
);

create table gpck (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null unique,
  tty varchar(11) not null,
  name varchar(2000) not null,
  prescribable_name varchar(2000),
  df_rxcui varchar(12) not null,
  suppress varchar(1) not null,
  human_drug int2,
  constraint fk_gpck_df foreign key (df_rxcui) references df
);

create table bpck (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null unique,
  tty varchar(11) not null,
  name varchar(2000) not null,
  prescribable_name varchar(2000),
  df_rxcui varchar(12) not null,
  suppress varchar(1) not null,
  human_drug int2,
  constraint fk_bpck_df foreign key (df_rxcui) references df
);


create table bn (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  rxn_cardinality varchar(6),
  reformulated_to_rxcui varchar(12),
  constraint fk_bn_bn foreign key (reformulated_to_rxcui) references bn
);
comment on table bn is 'brand name';

create table scdc (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  boss_active_ingr_name varchar(2000),
  boss_active_moi_name varchar(2000),
  boss_source varchar(10),
  rxn_in_expressed_flag varchar(10),
  strength varchar(500),
  boss_str_num_unit varchar(100),
  boss_str_num_val varchar(100),
  boss_str_denom_unit varchar(100),
  boss_str_denom_val varchar(100),
  ingr_rxcui varchar(12),
  pin_rxcui varchar(12),
  constraint fk_scdc_ingr foreign key (ingr_rxcui) references ingr,
  constraint fk_scdc_pin foreign key (pin_rxcui) references pin
);

create table scdf (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  df_rxcui varchar(12) not null,
  constraint fk_scdf_df foreign key (df_rxcui) references df
);

create table scdg (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  dfg_rxcui varchar(12) not null,
  constraint fk_scdg_dfg foreign key (dfg_rxcui) references dfg
);

create table scdg_astr (
  scdg_rxcui varchar(12) not null,
  rxn_available_strength varchar(2000) not null,
  constraint pk_scdgstr_cuistr primary key (scdg_rxcui, rxn_available_strength),
  constraint fk_scdgstr_scdg foreign key (scdg_rxcui) references scdg
);

create table sbdc (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null
);

create table sbdf (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null,
  df_rxcui varchar(12) not null,
  constraint fk_sbdf_df foreign key (df_rxcui) references df
);

create table sbdg (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null,
  dfg_rxcui varchar(12) not null,
  constraint fk_sbdg_dfg foreign key (dfg_rxcui) references dfg
);

create table sbdg_astr (
  sbdg_rxcui varchar(12) not null,
  RXN_AVAILABLE_STRENGTH varchar(2000) not null,
  constraint pk_sbdgstr_cuistr primary key (sbdg_rxcui, RXN_AVAILABLE_STRENGTH),
  constraint fk_sbdgstr_sbdg foreign key (sbdg_rxcui) references sbdg
);

create table et (
  rxcui varchar(12) not null,
  rxaui varchar(12) not null,
  name varchar(2000) not null,
  constraint pk_doseentrtrm_cuiname primary key (rxcui, name)
);

create table scd_sy (
  drug_rxcui varchar(12) not null,
  drug_rxaui varchar(12) not null,
  synonym varchar(2000) not null,
  sy_rxaui varchar(12) not null,
  constraint pk_scdsy_cuisy primary key (drug_rxcui, synonym),
  constraint fk_scdsy_scd foreign key (drug_rxcui) references scd
);
create index ix_scdsy_sy on scd_sy(synonym);

create table sbd_sy (
  drug_rxcui varchar(12) not null,
  drug_rxaui varchar(12) not null,
  synonym varchar(2000) not null,
  sy_rxaui varchar(12) not null,
  constraint pk_sbdsy_cuisy primary key (drug_rxcui, synonym),
  constraint fk_sbdsy_sbd foreign key (drug_rxcui) references sbd
);

create table mthspl_prod_scd (
  prod_rxaui varchar(12) not null,
  scd_rxcui varchar(12) not null,
  constraint pk_mthsplprodscd_aui primary key (prod_rxaui),
  constraint fk_mthsplprodscd_cui foreign key (scd_rxcui) references scd,
  constraint fk_mthsplprodscd_prod foreign key (prod_rxaui) references mthspl_prod
);

create table mthspl_prod_sbd (
  prod_rxaui varchar(12) not null,
  sbd_rxcui varchar(12) not null,
  constraint pk_mthsplprodsbd_aui primary key (prod_rxaui),
  constraint fk_mthsplprodsbd_sbd foreign key (sbd_rxcui) references sbd,
  constraint fk_mthsplprodsbd_prod foreign key (prod_rxaui) references mthspl_prod
);

create table sbd_scd (
  rxcui1 varchar(12) not null,
  rxcui2 varchar(12) not null,
  constraint pk_brndrgscd_cui12 primary key (rxcui1, rxcui2),
  constraint fk_sbdscd_sbd foreign key (rxcui1) references sbd,
  constraint fk_sbdscd_scd foreign key (rxcui2) references scd
)
;

create table scdc_sbd (
  scdc_rxcui varchar(12) not null,
  sbd_rxcui varchar(12) not null,
  constraint pk_scdcsbd_cui primary key (scdc_rxcui, sbd_rxcui),
  constraint fk_scdcsbd_scdc foreign key (scdc_rxcui) references scdc,
  constraint fk_scdcsbd_sbd foreign key (sbd_rxcui) references sbd
);

create table scdc_scd (
  scdc_rxcui varchar(12) not null,
  scd_rxcui varchar(12) not null,
  constraint pk_scdcscd_cui primary key (scdc_rxcui, scd_rxcui),
  constraint fk_scdcscd_scdc foreign key (scdc_rxcui) references scdc,
  constraint fk_scdcscd_scd foreign key (scd_rxcui) references scd
);

create table scdc_sbdc (
  scdc_rxcui varchar(12) not null,
  sbdc_rxcui varchar(12) not null,
  constraint pk_scdcsbdc_cui primary key (scdc_rxcui, sbdc_rxcui),
  constraint fk_scdcsbdc_scdc foreign key (scdc_rxcui) references scdc,
  constraint fk_scdcsbdc_sbdc foreign key (sbdc_rxcui) references sbdc
);

create table scdf_ingr (
  scdf_rxcui varchar(12) not null,
  ingr_rxcui varchar(12) not null,
  constraint pk_scdfingr_cui primary key (scdf_rxcui, ingr_rxcui),
  constraint fk_scdfingr_scdf foreign key (scdf_rxcui) references scdf,
  constraint fk_scdfingr_ingr foreign key (ingr_rxcui) references ingr
);

create table scdf_df (
  scdf_rxcui varchar(12) primary key,
  df_rxcui varchar(12) not null,
  constraint fk_scdfdf_df foreign key (df_rxcui) references df,
  constraint fk_scdfdf_scdf foreign key (scdf_rxcui) references scdf
);

create table scdf_scd (
  scdf_rxcui varchar(12) not null,
  scd_rxcui varchar(12) not null,
  constraint pk_scdfscd_cui primary key (scdf_rxcui, scd_rxcui),
  constraint fk_scdfscd_scdf foreign key (scdf_rxcui) references scdf,
  constraint fk_scdfscd_scd foreign key (scd_rxcui) references scd
);

create table scdf_scdg (
  scdf_rxcui varchar(12) not null,
  scdg_rxcui varchar(12) not null,
  constraint pk_scdfscdg_cui primary key (scdf_rxcui, scdg_rxcui),
  constraint fk_scdfscdg_scdf foreign key (scdf_rxcui) references scdf,
  constraint fk_scdfscdg_scdg foreign key (scdg_rxcui) references scdg
);

create table scdf_sbdf (
  scdf_rxcui varchar(12) not null,
  sbdf_rxcui varchar(12) not null,
  constraint pk_scdfsbdf_cui primary key (scdf_rxcui, sbdf_rxcui),
  constraint fk_scdfsbdf_scdf foreign key (scdf_rxcui) references scdf,
  constraint fk_scdfsbdf_sbdf foreign key (sbdf_rxcui) references sbdf
);

create table scdg_ingr (
  scdg_rxcui varchar(12) not null,
  ingr_rxcui varchar(12) not null,
  constraint pk_scdgingr_cui primary key (scdg_rxcui, ingr_rxcui),
  constraint fk_scdgingr_scdg foreign key (scdg_rxcui) references scdg,
  constraint fk_scdgingr_ingr foreign key (ingr_rxcui) references ingr
);

create table scdg_dfg (
  scdg_rxcui varchar(12) primary key,
  dfg_rxcui varchar(12) not null,
  constraint fk_scdgdfg_scdg foreign key (scdg_rxcui) references scdg,
  constraint fk_scdgdfg_dfg foreign key (dfg_rxcui) references dfg
);

create table scdg_scd (
  scdg_rxcui varchar(12) not null,
  scd_rxcui varchar(12) not null,
  constraint pk_scdgscd_cui primary key (scdg_rxcui, scd_rxcui),
  constraint fk_scdgscd_scdg foreign key (scdg_rxcui) references scdg,
  constraint fk_scdgscd_scd foreign key (scd_rxcui) references scd
);

create table scdg_sbdg (
  scdg_rxcui varchar(12) not null,
  sbdg_rxcui varchar(12) not null,
  constraint pk_scdgsbdg_cui primary key (scdg_rxcui, sbdg_rxcui),
  constraint fk_scdgsbdg_scdg foreign key (scdg_rxcui) references scdg,
  constraint fk_scdgsbdg_scd foreign key (sbdg_rxcui) references sbdg
);

/* not needed currently, kept to look for anomalies
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

create table gpck_bpck (
  gpck_rxcui varchar(12) not null,
  bpck_rxcui varchar(12) not null,
  constraint pk_gpckbpck_cui primary key (gpck_rxcui, bpck_rxcui),
  constraint fk_gpckbpck_gpck foreign key (gpck_rxcui) references gpck,
  constraint fk_gpckbpck_bpck foreign key (bpck_rxcui) references bpck
);

create table gpck_scd (
  gpck_rxcui varchar(12) not null,
  scd_rxcui varchar(12) not null,
  constraint pk_gpckscd_cui primary key (gpck_rxcui, scd_rxcui),
  constraint fk_gpckscd_gpck foreign key (gpck_rxcui) references gpck,
  constraint fk_gpckscd_scd foreign key (scd_rxcui) references scd
);

create table bpck_scd (
  bpck_rxcui varchar(12) not null,
  scd_rxcui varchar(12) not null,
  constraint pk_bpckscd_cui primary key (bpck_rxcui, scd_rxcui),
  constraint fk_bpckscd_bpck foreign key (bpck_rxcui) references bpck,
  constraint fk_bpckscd_scd foreign key (scd_rxcui) references scd
);

create table bpck_sbd (
  bpck_rxcui varchar(12) not null,
  sbd_rxcui varchar(12) not null,
  constraint pk_bpcksbd_cui primary key (bpck_rxcui, sbd_rxcui),
  constraint fk_bpcksbd_bpck foreign key (bpck_rxcui) references bpck,
  constraint fk_bpcksbd_sbd foreign key (sbd_rxcui) references sbd
);

create table sbd_bn (
  sbd_rxcui varchar(12) not null,
  brand_rxcui varchar(12) not null,
  constraint pk_sbdbn_cui primary key (sbd_rxcui, brand_rxcui),
  constraint fk_sbdbn_sbd foreign key (sbd_rxcui) references sbd,
  constraint fk_sbdbn_bn foreign key (brand_rxcui) references bn
);

create table sbdc_sbd (
  sbdc_rxcui varchar(12) not null,
  sbd_rxcui varchar(12) not null,
  constraint pk_sbdcsbc_cui primary key (sbdc_rxcui, sbd_rxcui),
  constraint fk_sbdcsbd_sbdc foreign key (sbdc_rxcui) references sbdc,
  constraint fk_sbdcsbd_sbd foreign key (sbd_rxcui) references sbd
);

create table sbdc_bn (
  sbdc_rxcui varchar(12) not null,
  brand_rxcui varchar(12) not null,
  constraint pk_sbdcbn_cui primary key (sbdc_rxcui, brand_rxcui),
  constraint fk_sbdcbn_sbdc foreign key (sbdc_rxcui) references sbdc,
  constraint fk_sbdcbn_bn foreign key (brand_rxcui) references bn
);

create table sbdf_sbdg (
  sbdf_rxcui varchar(12) not null,
  sbdg_rxcui varchar(12) not null,
  constraint pk_sbdfsbdg_cui primary key (sbdf_rxcui, sbdg_rxcui),
  constraint fk_sbdfsbdg_sbdf foreign key (sbdf_rxcui) references sbdf,
  constraint fk_sbdfsbdg_sbdg foreign key (sbdg_rxcui) references sbdg
);

create table sbdf_bn (
  sbdf_rxcui varchar(12) not null,
  brand_rxcui varchar(12) not null,
  constraint pk_sbdfbn_cui primary key (sbdf_rxcui, brand_rxcui),
  constraint fk_sbdfbn_sbdf foreign key (sbdf_rxcui) references sbdf,
  constraint fk_sbdfbn_bn foreign key (brand_rxcui) references bn
);

create table sbdf_sbd (
  sbdf_rxcui varchar(12) not null,
  sbd_rxcui varchar(12) not null,
  constraint pk_sbdfsbd_cui primary key (sbdf_rxcui, sbd_rxcui),
  constraint fk_sbdfsbd_sbdf foreign key (sbdf_rxcui) references sbdf,
  constraint fk_sbdfsbd_sbd foreign key (sbd_rxcui) references sbd
);

create table sbdg_bn (
  sbdg_rxcui varchar(12) primary key,
  brand_rxcui varchar(12) not null,
  constraint fk_sbdgbn_sbdg foreign key (sbdg_rxcui) references sbdg,
  constraint fk_sbdgbn_bn foreign key (brand_rxcui) references bn
);

create table sbdg_sbd (
  sbdg_rxcui varchar(12) not null,
  sbd_rxcui varchar(12) not null,
  constraint pk_sbdgsbd_cui primary key (sbdg_rxcui, sbd_rxcui),
  constraint fk_sbdgsbd_sbdg foreign key (sbdg_rxcui) references sbdg,
  constraint fk_sbdgsbd_sbd foreign key (sbd_rxcui) references sbd
);

create table bn_ingr (
  brand_rxcui varchar(12) not null,
  ingr_rxcui varchar(12) not null,
  constraint pk_bningr_cui primary key (brand_rxcui, ingr_rxcui),
  constraint fk_bningr_bn foreign key (brand_rxcui) references bn,
  constraint fk_bringr_ingr foreign key (ingr_rxcui) references ingr
);

create table bn_pin (
  brand_rxcui varchar(12) not null,
  pin_rxcui varchar(12) not null,
  constraint pk_bnpin_cui primary key (brand_rxcui, pin_rxcui),
  constraint fk_bnpin_bn foreign key (brand_rxcui) references bn,
  constraint fk_brpin_pin foreign key (pin_rxcui) references pin
);

------------------------------------ATC SECTION----------------------------------
create table atc_drug_class (
  rxcui varchar(12) not null,
  rxaui varchar(12) not null,
  atc_code varchar(12) not null,
  drug_class varchar(3000) not null,
  drug_class_level varchar(2) not null,
  constraint pk_atcdrugcls_auiclass primary key (rxaui, drug_class)
);
----------------------------------------------VIEWS--------------------------------------------
create or replace view drug_v as
select
  d.rxcui,
  d.rxaui,
  d.tty,
  d.str as name,
  (select psn.str from rxnconso psn where psn.tty = 'PSN' and psn.rxcui = d.rxcui) prescribable_name,
  d.suppress,
  case when exists(
    select 1 from rxnrel rel
    where rel.rela = 'has_quantified_form' and rel.rxcui1 = d.rxcui
    ) then 'Y'
    when exists(select 1 from rxnrel rel
    where rel.rela = 'quantified_form_of' and rel.rxcui1 = d.rxcui
    ) then 'N'
    end quantified
from rxnconso d
where d.sab='RXNORM' and d.tty in ('SBD','SCD')
;

create or replace view ingredient_v as
select
  c.rxcui,
  c.rxaui,
  c.tty,
  c.str as name,
  c.suppress
from rxnconso c
where sab='RXNORM' and tty in ('PIN','IN','MIN')
;

create or replace view mthspl_prod_sub_v as
select
  mp.rxaui          prod_rxaui,
  mp.rxcui          prod_rxcui,
  mp.code           prod_code,
  mp.rxnorm_created prod_rxnorm_created,
  mp.name           prod_name,
  mp.suppress       prod_suppress,
  mp.ambiguity_flag prod_ambiguity_flag,
  ps.ingr_type,
  ps.sub_rxaui      sub_rxaui,
  ms.rxcui          sub_rxcui,
  ms.unii           sub_unii,
  ms.biologic_code  sub_biologic_code,
  ms.name           sub_name,
  ms.suppress       sub_suppress
from mthspl_prod_sub ps
join mthspl_prod mp on ps.prod_rxaui = mp.rxaui
join mthspl_sub ms on ms.rxaui = ps.sub_rxaui
;

--------------------------------FUNCTIONS---------------------------------
create or replace function drug_name(p_rxcui varchar) returns varchar as $$
    select d.name from drug_v d where d.rxcui = p_rxcui;
$$ language sql;

create or replace function uniis_str(p_prod_rxaui varchar) returns varchar as $$
  select string_agg(distinct psv.sub_unii, '|' order by psv.sub_unii)
  from mthspl_prod_sub_v psv where psv.prod_rxaui = p_prod_rxaui
  and psv.ingr_type <> 'I'
$$ language sql;
------------------------------------------------------------------

create or replace view mthspl_prod_v as
select
  p.rxaui,
  p.rxcui,
  p.code,
  p.rxnorm_created,
  p.name,
  p.suppress,
  p.ambiguity_flag,
  (select coalesce(jsonb_agg(distinct spl_set_id), '[]'::jsonb) from mthspl_prod_setid mps where mps.prod_rxaui = p.rxaui) set_ids,
  (select coalesce(jsonb_agg(distinct label_type), '[]'::jsonb) from mthspl_prod_labeltype where prod_rxaui = p.rxaui) label_types,
  (select coalesce(jsonb_agg(distinct labeler), '[]'::jsonb) from mthspl_prod_labeler where prod_rxaui = p.rxaui) labelers,
  (select coalesce(jsonb_agg(distinct mkt_cat), '[]'::jsonb) from mthspl_prod_mktcat where prod_rxaui = p.rxaui) mkt_cats,
  (select coalesce(jsonb_agg(distinct code), '[]'::jsonb) from mthspl_prod_mktcat_code where prod_rxaui = p.rxaui) mkt_cat_codes,
  (select coalesce(jsonb_agg(distinct full_ndc), '[]'::jsonb) from mthspl_prod_ndc where prod_rxaui = p.rxaui) full_ndc_codes,
  (select coalesce(jsonb_agg(distinct two_part_ndc), '[]'::jsonb) from mthspl_prod_ndc where prod_rxaui = p.rxaui) short_ndc_codes,
  (select
    coalesce(jsonb_agg(jsonb_build_object(
      'ingrType', ingr_type,
      'rxaui', sub_rxaui,
      'rxcui', sub_rxcui,
      'unii', sub_unii,
      'biologicCode', sub_biologic_code,
      'name', sub_name,
      'suppress', sub_suppress)), '[]'::jsonb)
   from mthspl_prod_sub_v
   where p.rxaui = prod_rxaui) substances
from mthspl_prod p
;

create or replace view mthspl_rxprod_v as
select p.*
from mthspl_prod_v p
where p.rxaui in (
    select mpl.prod_rxaui
    from mthspl_prod_labeltype mpl
    where mpl.label_type = 'HUMAN PRESCRIPTION DRUG LABEL' or mpl.label_type = 'HUMAN PRESCRIPTION DRUG LABEL WITH HIGHLIGHTS'
)
;

--view that generalizes rxcuis from drug
create or replace view drug_generalized_v as
select
  d.rxcui rxcui,
  (
    select rxcui1
    from rxnrel rel
    where rel.rela = 'quantified_form_of'
    and rel.rxcui2 = d.rxcui
  ) non_quantified_rxcui,
  case when d.tty = 'SCD'
    then d.rxcui
    else (
      select dtd.rxcui2
      from sbd_scd dtd
      where dtd.rxcui1 = d.rxcui
    )
  end generic_rxcui,
  case when d.tty = 'SCD'
    then (
      select rxcui1
      from rxnrel rel
      where rel.rela = 'quantified_form_of'
      and rel.rxcui2 = d.rxcui
    )
    else (
        select rxcui1
        from rxnrel rel
        where rel.rela = 'quantified_form_of'
        and rel.rxcui2 in (
          select dtd.rxcui2
         from sbd_scd dtd
         where dtd.rxcui1 = d.rxcui
       )
    )
  end generic_unquantified_rxcui
from drug_v d
;

create materialized view drug_generalized_mv as
  select * from drug_generalized_v;

create unique index ix_druggeneral_rxcui on drug_generalized_mv(rxcui);


create or replace view mthspl_mktcode_prod_drug_v as
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
left join drug_v d on d.rxcui = p.rxcui
left join drug_generalized_mv dgm on d.rxcui = dgm.rxcui
group by pmcc.code, pmcc.mkt_cat
;

create or replace view mthspl_mktcode_rxprod_drug_v as
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
left join drug_v d on d.rxcui = p.rxcui
left join drug_generalized_mv dgm on d.rxcui = dgm.rxcui
where p.rxaui in (
    select mpl.prod_rxaui
    from mthspl_prod_labeltype mpl
    where mpl.label_type = 'HUMAN PRESCRIPTION DRUG LABEL' or mpl.label_type = 'HUMAN PRESCRIPTION DRUG LABEL WITH HIGHLIGHTS'
)
group by pmcc.code, pmcc.mkt_cat
;

create or replace view mthspl_prod_setid_v as
select
  ps.spl_set_id                                                 set_id,
  coalesce(jsonb_agg(distinct ps.prod_rxaui), '[]'::jsonb)      prod_atom_id,
  coalesce(jsonb_agg(distinct p.name), '[]'::jsonb)             product_name,
  coalesce(jsonb_agg(distinct p.code), '[]'::jsonb)             product_code,
  (select
     coalesce(jsonb_agg(distinct label_type), '[]'::jsonb)
   from mthspl_prod_labeltype plt
   where plt.prod_rxaui in (
     select psi.prod_rxaui
     from mthspl_prod_setid psi
     where psi.spl_set_id = ps.spl_set_id
   ))                                                           label_types,
  (select
     coalesce(jsonb_agg(distinct labeler), '[]'::jsonb)
   from mthspl_prod_labeler pl
   where pl.prod_rxaui in (
     select psi.prod_rxaui
     from mthspl_prod_setid psi
     where psi.spl_set_id = ps.spl_set_id
   ))                                                           labelers,
  (select
     coalesce(jsonb_agg(distinct code), '[]'::jsonb)
   from mthspl_prod_mktcat_code pmcc
   where pmcc.prod_rxaui in (
     select psi.prod_rxaui
     from mthspl_prod_setid psi
     where psi.spl_set_id = ps.spl_set_id
   ))                                                           application_codes,
  (select
     coalesce(jsonb_agg(distinct mkt_cat), '[]'::jsonb)
   from mthspl_prod_mktcat pmc
   where pmc.prod_rxaui in (
     select psi.prod_rxaui
     from mthspl_prod_setid psi
     where psi.spl_set_id = ps.spl_set_id
   ))                                                           market_categories,
  coalesce(jsonb_agg(distinct uniis_str(ps.prod_rxaui)), '[]'::jsonb) prod_uniis,
  (select
     coalesce(jsonb_agg(distinct jsonb_build_object(
       'ingrType', s.ingr_type,
       'rxaui', s.sub_rxaui,
       'rxcui', s.sub_rxcui,
       'unii', s.sub_unii,
       'biologicCode', s.sub_biologic_code,
       'name', s.sub_name,
       'suppress', s.sub_suppress)), '[]'::jsonb)
   from mthspl_prod_sub_v s
   where s.prod_rxaui in (
     select psi.prod_rxaui
     from mthspl_prod_setid psi
     where psi.spl_set_id = ps.spl_set_id
   ))                                                           product_substances,
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
from mthspl_prod_setid ps
join mthspl_prod p on p.rxaui = ps.prod_rxaui
left join drug_v d on d.rxcui = p.rxcui
left join drug_generalized_mv dgm on d.rxcui = dgm.rxcui
group by ps.spl_set_id
;

create or replace view mthspl_rxprod_setid_drug_v as
select
  ps.spl_set_id                                                 set_id,
  coalesce(jsonb_agg(distinct ps.prod_rxaui), '[]'::jsonb)      prod_atom_id,
  coalesce(jsonb_agg(distinct p.name), '[]'::jsonb)             product_name,
  coalesce(jsonb_agg(distinct p.code), '[]'::jsonb)             product_code,
  (select
     coalesce(jsonb_agg(distinct label_type), '[]'::jsonb)
   from mthspl_prod_labeltype plt
   where plt.prod_rxaui in (
     select psi.prod_rxaui
     from mthspl_prod_setid psi
     where psi.spl_set_id = ps.spl_set_id
   ))                                                           label_types,
  (select
     coalesce(jsonb_agg(distinct labeler), '[]'::jsonb)
   from mthspl_prod_labeler pl
   where pl.prod_rxaui in (
     select psi.prod_rxaui
     from mthspl_prod_setid psi
     where psi.spl_set_id = ps.spl_set_id
   ))                                                           labelers,
  (select
     coalesce(jsonb_agg(distinct code), '[]'::jsonb)
   from mthspl_prod_mktcat_code pmcc
   where pmcc.prod_rxaui in (
     select psi.prod_rxaui
     from mthspl_prod_setid psi
     where psi.spl_set_id = ps.spl_set_id
   ))                                                           application_codes,
  (select
     coalesce(jsonb_agg(distinct mkt_cat), '[]'::jsonb)
   from mthspl_prod_mktcat pmc
   where pmc.prod_rxaui in (
     select psi.prod_rxaui
     from mthspl_prod_setid psi
     where psi.spl_set_id = ps.spl_set_id
   ))                                                           market_categories,
  coalesce(jsonb_agg(distinct uniis_str(ps.prod_rxaui)), '[]'::jsonb) prod_uniis,
  (select
     coalesce(jsonb_agg(distinct jsonb_build_object(
       'ingrType', s.ingr_type,
       'rxaui', s.sub_rxaui,
       'rxcui', s.sub_rxcui,
       'unii', s.sub_unii,
       'biologicCode', s.sub_biologic_code,
       'name', s.sub_name,
       'suppress', s.sub_suppress)), '[]'::jsonb)
   from mthspl_prod_sub_v s
   where s.prod_rxaui in (
     select psi.prod_rxaui
     from mthspl_prod_setid psi
     where psi.spl_set_id = ps.spl_set_id
   ))                                                           product_substances,
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
from mthspl_prod_setid ps
join mthspl_prod p on p.rxaui = ps.prod_rxaui
left join drug_v d on d.rxcui = p.rxcui
left join drug_generalized_mv dgm on d.rxcui = dgm.rxcui
where p.rxaui in (
    select mpl.prod_rxaui
    from mthspl_prod_labeltype mpl
    where mpl.label_type = 'HUMAN PRESCRIPTION DRUG LABEL' or mpl.label_type = 'HUMAN PRESCRIPTION DRUG LABEL WITH HIGHLIGHTS'
)
group by ps.spl_set_id
;

--created view that joins ndc to prod, and takes information from drug, 168,872
create or replace view mthspl_ndc_prod_drug_v as
select
  pn.two_part_ndc                                               short_ndc,
  coalesce(jsonb_agg(distinct pn.full_ndc), '[]'::jsonb)        full_ndcs,
  coalesce(jsonb_agg(distinct p.name), '[]'::jsonb)             product_name,
  coalesce(jsonb_agg(distinct p.code), '[]'::jsonb)             product_code,
  (select coalesce(jsonb_agg(distinct spl_set_id), '[]'::jsonb)
   from mthspl_prod_setid ps
   where ps.prod_rxaui in (
     select pnc.prod_rxaui
     from mthspl_prod_ndc pnc
     where pnc.two_part_ndc = pn.two_part_ndc
   ))                                                           set_ids,
  (select coalesce(jsonb_agg(distinct label_type), '[]'::jsonb)
   from mthspl_prod_labeltype plt
   where plt.prod_rxaui in (
     select pnc.prod_rxaui
     from mthspl_prod_ndc pnc
     where pnc.two_part_ndc = pn.two_part_ndc
   ))                                                           label_types,
  (select coalesce(jsonb_agg(distinct labeler), '[]'::jsonb)
   from mthspl_prod_labeler pl
   where pl.prod_rxaui in (
     select pnc.prod_rxaui
     from mthspl_prod_ndc pnc
     where pnc.two_part_ndc = pn.two_part_ndc
   ))                                                           labelers,
  (select coalesce(jsonb_agg(distinct code), '[]'::jsonb)
   from mthspl_prod_mktcat_code pmcc
   where pmcc.prod_rxaui in (
     select pnc.prod_rxaui
     from mthspl_prod_ndc pnc
     where pnc.two_part_ndc = pn.two_part_ndc
   ))                                                           application_codes,
  (select coalesce(jsonb_agg(distinct mkt_cat), '[]'::jsonb)
   from mthspl_prod_mktcat pmc
   where pmc.prod_rxaui in (
     select pnc.prod_rxaui
     from mthspl_prod_ndc pnc
     where pnc.two_part_ndc = pn.two_part_ndc
   ))                                                           market_categories,
  coalesce(jsonb_agg(distinct uniis_str(pn.prod_rxaui)), '[]'::jsonb) prod_uniis,
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
     select pnc.prod_rxaui
     from mthspl_prod_ndc pnc
     where pnc.two_part_ndc = pn.two_part_ndc
   ))                                                           product_substances,
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
from mthspl_prod_ndc pn
join mthspl_prod p on p.rxaui = pn.prod_rxaui
left join drug_v d on d.rxcui = p.rxcui
left join drug_generalized_mv dgm on d.rxcui = dgm.rxcui
group by pn.two_part_ndc
;

--66,816 distinct rx short ndc
create or replace view mthspl_ndc_rxprod_drug_v as
select
  pn.two_part_ndc                                               short_ndc,
  coalesce(jsonb_agg(distinct pn.full_ndc), '[]'::jsonb)        full_ndcs,
  coalesce(jsonb_agg(distinct p.name), '[]'::jsonb)             product_name,
  coalesce(jsonb_agg(distinct p.code), '[]'::jsonb)             product_code,
  (select coalesce(jsonb_agg(distinct spl_set_id), '[]'::jsonb)
   from mthspl_prod_setid ps
   where ps.prod_rxaui in (
     select pnc.prod_rxaui
     from mthspl_prod_ndc pnc
     where pnc.two_part_ndc = pn.two_part_ndc
   ))                                                           set_ids,
  (select coalesce(jsonb_agg(distinct label_type), '[]'::jsonb)
   from mthspl_prod_labeltype plt
   where plt.prod_rxaui in (
     select pnc.prod_rxaui
     from mthspl_prod_ndc pnc
     where pnc.two_part_ndc = pn.two_part_ndc
   ))                                                           label_types,
  (select coalesce(jsonb_agg(distinct labeler), '[]'::jsonb)
   from mthspl_prod_labeler pl
   where pl.prod_rxaui in (
     select pnc.prod_rxaui
     from mthspl_prod_ndc pnc
     where pnc.two_part_ndc = pn.two_part_ndc
   ))                                                           labelers,
  (select coalesce(jsonb_agg(distinct code), '[]'::jsonb)
   from mthspl_prod_mktcat_code pmcc
   where pmcc.prod_rxaui in (
     select pnc.prod_rxaui
     from mthspl_prod_ndc pnc
     where pnc.two_part_ndc = pn.two_part_ndc
   ))                                                           application_codes,
  (select coalesce(jsonb_agg(distinct mkt_cat), '[]'::jsonb)
   from mthspl_prod_mktcat pmc
   where pmc.prod_rxaui in (
     select pnc.prod_rxaui
     from mthspl_prod_ndc pnc
     where pnc.two_part_ndc = pn.two_part_ndc
   ))                                                           market_categories,
  coalesce(jsonb_agg(distinct uniis_str(pn.prod_rxaui)), '[]'::jsonb) prod_uniis,
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
     select pnc.prod_rxaui
     from mthspl_prod_ndc pnc
     where pnc.two_part_ndc = pn.two_part_ndc
   ))                                                           product_substances,
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
from mthspl_prod_ndc pn
join mthspl_prod p on p.rxaui = pn.prod_rxaui
left join drug_v d on d.rxcui = p.rxcui
left join drug_generalized_mv dgm on d.rxcui = dgm.rxcui
where p.rxaui in (
    select mpl.prod_rxaui
    from mthspl_prod_labeltype mpl
    where mpl.label_type = 'HUMAN PRESCRIPTION DRUG LABEL' or mpl.label_type = 'HUMAN PRESCRIPTION DRUG LABEL WITH HIGHLIGHTS'
)
group by pn.two_part_ndc
;

create or replace view scd_unii_v as --62,476
  select scd.rxcui as scd_rxcui, iu.unii as unii
  from scdc_scd
  join scd on scdc_scd.scd_rxcui = scd.rxcui
  join scdc on scdc_scd.scdc_rxcui = scdc.rxcui
  join ingr i on i.rxcui = scdc.ingr_rxcui
  join ingr_unii iu on iu.ingr_rxcui = i.rxcui
  union
  select scd.rxcui as scd_rxcui, piu.unii as unii
  from scdc_scd
  join scd on scdc_scd.scd_rxcui = scd.rxcui
  join scdc on scdc_scd.scdc_rxcui = scdc.rxcui
  join pin i on i.rxcui = scdc.pin_rxcui
  join pin_unii piu on piu.pin_rxcui = i.rxcui
;