# RxNorm database setup

## Initial setup

We assume a running Postgres server is listening on localhost:5432, that a superuser "postgres" exists,
and that local trust authentication is being used. For other cases, define PG* environment variables (such
as PGHOST, PGPORT) appropriately before running the scripts below.

Create the rxnorm user, database, and schema:
```
scripts/create-db.sh
```

## Create schema tables

To create schema tables for the original RxNorm tables and those
of the derived/augmented relational schema:

```
scripts/create-tables.sh
```

## Populate tables

Copy the "rrf" directory contents from the RxNorm data files distribution into directory
`rxnorm-orig/rrf`. Then load this data into the RxNorm database tables and the derived tables via:

```
scripts/populate-tables.sh
```

## Create views

```
scripts/create-views.sh
```
