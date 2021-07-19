## Create development database
Follow instructions in `db/Readme.md`.

Create file `envs/local-dev.properties` with connection information for the local database:
```
jdbc.driverClassName=org.postgresql.Driver
jdbc.url=jdbc:postgresql://localhost:5432/rxnorm
jdbc.username=rxnorm
jdbc.password=...
```

## Build application jar with dependencies
mvn clean package

## Complete build of dist package
mvn clean package -Psyspkg

## Run
Run against local development database:
```
java -Dspring.config.additional-location=envs/local-dev.properties -jar target/rxnx.jar
```

Open `http://localhost:8080/rxnorm-explorer/` in a browser.

## Test api via command line
Fetch related entities for a list of two-part ndc codes:
```
curl -X POST -H "Content-Type:application/json" --data '["50090-1671","50090-1784"]' \
  "http://localhost:8080/api/drug-rel-ents/for-ndcs"
```
