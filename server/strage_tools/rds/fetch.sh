#!/bin/bash
ENV=$1
DB_HOST=$2
MANAGEMENT_HOST="localfood-${ENV}-management"
SQL_FILE="${ENV}.sql"

scp fetch_remote.sh ${MANAGEMENT_HOST}:~
eval "ssh ${MANAGEMENT_HOST} 'bash -l -i ~/fetch_remote.sh ${DB_HOST}'"
rm ./${SQL_FILE}
scp ${MANAGEMENT_HOST}:~/cabo_app.sql ./${SQL_FILE}
