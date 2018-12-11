#!/bin/bash
set -exo pipefail
docker-compose up -d hive-metastore-db

docker-compose -f util.yml run --rm util wait_for_up hive-metastore-db 5432
docker-compose run --rm hive-hiveserver ./bin/schematool -initSchema -dbType postgres
docker-compose up -d hive-metastore
docker-compose -f util.yml run --rm util wait_for_up hive-metastore 9083
docker-compose up -d
# this one can take a while
docker-compose -f util.yml run --rm util wait_for_up hive-hiveserver 10000 10
docker-compose -f util.yml run --rm util wait_for_up presto 8080
