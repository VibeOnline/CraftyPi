local config = require("pi-agent.lib.config")

local api = {}

function api.streamChat(messages, callback)
    local url = config.apiUrl .. "/api/chat"

    local payload = {
        model = config.model,
        messages = messages,
        stream = true,
        options = {
            num_predict = config.thinkingBudget
        }
    }

    local body = textutils.serializeJSON(payload)

    local headers = {}
    if config.apiKey and config.apiKey ~= "" then
        headers["Authorization"] = "Bearer " .. config.apiKey
    end

    local response = http.post(url, body, headers)
    if not response then
        return nil, "HTTP request failed"
    end

    local usage = nil
    while true do
        local line = response.readLine()
        if not line then break end
        local data = textutils.unserializeJSON(line)
        if data and data.message and data.message.content then
            callback(data.message.content)
        end
        if data and data.done then
            usage = data
            break
        end
    end
    response.close()
    return true, usage
end

return api
