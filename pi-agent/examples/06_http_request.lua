-- 06_http_request.lua
-- Purpose: Fetch a simple page or API response from the web.
-- API Reference: https://tweaked.cc/http.html

local url = "http://google.com"

local function fetchPage()
    print("Fetching " .. url .. "...")
    
    -- http.get returns a response object and a header table
    local response = http.get(url)
    
    if response then
        print("Response received successfully.")
        -- Read the response content
        local content = response.readAll()
        print("Content length: " .. #content)
        print("First 100 characters: " .. string.sub(content, 1, 100))
        response.close()
    else
        print("HTTP request failed.")
    end
end

fetchPage()
