from fastapi import FastAPI
from api_routes import router as app_router

app = FastAPI()
app.include_router(app_router)

@app.get("/")
def root():
    return {"message": "AI backend is running"}