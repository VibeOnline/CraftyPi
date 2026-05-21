local ToolManager = {}

local readFiles = {}

function ToolManager.call(toolName, ...)
    local args = {...}
    local toolPath = "pi-agent/tools/" .. toolName .. ".lua"
    
    if not fs.exists(toolPath) then
        return "Error: Tool " .. toolName .. " not found at " .. toolPath
    end

    -- Special logic for 'write' safety check from original pi.lua
    if toolName == "write" then
        local path = args[1]
        if path and fs.exists(path) and not readFiles[path] then
            return "Error: File must be read before it can be written to."
        end
    end

    -- Record read access
    if toolName == "read" then
        local path = args[1]
        if path then readFiles[path] = true end
    end

    local toolFunc, err = loadfile(toolPath)
    if not toolFunc then
        return "Error loading tool " .. toolName .. ": " .. tostring(err)
    end

    -- Call the tool function with the arguments.
    -- In CraftOS, for the values to be available as '...' in the tool script,
    -- we must call the chunk function with the arguments.
    local success, result = pcall(toolFunc, table.unpack(args))
    if not success then
        return "Error executing tool " .. toolName .. ": " .. tostring(result)
    end
    
    return result

end

return ToolManager
