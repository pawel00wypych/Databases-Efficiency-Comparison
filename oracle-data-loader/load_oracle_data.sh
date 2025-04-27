#!/bin/bash

# Automatically set executable permissions for the script
chmod +x "$0"

# Define variables
DOCKER_CONTAINER="oracledb"
USER="ztbd"
PASSWORD="password"
DB="FREE"
CONTROL_FILE="/oracle-data-loader/load.ctl"
SQL_FILE="/oracle-data-loader/load_oracle_data.sql"

# List of CSV files to load
CSV_FILES=(
  "/shared-data/Google-Playstore_cleaned_10000_rows.csv"
  "/shared-data/Google-Playstore_cleaned_100000_rows.csv"
  "/shared-data/Google-Playstore_cleaned_500000_rows.csv"
  "/shared-data/Google-Playstore_cleaned_1000000_rows.csv"
)

# Loop through each CSV file
for CSV_FILE in "${CSV_FILES[@]}"; do
  echo "Processing file: $CSV_FILE"

  # Modify the control file to update the CSV file path dynamically
  echo "Modifying control file to update the CSV file path..."

  # Use sed to update the INFILE path in the .ctl file for the current CSV file
  sed -i "s|INFILE '/shared-data/Google-Playstore_cleaned_.*.csv'|INFILE '$CSV_FILE'|g" $CONTROL_FILE

  # Step 1: Run SQL*Loader to load data from the CSV
  echo "Running SQL*Loader to load data from $CSV_FILE..."
  sqlldr $USER/$PASSWORD@$DB control=$CONTROL_FILE SKIP=1

  # Step 2: Run SQL script to insert data from the CSV (if needed)
  echo "Running SQL script to insert data into Oracle..."
  sqlplus $USER/$PASSWORD@$DB < $SQL_FILE

  echo "Completed loading for $CSV_FILE"
done

# Final success message
echo "Data loading completed for all files!"
