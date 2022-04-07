#!/bin/bash
set -exo pipefail
DB_HOST=$1
rm -f cabo_app.sql
mysqldump --single-transaction -h ${DB_HOST} -u root -prootroot cabo_app > cabo_app.sql
