#!/bin/bash
ENV="local"
SQL_FILE="${ENV}.sql"
rm -f ${SQL_FILE}
mysqldump --single-transaction -h 127.0.0.1 -u root -p app > ${SQL_FILE}
