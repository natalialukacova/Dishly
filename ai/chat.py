from typing import List, Dict
from langchain.schema import AIMessage, HumanMessage, SystemMessage
import asyncio
from starlette.concurrency import run_in_threadpool
from llm import llm

def build_chat_history(system_prompt: str, recipe_text: str, memory: List[Dict], user_message: str):
    history = [
        SystemMessage(content=system_prompt),
        HumanMessage(content=f"Here is the recipe context:\n{recipe_text}")
    ]
    for m in memory:
        if m["role"] == "user":
            history.append(HumanMessage(content=m["content"]))
        elif m["role"] == "assistant":
            history.append(AIMessage(content=m["content"]))
    history.append(HumanMessage(content=user_message))
    return history

async def get_ai_response(system_prompt: str, user_message: str, memory: List[Dict], recipe_text: str) -> str:
    chat_history = build_chat_history(system_prompt, recipe_text, memory, user_message)
    try:
        result = await asyncio.wait_for(
            run_in_threadpool(lambda: llm.invoke(chat_history)),
            timeout=30
        )
        return result.content if hasattr(result, "content") else str(result)
    except asyncio.TimeoutError:
        return "Sorry, I took too long to think. Could you try again?"

async def llm_stream(chat_history):
    for chunk in llm.stream(chat_history):  
        if hasattr(chunk, "content"):
            yield chunk.content
        await asyncio.sleep(0.01)
