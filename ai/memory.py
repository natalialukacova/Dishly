import time
import os
from pymongo import MongoClient
from typing import List, Dict
from config import MONGO_URI, MONGO_DB_NAME, MONGO_COLLECTION

client = MongoClient(MONGO_URI)
db = client[MONGO_DB_NAME]
collection = db[MONGO_COLLECTION]

def get_memory(recipe_id: int) -> List[Dict]:
    doc = collection.find_one({"recipe_id": recipe_id})
    return doc.get("memory", []) if doc else []

def save_memory(recipe_id: int, memory: List[Dict]):
    collection.update_one(
        {"recipe_id": recipe_id},
        {"$set": {"memory": memory}},
        upsert=True
    )

def get_recipe_text(recipe_id: int) -> str:
    doc = collection.find_one({"recipe_id": recipe_id})
    if doc and "recipe_text" in doc:
        return doc["recipe_text"]
    try:
        path = f"memory/{recipe_id}_recipe.txt"
        with open(path, "r") as f:
            return f.read()
    except FileNotFoundError:
        return ""

def save_recipe_text(recipe_id: int, recipe_text: str):
    start = time.time()
    collection.update_one(
        {"recipe_id": int(recipe_id)},
        {"$set": {"recipe_text": recipe_text}},
        upsert=True
    )
    print(f"[Python] Mongo save took {time.time() - start:.2f}s")

    os.makedirs("memory", exist_ok=True)
    with open(f"memory/{recipe_id}_recipe.txt", "w") as f:
        f.write(recipe_text)
    print("[Python] Saved recipe to file")

    from rag import index_recipe_text
    index_recipe_text(recipe_id, recipe_text)