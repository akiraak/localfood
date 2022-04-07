#!/bin/bash
SRC_ENV=$1
DIST_ENV=$2
DB_HOST=$3
SQL_FILE="${SRC_ENV}.sql"
MANAGEMENT_HOST="localfood-${DIST_ENV}-management"

scp ./${SQL_FILE} ${MANAGEMENT_HOST}:~/app.sql
scp restore_remote.sh ${MANAGEMENT_HOST}:~
eval "ssh ${MANAGEMENT_HOST} 'bash -l -i ~/restore_remote.sh ${DB_HOST}'"
