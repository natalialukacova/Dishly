import requests
def call_api(prompt, options, context):
    recipe_id = context.get("vars", {}).get("recipe_id", 1)
    message = context.get("vars", {}).get("message", "")
    try:
        r = requests.post("http://localhost:8000/chat", json={"recipe_id": recipe_id, "message": message}, timeout=120)
        r.raise_for_status()
        return {"output": r.json().get("response", ""), "tokenUsage": {"total": 0}}
    except Exception as e:
        return {"output": f"[ERROR] API call failed: {str(e)}", "tokenUsage": {"total": 0}}
