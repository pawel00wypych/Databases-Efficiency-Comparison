import random
import time
from pymongo import MongoClient
import subprocess

client = MongoClient("mongodb://ztbd:password@mongodb7:27017/?authSource=mongodb7")
db = client['mongodb7']
backup_db = "mongodb7_backup"
db_name = "mongodb7"
applications = db.applications

def benchmark_operation(func, limit, label):
    times = []
    n = 5
    for i in range(n):
        start = time.time()
        func(limit)
        times.append(time.time() - start)
    avg = sum(times) / len(times)
    print(f">>> {label}: Average over {n} runs: {avg:.2f}s\n")

def measure_simple_select(limit):
    start_time = time.time()
    docs = applications.find({}, {"name": 1, "address": 1, "size": 1}).limit(limit)
    docs_list = list(docs)
    end_time = time.time()
    print(f"Simple SELECT: Retrieved {len(docs_list)} rows in {end_time - start_time:.2f}s")


def measure_medium_select(limit):
    start_time = time.time()
    docs = applications.aggregate([
        {
            "$lookup": {
                "from": "developers",
                "localField": "developer_id",
                "foreignField": "_id",
                "as": "developer"
            }
        },
        {"$unwind": "$developer"},
        {
            "$project": {
                "app_name": "$name",
                "developer_name": "$developer.name",
                "rating_value": "$rating.value"
            }
        },
        {"$limit": limit}
    ])
    docs_list = list(docs)
    end_time = time.time()
    print(f"Medium SELECT: Retrieved {len(docs_list)} rows in {end_time - start_time:.2f}s")


def measure_hard_select(limit):
    start_time = time.time()
    docs = applications.aggregate([
        {
            "$group": {
                "_id": {
                    "developer_id": "$developer_id"
                },
                "app_ids": {"$addToSet": "$_id"},
                "app_count": {"$sum": 1},
                "total_installs": {"$sum": "$installs.actual"}
            }
        },
        {
            "$match": {
                "app_count": {"$gt": 1}
            }
        },
        {
            "$lookup": {
                "from": "developers",
                "localField": "_id.developer_id",
                "foreignField": "_id",
                "as": "developer"
            }
        },
        {"$unwind": "$developer"},
        {
            "$project": {
                "developer_name": "$developer.name",
                "app_ids": 1,
                "app_count": 1,
                "total_installs": 1
            }
        },
        {"$limit": limit}
    ])
    docs_list = list(docs)
    end_time = time.time()
    print(f"Hard SELECT: Retrieved {len(docs_list)} rows in {end_time - start_time:.2f}s")


def measure_simple_update(limit):
    start_time = time.time()

    ids_to_update = list(applications.find({}, {"_id": 1}).limit(limit))
    ids = [doc["_id"] for doc in ids_to_update]

    result = applications.update_many(
        {"_id": {"$in": ids}},
        {"$set": {"price": 100.0}}
    )

    end_time = time.time()
    print(f"Simple UPDATE {limit} docs: {end_time - start_time:.2f}s, "
          f"Matched: {result.matched_count}, Modified: {result.modified_count}")

def measure_medium_update(limit):
    start_time = time.time()

    ids_to_update = list(applications.find({
        "rating.value": {"$gte": 3.0},
        "installs.actual": {"$gte": 1000}
    }, {"_id": 1}).limit(limit))
    ids = [doc["_id"] for doc in ids_to_update]

    modified_count = 0
    for _id in ids:
        app = applications.find_one({"_id": _id}, {"price": 1})
        current_price = app.get("price", 0.0)
        new_price = round(current_price * 1.5, 2)
        res = applications.update_one({"_id": _id}, {"$set": {"price": new_price}})
        modified_count += res.modified_count

    end_time = time.time()
    print(f"Medium UPDATE {limit} docs: {end_time - start_time:.2f}s, "
          f"Modified: {modified_count}")

def measure_hard_update(limit):
    start_time = time.time()

    pipeline = [
        {
            "$match": {
                "$or": [
                    {"rating.value": {"$gte": 3.0}},
                    {"developer.name": {"$regex": ".*hack.*", "$options": "i"}}
                ],
                "installs.actual": {"$gte": 1}
            }
        },
        {
            "$lookup": {
                "from": "developers",
                "localField": "developer_id",
                "foreignField": "_id",
                "as": "developer"
            }
        },
        {"$unwind": "$developer"},
        {"$limit": limit}
    ]

    matched_docs = list(applications.aggregate(pipeline))
    modified_count = 0

    for doc in matched_docs:
        rating = doc.get("rating", {}).get("value", 0)
        current_price = doc.get("price", 0.0) or 0.0

        if rating >= 4.5:
            new_price = round(current_price * 1.15, 2)
        elif rating >= 3.0:
            new_price = round(current_price * 1.05, 2)
        else:
            new_price = round(current_price * 0.95, 2)

        new_policy = (doc.get("privacy_policy") or "").lower()[:100]
        app_size = doc.get("size")
        new_size = app_size if app_size else round(10 + 90 * random.random(), 2)

        res = applications.update_one(
            {"_id": doc["_id"]},
            {"$set": {
                "price": new_price,
                "privacy_policy": new_policy,
                "size": new_size
            }}
        )
        modified_count += res.modified_count

    end_time = time.time()
    print(f"Hard UPDATE {limit} docs: {end_time - start_time:.2f}s, Modified: {modified_count}")


def measure_simple_delete(limit):
    start_time = time.time()
    ids_to_delete = applications.find({"price": {"$gte": 0}}, {"_id": 1}).limit(limit)
    ids_list = [doc["_id"] for doc in ids_to_delete]

    result = applications.delete_many({"_id": {"$in": ids_list}})
    end_time = time.time()
    print(f"Simple DELETE: Deleted {result.deleted_count} docs in {end_time - start_time:.2f}s")



def measure_medium_delete(limit):

    start_time = time.time()
    ids_to_delete = applications.find(
        {"price": {"$gte": 0}, "rating.value": {"$lt": 3}},
        {"_id": 1}
    ).limit(limit)
    ids_list = [doc["_id"] for doc in ids_to_delete]

    result = applications.delete_many({"_id": {"$in": ids_list}})
    end_time = time.time()
    print(f"Medium DELETE: Deleted {result.deleted_count} docs in {end_time - start_time:.2f}s")



def measure_hard_delete(limit):
    start_time = time.time()
    pipeline = [
        {
            "$match": {
                "rating.value": {"$lt": 4},
                "installs.max": {"$gt": 1}
            }
        },
        {
            "$project": {"_id": 1}
        },
        {
            "$limit": limit
        }
    ]
    docs_to_delete = list(applications.aggregate(pipeline))
    ids_list = [doc["_id"] for doc in docs_to_delete]

    result = applications.delete_many({"_id": {"$in": ids_list}})
    end_time = time.time()
    print(f"Hard DELETE: Deleted {result.deleted_count} docs in {end_time - start_time:.2f}s")


if __name__ == "__main__":

    subprocess.run([
        "mongodump",
        "--uri=mongodb://ztbd:password@mongodb7:27017",
        "--db=mongodb7",
        "--out=/backup"
    ])

    for size in [10000, 100000, 500000, 1000000]:
        print(f"\nTesting with {size} documents:")

        benchmark_operation(measure_simple_select, size, "measure_simple_select")
        benchmark_operation(measure_medium_select, size, "measure_medium_select")
        benchmark_operation(measure_hard_select, size, "measure_hard_select")
        benchmark_operation(measure_simple_update, size, "measure_simple_update")
        benchmark_operation(measure_medium_update, size, "measure_medium_update")
        benchmark_operation(measure_hard_update, size, "measure_hard_update")

        benchmark_operation(measure_simple_delete, size, "measure_simple_delete")
        subprocess.run([
            "mongorestore",
            "--uri=mongodb://ztbd:password@mongodb7:27017",
            "--db=mongodb7",
            "--drop",
            "/backup/mongodb7"
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)

        benchmark_operation(measure_medium_delete, size, "measure_medium_delete")
        subprocess.run([
            "mongorestore",
            "--uri=mongodb://ztbd:password@mongodb7:27017",
            "--db=mongodb7",
            "--drop",
            "/backup/mongodb7"
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)

        benchmark_operation(measure_hard_delete, size, "measure_hard_delete")
        subprocess.run([
            "mongorestore",
            "--uri=mongodb://ztbd:password@mongodb7:27017",
            "--db=mongodb7",
            "--drop",
            "/backup/mongodb7"
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)