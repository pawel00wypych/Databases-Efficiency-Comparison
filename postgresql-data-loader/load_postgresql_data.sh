#!/bin/bash

# Ustawienia
USER="ztbd"
PASSWORD="password"
DB="mydatabase"
HOST="localhost"
PORT="5432"
STAGING_TABLE="staging_table"
TEMP_TABLE="temp_staging_table"

# Lista plików CSV do załadowania
CSV_FILES=(
  "/shared-data/Google-Playstore_cleaned_10000_rows.csv"
  "/shared-data/Google-Playstore_cleaned_100000_rows.csv"
  "/shared-data/Google-Playstore_cleaned_500000_rows.csv"
  "/shared-data/Google-Playstore_cleaned_1000000_rows.csv"
)

# Funkcja sprawdzająca, czy tabela istnieje
function check_table_exists() {
  PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -U $USER -d $DB -t -c "SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = '$1');"
}

# Funkcja tworząca tabelę staging_table jeśli nie istnieje
function create_staging_table() {
  PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -U $USER -d $DB -c "
  CREATE TABLE IF NOT EXISTS $STAGING_TABLE (
    app_name character varying(255),
    app_address character varying(255),
    category_name character varying(64),
    rating_value numeric(2,1),
    rating_count numeric,
    installs bigint,
    minimum_installs bigint,
    maximum_installs bigint,
    free character(1),
    price numeric(10,0),
    currency_name character varying(16),
    app_size numeric,
    version character varying(64),
    developer_name character varying(255),
    developer_website character varying(1000),
    developer_email character varying(255),
    released date,  -- Zmieniamy na date
    last_updated date,  -- Zmieniamy na date
    rating_name character varying(64),
    privacy_policy text,
    ad_supported character(1),
    in_app_purchases character(1)
  );
  "
}

# Funkcja tworząca tabelę temp_staging_table, jeśli nie istnieje
function create_temp_table() {
  PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -U $USER -d $DB -c "
  CREATE TABLE IF NOT EXISTS $TEMP_TABLE (
    app_name character varying(255),
    app_address character varying(255),
    category_name character varying(64),
    rating_value numeric(2,1),
    rating_count numeric,
    installs numeric,
    minimum_installs numeric,
    maximum_installs numeric,
    free character(1),
    price numeric(10,0),
    currency_name character varying(16),
    app_size numeric,
    version character varying(64),
    developer_name character varying(255),
    developer_website character varying(1000),
    developer_email character varying(255),
    released character varying(10),
    last_updated character varying(10),
    rating_name character varying(64),
    privacy_policy text,
    ad_supported character(1),
    in_app_purchases character(1)
  );
  "
}

# Pętla przez wszystkie pliki CSV
for CSV_FILE in "${CSV_FILES[@]}"; do
  echo "==================================================================="
  echo "Przetwarzanie pliku: $CSV_FILE"
  
  # 1. Sprawdzamy, czy tabela staging_table istnieje, jeśli nie to ją tworzymy
  echo "Sprawdzamy istnienie tabeli staging_table..."
  if [ $(check_table_exists "$STAGING_TABLE") = "f" ]; then
    echo "Tabela $STAGING_TABLE nie istnieje, tworzę ją..."
    create_staging_table
  else
    echo "Tabela staging_table już istnieje."
  fi

  # 2. Sprawdzamy, czy tabela temp_staging_table istnieje, jeśli nie to ją tworzymy
  echo "Sprawdzamy istnienie tabeli temp_staging_table..."
  if [ $(check_table_exists "$TEMP_TABLE") = "f" ]; then
    echo "Tabela $TEMP_TABLE nie istnieje, tworzę ją..."
    create_temp_table
  else
    echo "Tabela temp_staging_table już istnieje."
  fi

  # 3. Czyścimy temp_staging_table
  echo "Czyścimy tabelę temp_staging_table..."
  PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -U $USER -d $DB -c "TRUNCATE TABLE $TEMP_TABLE;"

  # 4. Ładujemy dane do temp_staging_table
  echo "Ładujemy dane do temp_staging_table z pliku $CSV_FILE..."
  if PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -U $USER -d $DB -c "
    COPY $TEMP_TABLE (
      app_name, app_address, category_name, rating_value, rating_count,
      installs, minimum_installs, maximum_installs, free, price,
      currency_name, app_size, version, developer_name,
      developer_website, developer_email, released, last_updated,
      rating_name, privacy_policy, ad_supported, in_app_purchases
    ) 
    FROM '$CSV_FILE' DELIMITER ',' CSV HEADER;
  "; then
    echo "Dane zostały załadowane do temp_staging_table."
  else
    echo "Błąd podczas ładowania pliku CSV: $CSV_FILE"
    exit 1
  fi

  # 5. Konwertujemy daty i wstawiamy dane do docelowych tabel
  echo "Konwertujemy daty i wstawiamy dane do docelowych tabel..."
  PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -U $USER -d $DB -c "
    INSERT INTO $STAGING_TABLE (
      app_name, app_address, category_name, rating_value, rating_count,
      installs, minimum_installs, maximum_installs, free, price,
      currency_name, app_size, version, developer_name,
      developer_website, developer_email, released, last_updated,
      rating_name, privacy_policy, ad_supported, in_app_purchases
    )
    SELECT
      app_name, app_address, category_name, rating_value, rating_count,
      installs, minimum_installs, maximum_installs, free, price,
      currency_name, app_size, version, developer_name,
      developer_website, developer_email,
      TO_DATE(released, 'DD-MM-YYYY') AS released,
      TO_DATE(last_updated, 'DD-MM-YYYY') AS last_updated,
      rating_name, privacy_policy, ad_supported, in_app_purchases
    FROM $TEMP_TABLE;
  "

  # 6. Usuwamy dane z tabeli tymczasowej
  echo "Usuwamy dane z tabeli temp_staging_table..."
  PGPASSWORD=$PASSWORD psql -h $HOST -p $PORT -U $USER -d $DB -c "TRUNCATE TABLE $TEMP_TABLE;"

  echo "Zakończono ładowanie pliku: $CSV_FILE"
  echo "==================================================================="
done

# Finalne info
echo "Wszystkie pliki CSV zostały załadowane!"
