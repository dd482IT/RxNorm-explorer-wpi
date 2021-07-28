#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
cd "$SCRIPT_DIR"/..

echo Loading rxnconso
sed 's/|$//' rxnorm-orig/rrf/RXNCONSO.RRF |
  psql -U rxnorm -c "\copy rxnorig.rxnconso from stdin with delimiter '|' csv quote E'\b' null as ''"

echo Loading rxnsat
sed 's/|$//' rxnorm-orig/rrf/RXNSAT.RRF |
  psql -U rxnorm -c "\copy rxnorig.rxnsat from stdin with delimiter '|' csv quote E'\b' null as ''"

echo Loading rxnrel
sed 's/|$//' rxnorm-orig/rrf/RXNREL.RRF |
  psql -U rxnorm -c "\copy rxnorig.rxnrel from stdin with delimiter '|' csv quote E'\b' null as ''"

echo Loading rxndoc
sed 's/|$//' rxnorm-orig/rrf/RXNDOC.RRF |
  psql -U rxnorm -c "\copy rxnorig.rxndoc from stdin with delimiter '|' csv quote E'\b' null as ''"

echo Loading rxnsty
sed 's/|$//' rxnorm-orig/rrf/RXNSTY.RRF |
  psql -U rxnorm -c "\copy rxnorig.rxnsty from stdin with delimiter '|' csv quote E'\b' null as ''"

echo Loading rxnsab
sed 's/|$//' rxnorm-orig/rrf/RXNSAB.RRF |
  psql -U rxnorm -c "\copy rxnorig.rxnsab from stdin with delimiter '|' csv quote E'\b' null as ''"

echo Loading rxnatomarchive
sed 's/|$//' rxnorm-orig/rrf/RXNATOMARCHIVE.RRF |
  psql -U rxnorm -c "\copy rxnorig.rxnatomarchive from stdin with delimiter '|' csv quote E'\b' null as ''"

echo Loading rxncuichanges
sed 's/|$//' rxnorm-orig/rrf/RXNCUICHANGES.RRF |
  psql -U rxnorm -c "\copy rxnorig.rxncuichanges from stdin with delimiter '|' csv quote E'\b' null as ''"

echo Loading rxncui
sed 's/|$//' rxnorm-orig/rrf/RXNCUI.RRF |
  psql -U rxnorm -c "\copy rxnorig.rxncui from stdin with delimiter '|' csv quote E'\b' null as ''"
