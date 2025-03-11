# Advanced_DB_project
Comparison between efficiency in PostgreSQL, OracleDB, MongoDB 7 and MongoDB 8 using large dataset and CRUD operations. 

Project requirements:

- Install Docker version 27.5.1

How to run docker in terminal:

docker-compose up -d


Connect to MongoDB 7:

docker exec -it mongodb7 mongosh "mongodb://root:example@mongodb7:27017/"


Connect to MongoDB 8:

docker exec -it mongodb8 mongosh "mongodb://root:example@mongodb8:27017/"


Connect to PostgreSQL:

docker exec -it postgres psql -U user -d mydatabase

Connect to OracleDB:

docker exec -it oracledb sqlplus system/oracle@//localhost:1521/FREE


