local tools = require("pi-agent.lib.tools")

local executor = {}

local function getAvailableTools()
    local toolList = {}
    local files = fs.list("pi-agent/tools") or {}
    for _, fileName in ipairs(files) do
        if fileName:match("%.lua$") then
            local toolName = fileName:gsub("%.lua$", "")
            toolList[toolName] = function(...)
                local args = {...}
                -- Log the action to the executor's output buffer
                print(string.format("%s %s", toolName, table.concat(args, " ")))
                
                local result = tools.call(toolName, ...)
                
                -- Log the result to the output buffer so it's visible in the UI
                if result then
                    print(tostring(result))
                end
                return result
            end
        end
    end
    return toolList
end

function executor.execute(code)
    local output = {}
    local oldPrint = print
    print = function(...)
        local args = {...}
        for i = 1, #args do
            table.insert(output, tostring(args[i]))
        end
    end

    -- Discover and inject tool functions
    local toolFunctions = getAvailableTools()
    for name, func in pairs(toolFunctions) do
        _G[name] = func
    end

    -- Ensure CraftOS globals are available in the environment
    -- In some cases, chunks loaded via loadfile might not see _G if
    -- they are executed in a specific way. We'll make sure shell/fs are present.
    _G.shell = shell
    _G.fs = fs
    _G.term = term
    _G.textutils = textutils
    _G.os = os
    _G.colors = colors

    local func, err = load(code)
    if not func then
        print = oldPrint
        for name, _ in pairs(toolFunctions) do _G[name] = nil end
        return false, "Syntax error: " .. err
    end

    local success, runtimeErr = pcall(func)
    print = oldPrint
    for name, _ in pairs(toolFunctions) do _G[name] = nil end

    if not success then
        return false, "Runtime error: " .. runtimeErr
    end

    return true, #output > 0 and table.concat(output, "\n") or "Command executed successfully"
end

function executor.extractLua(text)
    local luaCode = {}
    -- Match blocks: ```[lang] [code] ```
    -- %s* matches optional whitespace, (.-) captures the code non-greedily
    for lang, block in text:gmatch("```([%a]*)%s*(.-)%s*```") do
        if lang == "" or lang == "lua" then
            -- Trim leading/trailing newlines from the captured block
            local cleaned = block:gsub("^%s*\n", ""):gsub("\n%s*$", "")
            table.insert(luaCode, cleaned)
        end
    end

    if #luaCode > 0 then
        return table.concat(luaCode, "\n")
    end
    return nil
end

return executor
