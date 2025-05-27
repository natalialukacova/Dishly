from pydantic import BaseModel

class ChatMessage(BaseModel):
    recipe_id: int
    message: str

class RecipeContext(BaseModel):
    recipe_id: int
    recipe_text: str

class RecipeIdea(BaseModel):
    idea: str