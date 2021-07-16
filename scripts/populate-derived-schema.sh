#!/bin/sh

SCRIPT_DIR="$(dirname "$(realpath "$0")")"
cd "$SCRIPT_DIR"/..

psql -U rxnorm -f populate-derived-schema.sql
