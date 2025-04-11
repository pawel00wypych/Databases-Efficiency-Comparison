#!/bin/bash

# Ustawienia
USER="ztbd"
PASSWORD="password"
DB="mydatabase"
HOST="localhost"
PORT="5432"
STAGING_TABLE="staging_table"

# Lista plików CSV do załadowania
CSV_FILES=(
  "/shared-data/Google-Playstore_cleaned_10000_rows.csv"
  "/shared-data/Google-Playstore_cleaned_100000_rows.csv"
  "/shared-data/Google-Playstore_cleaned_500000_rows.csv"
  "/shared-data/Google-Playstore_cleaned_1000000_rows.csv"
)

# Pętla przez wszystkie pliki CSV
for CSV_FILE in "${CSV_FILES[@]}"; do
  echo "==================================================================="
  echo "Przetwarzanie pliku: $CSV_FILE"

  # 1. Czyścimy staging_table
  echo "Czyścimy tabelę staging..."
  PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -U $USER -d $DB -c "TRUNCATE TABLE $STAGING_TABLE;"

  # 2. Ładujemy CSV do staging_table
  echo "Ładujemy dane do staging_table..."
  PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -U $USER -d $DB -c "\COPY $STAGING_TABLE (
    app_name, app_address, category_name, rating_value, rating_count,
    installs, minimum_installs, maximum_installs, free, price,
    currency_name, app_size, version, developer_name,
    developer_website, developer_email, released, last_updated,
    rating_name, privacy_policy, ad_supported, in_app_purchases
  ) FROM '$CSV_FILE' DELIMITER ',' CSV HEADER;"

  # 3. Odpalamy load_postgres_data.sql
  echo "Wstawiamy dane do docelowych tabel (Application, Rating itd.)..."
  PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -U $USER -d $DB -f /postgres-data-loader/load_postgres_data.sql

  echo "Zakończono ładowanie pliku: $CSV_FILE"
  echo "==================================================================="
done

# Finalne info
echo "Wszystkie pliki CSV zostały załadowane!"
