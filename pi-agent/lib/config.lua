local config = {
    apiUrl = settings.get("pi_api_url") or "https://ollama.com",
    apiKey = settings.get("pi_api_key") or "",
    model = settings.get("pi_model") or "gemma4:31b",
    thinking = settings.get("pi_thinking") ~= nil and settings.get("pi_thinking") or true,
    thinkingBudget = settings.get("pi_thinking_budget") or 8000,
    contextSize = settings.get("pi_context_size") or 262,
}

return config
