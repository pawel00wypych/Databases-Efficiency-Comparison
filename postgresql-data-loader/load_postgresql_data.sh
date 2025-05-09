#!/bin/bash

# Ustawienia
USER="ztbd"
PASSWORD="password"
DB="mydatabase"
HOST="localhost"
PORT="5432"
SQL_FILE="/postgresql-data-loader/load_postgresql_data.sql"

# Lista plików CSV do załadowania
CSV_FILES=(
  "/shared-data/Google-Playstore_cleaned_10000_rows.csv"
  "/shared-data/Google-Playstore_cleaned_100000_rows.csv"
  "/shared-data/Google-Playstore_cleaned_500000_rows.csv"
  "/shared-data/Google-Playstore_cleaned_1000000_rows.csv"
)

# Zmienna do ustawienia daty
DATETIME_FORMAT="SET datestyle TO 'DMY';"

# Pętla przetwarzająca każdy plik CSV
for CSV_FILE in "${CSV_FILES[@]}"; do
  echo "Processing file: $CSV_FILE"

  # Ustawienie daty przed załadowaniem danych
  PGPASSWORD=$PASSWORD psql -U $USER -h $HOST -p $PORT -d $DB -c "$DATETIME_FORMAT"

  # Krok 1: Uruchom polecenie COPY, aby załadować dane z pliku CSV do PostgreSQL
  echo "Running COPY command to load data from $CSV_FILE..."
  PGPASSWORD=$PASSWORD psql -U $USER -h $HOST -p $PORT -d $DB -c "
    SET datestyle = 'DMY';
    COPY staging_table(
      app_name,
      app_address,
      category_name,
      rating_value,
      rating_count,
      installs,
      minimum_installs,
      maximum_installs,
      free,
      price,
      currency_name,
      app_size,
      version,
      developer_name,
      developer_website,
      developer_email,
      released,
      last_updated,
      rating_name,
      privacy_policy,
      ad_supported,
      in_app_purchases
    )
    FROM '$CSV_FILE' 
    DELIMITER ',' 
    CSV HEADER;
  "

  # Krok 2: Uruchom skrypt SQL do wstawiania danych do docelowych tabel
  echo "Running SQL script to insert data into PostgreSQL..."
  psql -U $USER -h $HOST -p $PORT -d $DB -f $SQL_FILE

  echo "Completed loading for $CSV_FILE"
done

# Komunikat o powodzeniu
echo "Data loading completed for all files!"
