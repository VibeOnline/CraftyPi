local config = require("pi-agent.lib.config")
local ui = require("pi-agent.lib.ui")

local CommandManager = {}

function CommandManager.handle(input, history, config)
    if input == "/exit" or input == "/quit" then
        return "EXIT"
    elseif input:sub(1, 6) == "/name " then
        local newName = input:sub(7)
        if newName ~= "" then
            -- Note: chatName is local to main, so we return the new name and action
            return { action = "RENAME", value = newName }
        else
            ui.printMessage("System", "Please provide a name: /name <name>", history)
        end
    elseif input:sub(1, 7) == "/think " then
        local val = input:sub(8):lower()
        if val == "on" then
            config.thinking = true
            ui.printMessage("System", "Thinking enabled", history)
        elseif val == "off" then
            config.thinking = false
            ui.printMessage("System", "Thinking disabled", history)
        else
            ui.printMessage("System", "Usage: /think <on|off>", history)
        end
    elseif input:sub(1, 8) == "/budget " then
        local val = tonumber(input:sub(9))
        if val then
            config.thinkingBudget = val
            ui.printMessage("System", "Thinking budget set to " .. val, history)
        else
            ui.printMessage("System", "Usage: /budget <number>", history)
        end
    end
    return nil
end

return CommandManager
