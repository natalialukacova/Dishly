import requests
def call_api(prompt, options, context):
    idea = context.get("vars", {}).get("idea", "")
    try:
        r = requests.post("http://localhost:8000/generate_recipe", json={"idea": idea}, timeout=120)
        r.raise_for_status()
        return {"output": r.json().get("recipe", ""), "tokenUsage": {"total": 0}}
    except Exception as e:
        return {"output": f"[ERROR] API call failed: {str(e)}", "tokenUsage": {"total": 0}}
