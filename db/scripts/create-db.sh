#!/bin/sh
createuser -U postgres --echo rxnorm
createdb -U postgres --owner rxnorm rxnorm
psql -d rxnorm -U rxnorm --echo-all -c "create schema rxnorig authorization rxnorm;"
psql -d rxnorm -U rxnorm --echo-all -c "create schema rxnrel authorization rxnorm;" -c "alter role rxnorm set search_path to rxnrel;"
