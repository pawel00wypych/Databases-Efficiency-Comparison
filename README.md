# Database Efficiency Comparison
Comparison between efficiency in PostgreSQL, OracleDB, MongoDB 7 and MongoDB 8 using large dataset and CRUD operations.

## Project requirements:
- Python 3.13.1
- Docker version 27.5.1

## ERD Diagram:
![Alt text](ERD.png)

## How to run docker containers in terminal:
- Run docker desktop
- in terminal: ```docker-compose up -d```


## Data set:
https://www.kaggle.com/datasets/gauthamp10/google-playstore-apps?select=Google-Playstore.csv&fbclid=IwZXh0bgNhZW0CMTAAAR15ErCJKTFgYNq0z2Rlv4Qv4HtDqWL5MU_KMEJjxEXhePNwHnGNHAvPwr4_aem_xN1mb7DQU-Q1-LVUeoNuMg

---

## How to prepare data files:
- put ```Google-Playstore.csv``` file to ```data/``` directory
- run script in ```prepare_data.ipynb```

# Before running any script:
- if you didn't run ```docker-compose up -d``` do it now. Databases will be created automatically.

## How to create tables and load data to oracleDB from csv file:
- run ```docker exec -it --user root oracledb bash -c "/oracle-data-loader/load_oracle_data.sh"```
## How to run CRUD operations on OracleDB:
- run ```docker exec -it --user root oracledb bash -c "/oracle-queries/run_oracle_queries.sh"```

## How to create tables and load data to Postgresql from csv file:
- run ```docker exec -it --user root postgres bash -c "/postgresql-data-loader/load_postgresql_data.sh"```
## How to run CRUD operations on Postgresql:
- run ```docker exec -it --user root postgres bash -c "/postgresql-queries/run_postgresql_queries.sh"```

## How to create collections and load data to mongodb8 from csv file:
- run ```docker exec -it --user root mongodb8 bash -c "/mongodb8-data-loader/load.sh"```

## How to create collections and load data to mongodb7 from csv file:
- run ```docker exec -it --user root mongodb7 bash -c "/mongodb7-data-loader/load.sh"```

---

## Connect to MongoDB 7:
- ```docker exec -it mongodb7 mongosh "mongodb://root:example@mongodb7:27017/"```


## Connect to MongoDB 8:
- ```docker exec -it mongodb8 mongosh "mongodb://root:example@mongodb8:27017/"```


## Connect to PostgreSQL:
- ```docker exec -it postgres psql -U user -d mydatabase```

## Connect to OracleDB:
- ```docker exec -it oracledb sqlplus system/oracle@//localhost:1521/FREE```

