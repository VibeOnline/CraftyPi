local cmd = ...
if not cmd then return "Error: command missing" end

local words = {}
for word in cmd:gmatch("%S+") do
    table.insert(words, word)
end

local program = table.remove(words, 1)
if not program then return "Error: invalid command" end

local log = {}
local oldPrint = print
print = function(...)
    local args = {...}
    table.insert(log, table.concat(args, "\t"))
end

local success, err = pcall(function()
    return shell.run(program, unpack(words))
end)

print = oldPrint

local res = table.concat(log, "\n")
if not success then
    return "[Ran: " .. cmd .. "]\n" .. (res == "" and "No output" or res) .. "\nError: " .. tostring(err)
end

return "[Ran: " .. cmd .. "]\n" .. (res == "" and "No output" or res)
