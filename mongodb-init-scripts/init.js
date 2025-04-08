db = db.getSiblingDB('mongodb8');

db.createUser({
  user: 'ztbd',
  pwd: 'password',
  roles: [{ role: 'readWrite', db: 'mongodb8' }]
});

db.mycollection.insertMany([
  { name: "Alice" },
  { name: "Bob" }
]);
