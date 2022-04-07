#!/bin/bash
DB_HOST="localfood-prod-app.cevn2aedjv5w.us-west-1.rds.amazonaws.com"
./restore.sh local prod ${DB_HOST}
