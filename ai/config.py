import os

OLLAMA_MODEL_NAME = os.getenv("OLLAMA_MODEL_NAME", "llama3")
MONGO_URI = os.environ["MONGO_URI"]
MONGO_DB_NAME = os.environ["MONGO_DB_NAME"]
MONGO_COLLECTION = os.environ["MONGO_COLLECTION"]
