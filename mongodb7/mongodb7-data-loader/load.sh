#!/bin/bash

# Automatically set executable permissions for the script
chmod +x "$0"

# Activate the virtual environment
source /venv/bin/activate

until mongosh --host localhost -u root -p example --authenticationDatabase admin --eval "db.adminCommand('ping')" &>/dev/null
do
  sleep 2
done

echo "MongoDB7 ready, creating user ztbd..."

mongosh --host localhost -u root -p example --authenticationDatabase admin <<EOF
use mongodb7

if (db.getUser("ztbd") === null) {
  db.createUser({
    user: "ztbd",
    pwd: "password",
    roles: [ { role: "readWrite", db: "mongodb7" } ]
  });
} else {
  print("User 'ztbd' already exists. Skipping creation.");
}
EOF
echo "User ztbd created."

echo "Importing CSV into collections"
python3 /mongodb7-data-loader/load-mongodb7-data.py
echo "Import has been finished."