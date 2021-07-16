#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
cd "$SCRIPT_DIR"/..
ALTER ROLE

# Create dummy tables so the table drop statements in RxNormDDL.sql (from RxNorm) won't generate errors.
psql -U rxnorm <<EOF
create table rxnatomarchive(x int);
create table rxnconso(x int);
create table rxnrel(x int);
create table rxnsab(x int);
create table rxnsat(x int);
create table rxnsty(x int);
create table rxndoc(x int);
create table rxncuichanges(x int);
create table rxncui(x int);
EOF

psql -U rxnorm -f rxnorm-orig/RxNormDDL.sql
psql -U rxnorm -f rxnorm-orig/rxn_index.sql
psql -U rxnorm -f rxn_index_extra.sql

psql -U rxnorm -f derived-schema.sql
