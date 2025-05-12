from pymongo import MongoClient
from typing import List, Dict

client = MongoClient("mongodb://localhost:27017")
db = client["dishly"]
collection = db["chat_memory"]

def get_memory(recipe_id: str) -> List[Dict]:
    doc = collection.find_one({"recipe_id": recipe_id})
    return doc["memory"] if doc else []

def save_memory(recipe_id: str, memory: List[Dict]):
    collection.update_one(
        {"recipe_id": recipe_id},
        {"$set": {"memory": memory}},
        upsert=True
    )
