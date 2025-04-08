import pandas as pd
from pymongo import MongoClient

# Load CSV
df = pd.read_csv('/shared-data/Google-Playstore_cleaned_10000_rows.csv')

# Connect to MongoDB
client = MongoClient("mongodb://ztbd:password@mongodb8:27017/?authSource=mongodb8")

db = client['mongodb8']

apps_basic = df[['App Name', 'Category', 'Rating']].dropna()
db['apps_basic'].insert_many(apps_basic.to_dict(orient='records'))

installs_info = df[['App Name', 'Installs', 'Size']].dropna()
db['installs_info'].insert_many(installs_info.to_dict(orient='records'))


print("installs_info shape:", installs_info.shape)
print(installs_info.head())

print("Data successfully loaded into Mongodb8.")
