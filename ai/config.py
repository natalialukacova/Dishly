import os

OLLAMA_MODEL_NAME = os.getenv("OLLAMA_MODEL_NAME", "llama3")
MONGO_URI = os.getenv("MONGO_URI", "mongodb://localhost:27017")
MONGO_DB_NAME = os.getenv("MONGO_DB_NAME", "dishly")
MONGO_COLLECTION = os.getenv("MONGO_COLLECTION", "chat_memory")
