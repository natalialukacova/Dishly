from langchain_ollama import ChatOllama
from langchain.callbacks.streaming_stdout import StreamingStdOutCallbackHandler
from config import OLLAMA_MODEL_NAME


llm = ChatOllama(
    model=OLLAMA_MODEL_NAME,
    streaming=True,
    callbacks=[StreamingStdOutCallbackHandler()]
)