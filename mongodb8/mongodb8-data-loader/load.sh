#!/bin/bash

# Automatically set executable permissions for the script
chmod +x "$0"

# Activate the virtual environment
source /venv/bin/activate

until mongosh --host localhost -u root -p example --authenticationDatabase admin --eval "db.adminCommand('ping')" &>/dev/null
do
  sleep 2
done

echo "MongoDB8 ready, creating user ztbd..."

mongosh --host localhost -u root -p example --authenticationDatabase admin <<EOF
use mongodb8

if (db.getUser("ztbd") === null) {
  db.createUser({
    user: "ztbd",
    pwd: "password",
    roles: [ { role: "readWrite", db: "mongodb8" } ]
  });
} else {
  print("User 'ztbd' already exists. Skipping creation.");
}
EOF
echo "User ztbd created."

echo "Importing CSV into collections"
python3 /mongodb8-data-loader/load-mongodb8-data.py
echo "Import has been finished."

echo "Performance testing MongoDB8..."
python3 /mongodb8-data-loader/mongodb8_performance_test.py
echo "Test have been finished."