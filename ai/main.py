from fastapi import FastAPI, Request
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware

from langchain_ollama import OllamaLLM
from langchain.memory import ConversationBufferMemory
from langchain.chains import ConversationChain

app = FastAPI()

# Allow frontend access
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], 
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class ChatRequest(BaseModel):
    message: str

MODEL_NAME = "llama3"  

llm = OllamaLLM(model=MODEL_NAME)
memory = ConversationBufferMemory()

system_message = (
    "You are Dishly, a helpful cooking assistant that helps users find and manage recipes. "
    "You give short, clear responses. Your tone is friendly and practical."
)

# Inject system message into memory once at startup
memory.chat_memory.add_user_message("system")
memory.chat_memory.add_ai_message(system_message)

conversation = ConversationChain(
    llm=llm,
    memory=memory,
    verbose=True
)

@app.post("/chat")
async def chat(request: ChatRequest):
    user_input = request.message.strip()
    response = conversation.run(user_input)
    return {"response": response}
