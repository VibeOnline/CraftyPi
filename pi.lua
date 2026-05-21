local config = require("pi-agent.lib.config")
local api = require("pi-agent.lib.api")
local prompt = require("pi-agent.lib.prompt")
local executor = require("pi-agent.lib.executor")
local ui = require("pi-agent.lib.ui")
local commands = require("pi-agent.lib.commands")

local messages = {
    { role = "system", content = prompt.build(config) }
}

local chatName = "New Chat"
local history = {}
local scrollPos = 0

local tokenUp = 0
local tokenDown = 0
local totalTokens = 0

local lastMessageStart = 0

local function updateTokenStats(usage)
    if usage then
        tokenUp = usage.prompt_eval_count or 0
        tokenDown = usage.eval_count or 0
        totalTokens = (usage.prompt_eval_count or 0) + (usage.eval_count or 0)
    end
end

local function renderWithStats(inputBuffer, status)
    ui.render(inputBuffer, status, history, scrollPos, config, {
        up = tokenUp,
        down = tokenDown,
        total = totalTokens
    })
end

local function processRequest(input, messages, history, isCli)
    if not isCli then
        ui.printMessage("You", input, history)
    end
    table.insert(messages, { role = "user", content = input })
    
    if not isCli then
        renderWithStats("", "Working...")
        lastMessageStart = ui.printMessage("Pi", "", history)
    end

    local isFirstTurn = true
    while true do
        local fullResponse = ""
        local success, usage = api.streamChat(messages, function(chunk)
            fullResponse = fullResponse .. chunk
            if isCli then
                term.write(chunk)
            else
                ui.updateLastMessage(fullResponse, colors.lightBlue, colors.black, history, lastMessageStart)
                renderWithStats("", "Working...")
                os.sleep(0.1)
            end
        end)
        
        if isCli then term.write("\n") end

        if not success then
            if isCli then
                term.write("\nError: Unknown error occurred\n")
            else
                ui.printMessage("Error", "Unknown error occurred", history)
            end
            break
        end

        if not isCli then updateTokenStats(usage) end
        table.insert(messages, { role = "assistant", content = fullResponse })
        
        local code = executor.extractLua(fullResponse)
        if not code then
            break
        end

        local successExec, result = executor.execute(code)
        local containsError = not successExec or (type(result) == "string" and result:find("^Error:"))
        local executeMsg = result or "Unknown error"
        
        if isCli then
            term.write("\nExecution result:\n" .. executeMsg .. "\n")
        else
            ui.printBlock(executeMsg, containsError and colors.red or colors.green, history)
        end
        
        table.insert(messages, { role = "user", content = "Execution result: " .. executeMsg })
        
        if not isCli then
            renderWithStats("", "Working...")
            lastMessageStart = ui.printMessage("Pi", "", history)
        end
        
        isFirstTurn = false
    end
end

local function run()
    ui.clearScreen()
    
    if config.apiKey == "" then
        ui.printMessage("System", "Configuration missing! Please set your API KEY in the terminal using:", history)
        ui.printMessage("System", "set pi_api_key <your-key>", history)
        ui.printMessage("System", "Then restart the program.", history)
    else
        ui.printMessage("System", "Welcome to Pi for CraftOS! How can I help you today?", history)
    end

    while true do
        renderWithStats("", "")
        
        local input = ui.getUserInput(function(currentInput)
            renderWithStats(currentInput, "")
        end)

        if not input or input == "" then goto continue end
        
        if input == "SCROLL_UP" then
            local _, h = term.getSize()
            local availableH = h - 5
            local maxScrollPos = math.max(0, #history - availableH)
            scrollPos = math.min(maxScrollPos, scrollPos + 1)
            goto continue
        elseif input == "SCROLL_DOWN" then
            scrollPos = math.max(0, scrollPos - 1)
            goto continue
        end

        local cmdResult = commands.handle(input, history, config)
        if cmdResult == "EXIT" then
            ui.printMessage("System", "Goodbye!", history)
            renderWithStats("", "")
            break
        elseif type(cmdResult) == "table" and cmdResult.action == "RENAME" then
            chatName = cmdResult.value
            ui.printMessage("System", "Chat renamed to: " .. chatName, history)
            goto continue
        elseif cmdResult ~= nil then
            goto continue
        end

        scrollPos = 0
        processRequest(input, messages, history, false)
        ::continue::
    end
end

if #arg > 0 then
    local input = table.concat(arg, " ")
    local cliMessages = {
        { role = "system", content = prompt.build(config) }
    }
    processRequest(input, cliMessages, {}, true)
else
    run()
end
