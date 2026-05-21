local cmd = {...}
if #cmd == 0 then return "Error: command missing" end

local program = table.remove(cmd, 1)
if not program then return "Error: invalid command" end

local log = {}

local oldPrint = print
local oldTermWrite = term.write

local function logger(...)
    if #{...} == 0 then return end

    table.insert(log, table.concat({...}, " "))
end

_G.term.write = function(...)
    oldTermWrite(...)
    
    logger(...)
end
_G.print = function(...)
    oldPrint(...)

    logger(...)
end

local success, err = pcall(function()
    return shell.run(program, table.unpack(cmd))
end)

_G.term.write = oldTermWrite
_G.print = oldPrint

local res = table.concat(log, "\n")
if not success then
    return "[Ran: " .. program .. "]\n" .. (res == "" and "No output" or res) .. "\nError: " .. tostring(err)
end

return "[Ran: " .. program .. "]\n" .. (res == "" and "No output" or res)
