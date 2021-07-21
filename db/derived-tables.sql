create table mthspl_sub (
  rxaui varchar(12) not null primary key,
  rxcui varchar(12) not null,
  unii varchar(10),
  biologic_code varchar(18),
  name varchar(2000) not null,
  suppress varchar(1) not null,
  constraint mthspl_sub_notuniiandbiocode_ck check (unii is null or biologic_code is null)
);
create index ix_mthsplsub_cui on mthspl_sub(rxcui);
create index ix_mthsplsub_unii on mthspl_sub(unii);
create index ix_mthsplsub_code on mthspl_sub(biologic_code);

create table mthspl_prod (
  rxaui varchar(12) not null primary key,
  rxcui varchar(12) not null,
  code varchar(13), -- Most of these are NDCs without packaging (3rd part), some are not NDCs at all.
  rxnorm_created boolean not null,
  name varchar(4000) not null,
  suppress varchar(1) not null,
  ambiguity_flag varchar(9)
);
create index ix_mthsplprod_cui on mthspl_prod(rxcui);
create index ix_mthsplprod_code on mthspl_prod(code);

create table mthspl_sub_setid (
  sub_rxaui varchar(12) not null references mthspl_sub,
  set_id varchar(46) not null,
  suppress varchar(1) not null,
  primary key (sub_rxaui, set_id)
);
create index ix_mthsplsubsetid_setid on mthspl_sub_setid(set_id);

create table mthspl_ingr_type (
  ingr_type varchar(1) not null primary key,
  description varchar(1000) not null
);

create table mthspl_prod_sub (
  prod_rxaui varchar(12) not null references mthspl_prod,
  ingr_type varchar(1) not null references mthspl_ingr_type,
  sub_rxaui varchar(12) not null references mthspl_sub,
  primary key (prod_rxaui, ingr_type, sub_rxaui)
);
create index ix_mthsplprodsub_ingrtype on mthspl_prod_sub(ingr_type);
create index ix_mthsplprodsub_subaui on mthspl_prod_sub(sub_rxaui);

create table mthspl_prod_dmspl (
  prod_rxaui varchar(12) not null references mthspl_prod,
  dm_spl_id varchar(46) not null,
  primary key (prod_rxaui, dm_spl_id)
);
create index ix_mthspl_proddmspl_dmsplid on mthspl_prod_dmspl(dm_spl_id);

create table mthspl_prod_setid (
  prod_rxaui varchar(12) not null references mthspl_prod,
  spl_set_id varchar(46) not null,
  primary key (prod_rxaui, spl_set_id)
);
create index ix_mthsplprodsetid_setid on mthspl_prod_setid(spl_set_id);

create table mthspl_prod_ndc (
  prod_rxaui varchar(12) not null references mthspl_prod,
  full_ndc varchar(12) not null,
  two_part_ndc varchar(12) not null,
  primary key (prod_rxaui, full_ndc)
);
create index ix_mthsplprodndc_fullndc on mthspl_prod_ndc(full_ndc);
create index ix_mthsplprodndc_twopartndc on mthspl_prod_ndc(two_part_ndc);

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
create index ix_mthsplprodlblt_lblt on mthspl_prod_labeltype(label_type);

create table mthspl_prod_mktstat (
  prod_rxaui varchar(12) not null references mthspl_prod,
  mkt_stat varchar(500) not null,
  primary key (prod_rxaui, mkt_stat)
);
create index ix_mthsplprodmktstat_mktstat on mthspl_prod_mktstat(mkt_stat);

create table mthspl_prod_mkteffth (
  prod_rxaui varchar(12) not null references mthspl_prod,
  mkt_eff_time_high varchar(8) not null,
  primary key (prod_rxaui, mkt_eff_time_high)
);
create index ix_mthsplprodmkteffth_mkteffth on mthspl_prod_mkteffth(mkt_eff_time_high);

create table mthspl_prod_mktefftl (
  prod_rxaui varchar(12) not null references mthspl_prod,
  mkt_eff_time_low varchar(8) not null,
  primary key (prod_rxaui, mkt_eff_time_low)
);
create index ix_mthsplprodmktefftl_mktetl on mthspl_prod_mktefftl(mkt_eff_time_low);

create table mthspl_mktcat (
  name varchar(500) primary key
);

create table mthspl_prod_mktcat (
  prod_rxaui varchar(12) not null references mthspl_prod,
  mkt_cat varchar(500) not null references mthspl_mktcat,
  primary key (prod_rxaui, mkt_cat)
);
create index ix_mthsplprodmktcat_mktcat on mthspl_prod_mktcat(mkt_cat);

create table mthspl_prod_mktcat_code (
  prod_rxaui varchar(12) not null references mthspl_prod,
  mkt_cat varchar(500) not null references mthspl_mktcat,
  code varchar(20) not null,
  num varchar(9) not null,
  primary key (prod_rxaui, mkt_cat, code)
);
create index ix_mthsplprodmktcatcode_mktcat on mthspl_prod_mktcat_code(mkt_cat);
create index ix_mthsplprodmktcatcode_code on mthspl_prod_mktcat_code(code);
create index ix_mthsplprodmktcatcode_num on mthspl_prod_mktcat_code(num);

create table mthspl_pillattr (
  attr varchar(500) primary key
);

create table mthspl_prod_pillattr (
  prod_rxaui varchar(12) not null references mthspl_prod,
  attr varchar(500) not null references mthspl_pillattr,
  attr_val varchar(1000) not null,
  primary key (prod_rxaui, attr, attr_val)
);
create index ix_mthsplprodpillattr_attr on mthspl_prod_pillattr(attr);
create index ix_mthsplprodpillattr_attrval on mthspl_prod_pillattr(attr_val);

create table mthspl_prod_dcsa (
  prod_rxaui varchar(12) not null references mthspl_prod,
  dcsa varchar(4) not null,
  primary key (prod_rxaui, dcsa)
);
create index ix_mthsplproddcsa_dcsa on mthspl_prod_dcsa(dcsa);

create table mthspl_prod_nhric (
  prod_rxaui varchar(12) not null references mthspl_prod,
  nhric varchar(13) not null,
  primary key (prod_rxaui, nhric)
);
create index ix_mthsplproddcsa_nhric on mthspl_prod_nhric(nhric);

-- sab = RXNORM

create table "in" (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  suppress varchar(1) not null
);

create table in_unii (
  in_rxcui varchar(12) not null references "in",
  unii varchar(10) not null,
  constraint pk_inunii_cuiunii primary key (in_rxcui, unii)
);
create index ix_inunii_unii on in_unii(unii);

create table pin (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  in_rxcui varchar(12) not null references "in",
  suppress varchar(1) not null
);

create table pin_unii (
  pin_rxcui varchar(12) not null references pin,
  unii varchar(10) not null,
  constraint pk_pinunii_cuiunii primary key (pin_rxcui, unii)
);
create index ix_pinunii_unii on pin_unii(unii);

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

create table temp_scd_ingrset (
  drug_rxcui varchar(12) not null,
  ingrset_rxcui varchar(12) not null,
  ingrset_rxaui varchar(12) not null,
  ingrset_name varchar(2000) not null,
  ingrset_suppress varchar(1) not null,
  ingrset_tty varchar(100) not null,
  constraint pk_tmpscdingrset primary key (drug_rxcui, ingrset_rxcui)
);
create index ix_tempsingletoningrset on temp_scd_ingrset(ingrset_rxcui);

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
  df_rxcui varchar(12) not null references df,
  dfg_rxcui varchar(12) not null references dfg,
  constraint pk_dfdfg_cui primary key (df_rxcui, dfg_rxcui)
);

create table scd (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null unique,
  name varchar(2000) not null,
  prescribable_name varchar(2000),
  rxterm_form varchar(100),
  df_rxcui varchar(2000) not null references df,
  ingrset_rxcui varchar(12) not null references ingrset,
  avail_strengths varchar(500),
  qual_distinct varchar(500),
  suppress varchar(1) not null,
  quantity varchar(100),
  human_drug boolean,
  vet_drug boolean,
  unquantified_form_rxcui varchar(12) references scd
);
create index ix_scd_df on scd (df_rxcui);
create index ix_scd_ingrset on scd (ingrset_rxcui);
create index ix_scd_uqform on scd (unquantified_form_rxcui);

create table sbd (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null unique,
  name varchar(2000) not null,
  prescribable_name varchar(2000),
  rxterm_form varchar(100),
  df_rxcui varchar(12) not null references df,
  avail_strengths varchar(500),
  qual_distinct varchar(500),
  suppress varchar(1) not null,
  quantity varchar(100),
  human_drug boolean,
  vet_drug boolean,
  unquantified_form_rxcui varchar(12) references sbd
);

create table gpck (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null unique,
  name varchar(2000) not null,
  prescribable_name varchar(2000),
  df_rxcui varchar(12) not null references df,
  suppress varchar(1) not null,
  human_drug boolean
);

create table bpck (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null unique,
  name varchar(2000) not null,
  prescribable_name varchar(2000),
  df_rxcui varchar(12) not null references df,
  suppress varchar(1) not null,
  human_drug boolean
);


create table bn (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  rxn_cardinality varchar(6),
  reformulated_to_rxcui varchar(12) references bn
);
comment on table bn is 'brand name';

create table scdc (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  in_rxcui varchar(12) not null references "in",
  pin_rxcui varchar(12) references pin,
  boss_active_ingr_name varchar(2000),
  boss_active_moi_name varchar(2000),
  boss_source varchar(10),
  rxn_in_expressed_flag varchar(10),
  strength varchar(500),
  boss_str_num_unit varchar(100),
  boss_str_num_val varchar(100),
  boss_str_denom_unit varchar(100),
  boss_str_denom_val varchar(100)
);

create table scdf (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  df_rxcui varchar(12) not null references df
);

create table scdg (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  dfg_rxcui varchar(12) not null references dfg
);

create table scdg_astr (
  scdg_rxcui varchar(12) not null references scdg,
  rxn_available_strength varchar(2000) not null,
  constraint pk_scdgstr_cuistr primary key (scdg_rxcui, rxn_available_strength)
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
  df_rxcui varchar(12) not null references df
);

create table sbdg (
  rxcui varchar(12) primary key,
  rxaui varchar(12) not null,
  name varchar(2000) not null,
  dfg_rxcui varchar(12) not null references dfg,
  bn_rxcui varchar(12) references bn
);

create table sbdg_astr (
  sbdg_rxcui varchar(12) not null references sbdg,
  RXN_AVAILABLE_STRENGTH varchar(2000) not null,
  constraint pk_sbdgstr_cuistr primary key (sbdg_rxcui, RXN_AVAILABLE_STRENGTH)
);

create table et (
  rxcui varchar(12) not null,
  rxaui varchar(12) not null,
  name varchar(2000) not null unique,
  constraint pk_doseentrtrm_cuiname primary key (rxcui, name)
);

create table scd_sy (
  scd_rxcui varchar(12) not null references scd,
  synonym varchar(2000) not null,
  sy_rxaui varchar(12) not null,
  constraint pk_scdsy_cuisy primary key (scd_rxcui, synonym)
);
create index ix_scdsy_sy on scd_sy(synonym);

create table sbd_sy (
  sbd_rxcui varchar(12) not null references sbd,
  synonym varchar(2000) not null,
  sy_rxaui varchar(12) not null,
  constraint pk_sbdsy_cuisy primary key (sbd_rxcui, synonym)
);

create table mthspl_prod_scd (
  prod_rxaui varchar(12) not null primary key references mthspl_prod,
  scd_rxcui varchar(12) not null references scd
);

create table mthspl_prod_sbd (
  prod_rxaui varchar(12) not null primary key references mthspl_prod,
  sbd_rxcui varchar(12) not null references sbd
);

create table mthspl_sub_in (
  sub_rxaui varchar(12) not null primary key references mthspl_sub,
  in_rxcui varchar(12) not null references "in"
);

create table mthspl_sub_pin (
  sub_rxaui varchar(12) not null primary key references mthspl_sub,
  pin_rxcui varchar(12) not null references pin
);


create table sbd_scd (
  sbd_rxcui varchar(12) not null references sbd,
  scd_rxcui varchar(12) not null references scd,
  constraint pk_brndrgscd_cui12 primary key (sbd_rxcui, scd_rxcui)
)
;
create index ix_sbdscd_scd on sbd_scd(scd_rxcui);

create table scdc_sbd (
  scdc_rxcui varchar(12) not null references scdc,
  sbd_rxcui varchar(12) not null references sbd,
  constraint pk_scdcsbd_cui primary key (scdc_rxcui, sbd_rxcui)
);

create table scdc_scd (
  scdc_rxcui varchar(12) not null references scdc,
  scd_rxcui varchar(12) not null references scd,
  constraint pk_scdcscd_cui primary key (scdc_rxcui, scd_rxcui)
);
create index ix_scdcscd_scd on scdc_scd(scd_rxcui);

create table scdc_sbdc (
  scdc_rxcui varchar(12) not null references scdc,
  sbdc_rxcui varchar(12) not null references sbdc,
  constraint pk_scdcsbdc_cui primary key (scdc_rxcui, sbdc_rxcui)
);

create table scdf_in (
  scdf_rxcui varchar(12) not null references scdf,
  in_rxcui varchar(12) not null references "in",
  constraint pk_scdfin_cui primary key (scdf_rxcui, in_rxcui)
);

create table scdf_scd (
  scdf_rxcui varchar(12) not null references scdf,
  scd_rxcui varchar(12) not null references scd,
  constraint pk_scdfscd_cui primary key (scdf_rxcui, scd_rxcui)
);

create table scdf_scdg (
  scdf_rxcui varchar(12) not null references scdf,
  scdg_rxcui varchar(12) not null references scdg,
  constraint pk_scdfscdg_cui primary key (scdf_rxcui, scdg_rxcui)
);

create table scdf_sbdf (
  scdf_rxcui varchar(12) not null references scdf,
  sbdf_rxcui varchar(12) not null references sbdf,
  constraint pk_scdfsbdf_cui primary key (scdf_rxcui, sbdf_rxcui)
);

create table scdg_in (
  scdg_rxcui varchar(12) not null references scdg,
  in_rxcui varchar(12) not null references "in",
  constraint pk_scdgin_cui primary key (scdg_rxcui, in_rxcui)
);

create table scdg_scd (
  scdg_rxcui varchar(12) not null references scdg,
  scd_rxcui varchar(12) not null references scd,
  constraint pk_scdgscd_cui primary key (scdg_rxcui, scd_rxcui)
);

create table scdg_sbdg (
  scdg_rxcui varchar(12) not null references scdg,
  sbdg_rxcui varchar(12) not null references sbdg,
  constraint pk_scdgsbdg_cui primary key (scdg_rxcui, sbdg_rxcui)
);

create table gpck_bpck (
  gpck_rxcui varchar(12) not null references gpck,
  bpck_rxcui varchar(12) not null references bpck,
  constraint pk_gpckbpck_cui primary key (gpck_rxcui, bpck_rxcui)
);

create table gpck_scd (
  gpck_rxcui varchar(12) not null references gpck,
  scd_rxcui varchar(12) not null references scd,
  constraint pk_gpckscd_cui primary key (gpck_rxcui, scd_rxcui)
);

create table bpck_scd (
  bpck_rxcui varchar(12) not null references bpck,
  scd_rxcui varchar(12) not null references scd,
  constraint pk_bpckscd_cui primary key (bpck_rxcui, scd_rxcui)
);

create table bpck_sbd (
  bpck_rxcui varchar(12) not null references bpck,
  sbd_rxcui varchar(12) not null references sbd,
  constraint pk_bpcksbd_cui primary key (bpck_rxcui, sbd_rxcui)
);

create table sbd_bn (
  sbd_rxcui varchar(12) not null references sbd,
  bn_rxcui varchar(12) not null references bn,
  constraint pk_sbdbn_cui primary key (sbd_rxcui, bn_rxcui)
);

create table sbdc_sbd (
  sbdc_rxcui varchar(12) not null references sbdc,
  sbd_rxcui varchar(12) not null references sbd,
  constraint pk_sbdcsbc_cui primary key (sbdc_rxcui, sbd_rxcui)
);

create table sbdc_bn (
  sbdc_rxcui varchar(12) not null references sbdc,
  bn_rxcui varchar(12) not null references bn,
  constraint pk_sbdcbn_cui primary key (sbdc_rxcui, bn_rxcui)
);

create table sbdf_sbdg (
  sbdf_rxcui varchar(12) not null references sbdf,
  sbdg_rxcui varchar(12) not null references sbdg,
  constraint pk_sbdfsbdg_cui primary key (sbdf_rxcui, sbdg_rxcui)
);

create table sbdf_bn (
  sbdf_rxcui varchar(12) not null references sbdf,
  bn_rxcui varchar(12) not null references bn,
  constraint pk_sbdfbn_cui primary key (sbdf_rxcui, bn_rxcui)
);

create table sbdf_sbd (
  sbdf_rxcui varchar(12) not null references sbdf,
  sbd_rxcui varchar(12) not null references sbd,
  constraint pk_sbdfsbd_cui primary key (sbdf_rxcui, sbd_rxcui)
);

create table sbdg_sbd (
  sbdg_rxcui varchar(12) not null references sbdg,
  sbd_rxcui varchar(12) not null references sbd,
  constraint pk_sbdgsbd_cui primary key (sbdg_rxcui, sbd_rxcui)
);

create table bn_in (
  bn_rxcui varchar(12) not null references bn,
  in_rxcui varchar(12) not null references "in",
  constraint pk_bnin_cui primary key (bn_rxcui, in_rxcui)
);

create table bn_pin (
  bn_rxcui varchar(12) not null references bn,
  pin_rxcui varchar(12) not null references pin,
  constraint pk_bnpin_cui primary key (bn_rxcui, pin_rxcui)
);

create table atc_drug_class (
  rxcui varchar(12) not null,
  rxaui varchar(12) not null,
  atc_code varchar(12) not null,
  drug_class varchar(3000) not null,
  drug_class_level varchar(2) not null,
  constraint pk_atcdrugcls_auiclass primary key (rxaui, drug_class)
);
