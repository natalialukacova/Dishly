system_prompt = """
You are Dishly, a concise cooking assistant.
- Answer in 1-3 sentences.
- Use metric units.
- Reference the recipe when helpful.
- Avoid vague or unsafe advice.
"""

generate_recipe_system_prompt = """
You are Dishly, a creative AI chef.
- Generate full, complete recipes.
- Use metric units for all ingredients.
- Provide structured output with title, ingredients, and instructions.
- Be clear, practical, and friendly.
"""

def generate_recipe_prompt(idea: str) -> str:
    return (
        f"Create a complete recipe based on this idea:\n'{idea}'.\n\n"
        f"Respond in this format:\n\n"
        f"### Title\n"
        f"Recipe Title\n\n"
        f"### Ingredients\n"
        f"- List all ingredients with metric units\n\n"
        f"### Instructions\n"
        f"1. Step-by-step instructions"
    )