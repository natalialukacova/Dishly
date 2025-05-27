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
        f"Create a complete and realistic recipe based on this idea: '{idea}'.\n\n"
        f"Respond using **exactly this format**:\n\n"
        f"### Title\n\n"
        f"### Ingredients\n"
        f"- Ingredient 1\n"
        f"- Ingredient 2\n\n"
        f"### Instructions\n"
        f"1. Step one\n"
        f"2. Step two\n\n"
        f"Use metric units and do not skip any sections."
    )