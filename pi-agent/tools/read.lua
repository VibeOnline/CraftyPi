local path = ...
if not path then return "Error: path missing" end
if not fs.exists(path) then return "Error: file not found: " .. path end
local f = fs.open(path, "r")
local res = f.readAll()
f.close()
return "[Read " .. path .. "]\n" .. res
