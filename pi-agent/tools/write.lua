local path, content = ...
if not path or not content then return "Error: path/content missing" end
local f = fs.open(path, "w")
f.write(content)
f.close()
return "[Wrote to " .. path .. "]"
