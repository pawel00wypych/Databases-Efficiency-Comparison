#!/bin/bash

chmod +x "$0"

DOCKER_CONTAINER="postgres"
USER="ztbd"
PASSWORD="password"
DB="mydatabase"
HOST="localhost"
PORT="5432"
SQL_FILE_SELECT_SIMPLE="/postgresql-queries/simple_select_queries.sql"
SQL_FILE_SELECT_MEDIUM="/postgresql-queries/medium_select_queries.sql"
SQL_FILE_SELECT_HARD="/postgresql-queries/hard_select_queries.sql"
SQL_FILE_UPDATE_SIMPLE="/postgresql-queries/simple_update_queries.sql"
SQL_FILE_UPDATE_MEDIUM="/postgresql-queries/medium_update_queries.sql"
SQL_FILE_UPDATE_HARD="/postgresql-queries/hard_update_queries.sql"
SQL_FILE_DELETE_SIMPLE="/postgresql-queries/simple_delete_queries.sql"
SQL_FILE_DELETE_MEDIUM="/postgresql-queries/medium_delete_queries.sql"
SQL_FILE_DELETE_HARD="/postgresql-queries/hard_delete_queries.sql"

export PGPASSWORD=$PASSWORD

run_with_timer() {
    LABEL="$1"
    FILE="$2"

    echo "Running SQL script - $LABEL..."

    psql -h $HOST -p $PORT -U $USER -d $DB -f "$FILE"

    echo "Completed: $LABEL"
    echo
}


run_with_timer "simple SELECT" "$SQL_FILE_SELECT_SIMPLE"
run_with_timer "medium SELECT" "$SQL_FILE_SELECT_MEDIUM"
run_with_timer "hard SELECT" "$SQL_FILE_SELECT_HARD"
run_with_timer "simple UPDATE" "$SQL_FILE_UPDATE_SIMPLE"
run_with_timer "medium UPDATE" "$SQL_FILE_UPDATE_MEDIUM"
run_with_timer "hard UPDATE" "$SQL_FILE_UPDATE_HARD"
run_with_timer "simple DELETE" "$SQL_FILE_DELETE_SIMPLE"
run_with_timer "medium DELETE" "$SQL_FILE_DELETE_MEDIUM"
run_with_timer "hard DELETE" "$SQL_FILE_DELETE_HARD"