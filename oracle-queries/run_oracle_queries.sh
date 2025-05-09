#!/bin/bash

# Automatically set executable permissions for the script
chmod +x "$0"

DOCKER_CONTAINER="oracledb"
USER="ztbd"
PASSWORD="password"
DB="FREE"
SQL_FILE_SELECT_SIMPLE="/oracle-queries/simple_select_queries.sql"
SQL_FILE_SELECT_MEDIUM="/oracle-queries/medium_select_queries.sql"
SQL_FILE_SELECT_HARD="/oracle-queries/hard_select_queries.sql"
SQL_FILE_UPDATE_SIMPLE="/oracle-queries/simple_update_queries.sql"
SQL_FILE_UPDATE_MEDIUM="/oracle-queries/medium_update_queries.sql"
SQL_FILE_UPDATE_HARD="/oracle-queries/hard_update_queries.sql"
SQL_FILE_DELETE_SIMPLE="/oracle-queries/simple_delete_queries.sql"
SQL_FILE_DELETE_MEDIUM="/oracle-queries/medium_delete_queries.sql"
SQL_FILE_DELETE_HARD="/oracle-queries/hard_delete_queries.sql"


echo "Running SQL script - simple SELECT data from OracleDB..."
sqlplus -s $USER/$PASSWORD@$DB < $SQL_FILE_SELECT_SIMPLE | grep "Elapsed"
echo "SQL script for simple SELECT queries completed."

echo "Running SQL script - medium SELECT data from OracleDB..."
sqlplus -s $USER/$PASSWORD@$DB < $SQL_FILE_SELECT_MEDIUM | grep "Elapsed"
echo "SQL script for medium SELECT queries completed."

echo "Running SQL script - hard SELECT data from OracleDB..."
sqlplus -s $USER/$PASSWORD@$DB < $SQL_FILE_SELECT_HARD | grep "Elapsed"
echo "SQL script for hard SELECT queries completed."

echo "Running SQL script - simple UPDATE data from OracleDB..."
sqlplus -s $USER/$PASSWORD@$DB < $SQL_FILE_UPDATE_SIMPLE
echo "SQL script for simple UPDATE queries completed."

echo "Running SQL script - medium UPDATE data from OracleDB..."
sqlplus -s $USER/$PASSWORD@$DB < $SQL_FILE_UPDATE_MEDIUM
echo "SQL script for medium UPDATE queries completed."

echo "Running SQL script - hard UPDATE data from OracleDB..."
sqlplus -s $USER/$PASSWORD@$DB < $SQL_FILE_UPDATE_HARD
echo "SQL script for hard UPDATE queries completed."

echo "Running SQL script - simple DELETE data from OracleDB..."
sqlplus -s $USER/$PASSWORD@$DB < $SQL_FILE_DELETE_SIMPLE
echo "SQL script for simple DELETE queries completed."

echo "Running SQL script - medium DELETE data from OracleDB..."
sqlplus -s $USER/$PASSWORD@$DB < $SQL_FILE_DELETE_MEDIUM
echo "SQL script for medium DELETE queries completed."

echo "Running SQL script - hard DELETE data from OracleDB..."
sqlplus -s $USER/$PASSWORD@$DB < $SQL_FILE_DELETE_HARD
echo "SQL script for hard DELETE queries completed."