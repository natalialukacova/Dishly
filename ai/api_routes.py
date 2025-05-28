from fastapi import APIRouter, WebSocket, WebSocketDisconnect
from langchain_core.messages import SystemMessage, HumanMessage
from starlette.concurrency import run_in_threadpool

from models import ChatMessage, RecipeContext, RecipeIdea
from llm import llm
import json
import asyncio
import time
from prompts import system_prompt, generate_recipe_system_prompt, generate_recipe_prompt
from memory import get_memory, save_memory, save_recipe_text
from chat import get_ai_response, build_chat_history, llm_stream
from rag import get_recipe_context

router = APIRouter()

@router.post("/chat")
async def chat_with_recipe(data: ChatMessage):
    memory = get_memory(data.recipe_id)
    recipe_text = get_recipe_context(data.recipe_id, data.message)
    if not recipe_text:
        return {"response": "Hmm, I couldn't find the recipe context yet. Try again soon."}
    response = await get_ai_response(system_prompt, data.message, memory, recipe_text)
    memory.extend([
        {"role": "user", "content": data.message},
        {"role": "assistant", "content": response}
    ])
    save_memory(data.recipe_id, memory)
    return {"response": response}

@router.post("/store_recipe")
async def store_recipe(data: RecipeContext):
    start = time.time()
    save_recipe_text(data.recipe_id, data.recipe_text)
    print(f"[Python] Saved recipe {data.recipe_id} in {time.time() - start:.2f}s")
    return {"status": "ok"}

@router.get("/memory/{recipe_id}")
def get_recipe_memory(recipe_id: int):
    return {"recipe_id": recipe_id, "memory": get_memory(recipe_id)}

@router.websocket("/ws")
async def websocket_chat(websocket: WebSocket):
    await websocket.accept()
    print("[WS] Connection accepted")
    try:
        while True:
            data = json.loads(await websocket.receive_text())
            print(f"[WS] Received data: {data}")
            recipe_id = data.get("recipeId")
            user_msg = data.get("message")

            if not recipe_id or not user_msg:
                await websocket.send_text(json.dumps({"error": "Missing recipeId or message"}))
                continue

            memory = get_memory(recipe_id)
            recipe_text = get_recipe_context(recipe_id, user_msg)
            chat_history = build_chat_history(system_prompt, recipe_text, memory, user_msg)

            await websocket.send_text(json.dumps({"stream_start": True}))
            full_response = ""

            async for chunk in llm_stream(chat_history):
                if chunk:
                    full_response += chunk
                    await websocket.send_text(json.dumps({"delta": chunk}))
                    await asyncio.sleep(0.03)

            await websocket.send_text(json.dumps({"stream_end": True}))

            memory.extend([
                {"role": "user", "content": user_msg},
                {"role": "assistant", "content": full_response}
            ])
            save_memory(recipe_id, memory)

    except WebSocketDisconnect:
        print("[WS] Disconnected")

@router.post("/generate_recipe")
async def generate_recipe(data: RecipeIdea):
    prompt = generate_recipe_prompt(data.idea)
    response = await run_in_threadpool(lambda: llm.invoke([
        SystemMessage(content=generate_recipe_system_prompt),
        HumanMessage(content=prompt)
    ]))
    print("Prompt used:\n", prompt)
    return {"recipe": response.content}