# RxNorm database setup

## Initial setup
We assume a running Postgres server is listening on localhost:5432, that a superuser "postgres" exists,
and that local trust authentication is being used. For other cases, define PG* environment variables (such
as PGHOST, PGPORT) appropriately before running the scripts below.

Create the rxnorm user, database, and schema:
```
scripts/create-db.sh
```

## Create schema objects
To create schema objects (tables, views etc) for the original RxNorm tables and those
of the derived/augmented relational schema:

```
scripts/create-schema-objects.sh
```

## Populate schema data

Copy the "rrf" directory contents from the RxNorm data files distribution into directory
`rxnorm-orig/rrf`. Then load this data into the RxNorm database tables:

```
scripts/populate-rxnorm-orig.sh
```
and then populate the derived data based on the original RxNorm data:

```
scripts/populate-derived-schema.sh
```
