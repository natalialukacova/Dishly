from langchain_community.vectorstores import FAISS
from langchain_ollama import OllamaEmbeddings
from langchain.schema import Document
import os
from memory import get_recipe_text
from config import OLLAMA_MODEL_NAME


embedding_model = OllamaEmbeddings(model=OLLAMA_MODEL_NAME)

def index_recipe_text(recipe_id: int, recipe_text: str):
    os.makedirs("vectorstore", exist_ok=True)
    doc = Document(page_content=recipe_text, metadata={"recipe_id": recipe_id})
    vectorstore = FAISS.from_documents([doc], embedding_model)
    vectorstore.save_local(f"vectorstore/{recipe_id}")


def get_recipe_context(recipe_id: int, query: str) -> str:
    index_path = f"vectorstore/{recipe_id}"
    if os.path.exists(index_path):
        try:
            vectorstore = FAISS.load_local(index_path, embedding_model, allow_dangerous_deserialization=True)
            matches = vectorstore.similarity_search(query, k=1)
            if matches:
                return matches[0].page_content
        except Exception as e:
            print(f"[RAG] FAISS error: {e}")
    return get_recipe_text(recipe_id)