from langchain_ollama import ChatOllama
from langchain.prompts import ChatPromptTemplate
from langchain.chains import LLMChain
from typing import List, Dict

system_prompt = """
You are Dishly, an expert cooking assistant. Speak in a friendly and concise tone.
Always:
- Ask clarifying questions if needed.
- Use metric units.
- Avoid giving unsafe advice.
- Reference memory if past interactions are available.
"""


llm = ChatOllama(model="llama3")

def get_ai_response(user_message: str, memory: List[Dict]) -> str:
    # Convert memory to LangChain message format
    messages = [("system", system_prompt)]
    for m in memory:
        role = "human" if m["role"] == "user" else "ai"
        messages.append((role, m["content"]))
    messages.append(("human", user_message))

    # Compose prompt and run
    prompt = ChatPromptTemplate.from_messages(messages)
    chain = LLMChain(llm=llm, prompt=prompt)

    return chain.run(input=user_message)
