-- 03_rednet_chat.lua
-- Purpose: Simple broadcast and receive system.
-- API Reference: https://tweaked.cc/rednet.html

local modemSide = "back"

local function setupNetwork()
    local modem = peripheral.find("modem")
    if not modem then
        error("No modem found!")
    end
    rednet.open(modem)
    print("Rednet opened on modem.")
end

local function startChat()
    print("Chat started. Use 'msg [text]' to broadcast.")
    
    while true do
        -- We use parallel.waitForAny to handle input and messages simultaneously,
        -- but for this simple demo, we'll poll for input.
        -- Note: In a real app, use parallel.waitForAny.
        
        local event, param1, param2, param3 = os.pullEvent()
        
        if event == "key" then
            -- This is a simplified model. Real shells use shell.read().
            print("Key pressed. (Implement shell.read for full chat)")
        elseif event == "rednet_message" then
            local senderId = param1
            local message = param2
            local protocol = param3
            print(string.format("[%d]: %s", senderId, message))
        end
    end
end

setupNetwork()
startChat()
