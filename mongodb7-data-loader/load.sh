#!/bin/bash

# Automatically set executable permissions for the script
chmod +x "$0"

until mongosh --host localhost -u root -p example --authenticationDatabase admin --eval "db.adminCommand('ping')" &>/dev/null
do
  sleep 2
done

echo "MongoDB7 ready, creating user ztbd..."

mongosh --host localhost -u root -p example --authenticationDatabase admin <<EOF
use mongodb7

db.createUser({
  user: "ztbd",
  pwd: "password",
  roles: [ { role: "readWrite", db: "mongodb7" } ]
})

db.mycollection.insertMany([
  { name: "Alice" },
  { name: "Bob" }
])
EOF

echo "User ztbd created."
