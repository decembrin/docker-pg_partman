#!/usr/bin/env bash

docker_process_sql() {
	local query_runner=( psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --no-password --no-psqlrc )

	"${query_runner[@]}"
}

docker_process_sql <<-'EOSQL'
CREATE SCHEMA partman;
CREATE EXTENSION pg_partman SCHEMA partman;
EOSQL