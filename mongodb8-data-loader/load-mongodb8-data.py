import pandas as pd
from pymongo import MongoClient

# Load CSV
df = pd.read_csv('/shared-data/Google-Playstore_cleaned_10000_rows.csv')

# Connect to MongoDB
client = MongoClient("mongodb://ztbd:password@localhost:27017/?authSource=admin")
db = client['mongodb8']

# Insert into apps_basic collection
apps_basic = df[['App', 'Category', 'Rating']].dropna()
db['apps_basic'].insert_many(apps_basic.to_dict(orient='records'))

# Insert into installs_info collection
installs_info = df[['App', 'Installs', 'Size']].dropna()
db['installs_info'].insert_many(installs_info.to_dict(orient='records'))

print("✅ Data successfully loaded into MongoDB.")
