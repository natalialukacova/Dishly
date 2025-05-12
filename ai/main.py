from fastapi import FastAPI
from pydantic import BaseModel
from typing import List, Dict
from memory import get_memory, save_memory
from chat import get_ai_response

app = FastAPI()

class ChatMessage(BaseModel):
    recipe_id: str
    message: str

@app.post("/chat")
async def chat_with_recipe(data: ChatMessage):
    # Load previous chat memory
    memory = get_memory(data.recipe_id)

    # Get AI response using LangChain and llama3
    response = get_ai_response(data.message, memory)

    # Append user and assistant messages to memory
    memory.append({"role": "user", "content": data.message})
    memory.append({"role": "assistant", "content": response})
    save_memory(data.recipe_id, memory)

    return {"response": response}
