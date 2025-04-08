import pandas as pd
from pymongo import MongoClient
import time

INSERT_EXECUTIONS = 10
path = '/shared-data/'
files = ['Google-Playstore_cleaned_10000_rows.csv',
         'Google-Playstore_cleaned_100000_rows.csv',
         'Google-Playstore_cleaned_500000_rows.csv',
         'Google-Playstore_cleaned_1000000_rows.csv']

client = MongoClient("mongodb://ztbd:password@mongodb7:27017/?authSource=mongodb7")
db = client['mongodb7']

for f in files:

    df = pd.read_csv(path+f)

    developer = df[['Developer Id',
                    'Developer Website',
                    'Developer Email']].dropna()

    unique_devs = developer.drop_duplicates(subset=['Developer Id'])
    developers_docs = []
    for _, row in unique_devs.iterrows():
        dev_doc = {
            "name": row["Developer Id"],
            "website": row["Developer Website"],
            "email": row["Developer Email"]
        }
        developers_docs.append(dev_doc)

    # Insert to MongoDB and get ObjectIds
    result = db.developers.insert_many(developers_docs)

    developer_name_to_id = {
        dev["name"]: dev_id
        for dev, dev_id in zip(developers_docs, result.inserted_ids)
    }

    application = df[['App Name',
                      'App Id',
                      'Category',
                      'Free',
                      'Price',
                      'Currency',
                      'Size',
                      'Minimum Android',
                      'Privacy Policy',
                      'Content Rating',
                      'Released',
                      'Last Updated',
                      'Ad Supported',
                      'In App Purchases',
                      'Rating',
                      'Rating Count',
                      'Installs',
                      'Minimum Installs',
                      'Maximum Installs',
                      'Developer Id']].dropna()

    applications = []
    for _, row in application.iterrows():
        dev_name = row['Developer Id']
        developer_id = developer_name_to_id.get(dev_name)

        app = {
            "name": row['App Name'],
            "address": row['App Id'],
            "free": bool(row['Free']),
            "price": row['Price'],
            "currency": row['Currency'],
            "category": row['Category'],
            "size": row['Size'],
            "content_rating": row['Content Rating'],
            "minimum_android": row['Minimum Android'],
            "released": row['Released'],
            "last_updated": row['Last Updated'],
            "privacy_policy": row['Privacy Policy'],
            "ad_supported": bool(row['Ad Supported']),
            "in_app_purchases": bool(row['In App Purchases']),
            "rating": {
                "value": row['Rating'],
                "count": row['Rating Count']
            },
            "installs": {
                "actual": row['Installs'],
                "min": row['Minimum Installs'],
                "max": row['Maximum Installs']
            },
            "developer_id": developer_id
        }
        applications.append(app)

    elapsed_time_all = 0
    for i in range(INSERT_EXECUTIONS):
        # Clear the collections
        db.developers.delete_many({})
        db.applications.delete_many({})


        start_time = time.time()  # Start time before insert operation

        result = db.developers.insert_many(developers_docs)

        developer_name_to_id = {
            dev["name"]: dev_id
            for dev, dev_id in zip(developers_docs, result.inserted_ids)
        }

        BATCH_SIZE = 10000
        for j in range(0, len(applications), BATCH_SIZE):
            batch = applications[j:j+BATCH_SIZE]
            db.applications.insert_many(batch)

        end_time = time.time()  # End time after insert operation

        # Calculate and print elapsed time for each iteration
        elapsed_time = end_time - start_time
        elapsed_time_all += elapsed_time
        print(f"Iteration {i+1}: Data successfully loaded into MongoDB. Time taken: {elapsed_time:.2f} seconds.")

    print(f"File: {f} successfully loaded into MongoDB. Average time taken: {elapsed_time_all/INSERT_EXECUTIONS:.2f} "
          f"seconds after {INSERT_EXECUTIONS} executions.")