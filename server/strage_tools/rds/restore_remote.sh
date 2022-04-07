#!/bin/bash
set -exo pipefail
DB_HOST=$1
mysql -h ${DB_HOST} -u root -prootroot -e'drop database if exists app;create database app;'
mysql -h ${DB_HOST} -u root -prootroot app < app.sql
