local config = {
    apiUrl = settings.get("pi_api_url") or "https://ollama.com",
    apiKey = settings.get("pi_api_key") or "",
    model = settings.get("pi_model") or "gemma4:31b",
    thinking = settings.get("pi_thinking") ~= nil and settings.get("pi_thinking") or true,
    thinkingBudget = settings.get("pi_thinking_budget") or 8000,
    systemPrompt = ""
}

-- Helper functions for the agent
local readFiles = {}
function read(path)
    if not fs.exists(path) then return "Error: File " .. path .. " does not exist." end
    local file = fs.open(path, "r")
    if not file then return "Error: Could not open file " .. path end
    local content = file.readAll()
    file.close()
    readFiles[path] = true
    return content
end

function write(path, content)
    if fs.exists(path) and not readFiles[path] then
        return "Error: File must be read before it can be written to."
    end
    local file = fs.open(path, "w")
    if not file then return "Error: Could not open file " .. path .. " for writing." end
    file.write(content)
    file.close()
    return "Successfully wrote to " .. path
end

function run(command)
    local success = shell.run(command)
    return success and "Command executed successfully" or "Command failed"
end

local function formatSkillsForPrompt(skills)
    if not skills or #skills == 0 then return "" end
    local prompt = "\n\n<skills>\n\n"
    for _, skill in ipairs(skills) do
        prompt = prompt .. "- " .. (type(skill) == "table" and (skill.name or "Unknown Skill") or skill) .. "\n"
    end
    prompt = prompt .. "</skills>\n"
    return prompt
end

if not fs.exists("/.pi-agent/") then
    os.mkdir("/.pi-agent/")
end

local function getReadmePath() return "/.pi-agent/README.md" end
local function getDocsPath() return "/.pi-agent/docs/" end
local function getExamplesPath() return "/.pi-agent/examples/" end

function buildSystemPrompt(options)
    options = options or {}
    local customPrompt = options.customPrompt
    local selectedTools = options.selectedTools
    local toolSnippets = options.toolSnippets
    local promptGuidelines = options.promptGuidelines
    local appendSystemPrompt = options.appendSystemPrompt
    local cwd = options.cwd or shell.dir()
    local providedContextFiles = options.contextFiles or {}
    local providedSkills = options.skills or {}

    local promptCwd = cwd:gsub("\\", "/")

    local date = os.date("%Y-%m-%d")
    local appendSection = appendSystemPrompt and ("\n\n" .. appendSystemPrompt) or ""

    if customPrompt then
        local prompt = customPrompt
        if appendSection ~= "" then
            prompt = prompt .. appendSection
        end

        if #providedContextFiles > 0 then
            prompt = prompt .. "\n\n<project_context>\n\n"
            prompt = prompt .. "Project-specific instructions and guidelines:\n\n"
            for _, file in ipairs(providedContextFiles) do
                prompt = prompt .. string.format("<project_instructions path=\"%s\">\n%s\n</project_instructions>\n\n", file.path, file.content)
            end
            prompt = prompt .. "</project_context>\n"
        end

        local customPromptHasRead = not selectedTools or (function()
            for _, tool in ipairs(selectedTools) do if tool == "read" then return true end end
            return false
        end)()
 
        if customPromptHasRead and #providedSkills > 0 then
            prompt = prompt .. formatSkillsForPrompt(providedSkills)
        end

        prompt = prompt .. "\nCurrent date: " .. date
        prompt = prompt .. "\nCurrent working directory: " .. promptCwd

        return prompt
    end

    local readmePath = getReadmePath()
    local docsPath = getDocsPath()
    local examplesPath = getExamplesPath()

    local tools = selectedTools or {"read", "write", "run"}
    local visibleTools = {}
    for _, name in ipairs(tools) do
        if toolSnippets and toolSnippets[name] then
            table.insert(visibleTools, name)
        else
            -- Default descriptions if snippets are not provided
            local desc = ""
            if name == "read" then desc = "Read a file's content"
            elseif name == "write" then desc = "Write content to a file"
            elseif name == "run" then desc = "Run a shell command via shell.run"
            end
            if desc ~= "" then
                table.insert(visibleTools, name .. ": " .. desc)
            end
        end
    end

    local toolsList = "(none)"
    if #visibleTools > 0 then
        local list = {}
        for i, item in ipairs(visibleTools) do
            local name = item:match("^(.-):") or item
            if toolSnippets and toolSnippets[name] then
                table.insert(list, string.format("- %s: %s", name, toolSnippets[name]))
            else
                table.insert(list, "- " .. item)
            end
        end
        toolsList = table.concat(list, "\n")
    end

    local guidelinesList = {}
    local guidelinesSet = {}
    local function addGuideline(guideline)
        if guidelinesSet[guideline] then return end
        guidelinesSet[guideline] = true
        table.insert(guidelinesList, guideline)
    end

    if promptGuidelines then
        for _, guideline in ipairs(promptGuidelines) do
            local normalized = guideline:match("^%s*(.-)%s*$")
            if #normalized > 0 then
                addGuideline(normalized)
            end
        end
    end

    addGuideline("Be concise in your responses")
    addGuideline("Show file paths clearly when working with files")
    addGuideline("The only programming language you can use is Lua 5.1")
    addGuideline("Only use ASCII symbols available in docs/symbols.md")
    addGuideline("A write operation to an EXISTING file can ONLY be performed after a read operation on that file")
    addGuideline("Shell commands must be executed using the 'shell.run' function")

    local guidelines = ""
    for i, g in ipairs(guidelinesList) do
        guidelines = guidelines .. (i > 1 and "\n" or "") .. "- " .. g
    end

    local prompt = string.format([[You are an expert coding assistant operating inside pi, a coding agent harness. You are running inside a CraftOS Lua 5.1 environment (CC: Tweaked). You help users by reading files, executing commands, and writing new files.

Available functions you can call:
%s

In addition to the functions above, you may have access to other custom functions depending on the project.

Guidelines:
%s

Pi documentation (read only when the user asks about pi itself, its SDK, extensions, themes, skills, or TUI):
- Main documentation: %s
- Additional docs: %s
- Examples: %s (extensions, custom tools, SDK)
- When reading pi docs or examples, resolve docs/... under Additional docs and examples/... under Examples, not the current working directory
- When asked about: extensions (docs/extensions.md, examples/extensions/), themes (docs/themes.md), skills (docs/skills.md), prompt templates (docs/prompt-templates.md), TUI components (docs/tui.md), keybindings (docs/keybindings.md), SDK integrations (docs/sdk.md), custom providers (docs/custom-provider.md), adding models (docs/models.md), pi packages (docs/packages.md)
- When working on pi topics, read the docs and examples, and follow .md cross-references before implementing
- Always read pi .md files completely and follow links to related docs (e.g., tui.md for TUI API details)]], toolsList, guidelines, readmePath, docsPath, examplesPath)

    if appendSection ~= "" then
        prompt = prompt .. appendSection
    end

    if #providedContextFiles > 0 then
        prompt = prompt .. "\n\n<project_context>\n\n"
        prompt = prompt .. "Project-specific instructions and guidelines:\n\n"
        for _, file in ipairs(providedContextFiles) do
            prompt = prompt .. string.format("<project_instructions path=\"%s\">\n%s\n</project_instructions>\n\n", file.path, file.content)
        end
        prompt = prompt .. "</project_context>\n"
    end

    if hasRead and #providedSkills > 0 then
        prompt = prompt .. formatSkillsForPrompt(providedSkills)
    end

    prompt = prompt .. "\nCurrent date: " .. date
    prompt = prompt .. "\nCurrent working directory: " .. promptCwd

    return prompt
end

local executor = {}
function executor.execute(code)
    local output = {}
    local oldPrint = print
    print = function(...)
        local args = {...}
        for i = 1, #args do
            table.insert(output, tostring(args[i]))
        end
    end

    local func, err = load(code)
    if not func then
        print = oldPrint
        return false, "Syntax error: " .. err
    end

    local success, runtimeErr = pcall(func)
    print = oldPrint

    if not success then
        return false, "Runtime error: " .. runtimeErr
    end

    return true, #output > 0 and table.concat(output, "\n") or "Command executed successfully"
end

function executor.extractLua(text)
    local luaCode = {}
    for block in text:gmatch("```lua\n(.-)\n```") do
        table.insert(luaCode, block)
    end

    if #luaCode > 0 then
        return table.concat(luaCode, "\n")
    end
    return nil
end

local ollama = {}
function ollama.streamChat(messages, callback)
    local url = config.apiUrl .. "/api/chat"

    local payload = {
        model = config.model,
        messages = messages,
        stream = true,
        options = {
            num_predict = config.thinkingBudget
        }
    }

    local body = textutils.serializeJSON(payload)

    local headers = {}
    if config.apiKey and config.apiKey ~= "" then
        headers["Authorization"] = "Bearer " .. config.apiKey
    end

    local response = http.post(url, body, headers)
    if not response then
        return nil, "HTTP request failed"
    end

    local usage = nil
    while true do
        local line = response.readLine()
        if not line then break end
        local data = textutils.unserializeJSON(line)
        if data and data.message and data.message.content then
            callback(data.message.content)
        end
        if data and data.done then
            usage = data
            break
        end
    end
    response.close()
    return true, usage
end

local messages = {
    { role = "system", content = buildSystemPrompt(config) }
}

local chatName = "New Chat"
local history = {}
local scrollPos = 0

local tokenUp = 0
local tokenDown = 0
local totalTokens = 0
local contextSize = settings.get("pi_context_size") or 262

local spinnerFrames = {
  string.char(135),
  string.char(139),
  string.char(142),
  string.char(141)
}
local spinnerIdx = 1

local function getSpinner()
    spinnerIdx = (spinnerIdx % #spinnerFrames) + 1
    return spinnerFrames[spinnerIdx]
end

local function clearScreen()
    term.clear()
    term.setCursorPos(1, 1)
end

local function wrapText(text, width)
    local lines = {}
    for line in text:gmatch("[^\n]*\n?") do
        -- Strip trailing newline
        line = line:gsub("\n$", "")
        while #line > width do
            local lastSpace = line:sub(1, width):match(".+ ")
            if lastSpace then
                local pos = #lastSpace
                table.insert(lines, line:sub(1, pos))
                line = line:sub(pos + 1)
            else
                table.insert(lines, line:sub(1, width))
                line = line:sub(width + 1)
            end
        end
        table.insert(lines, line)
    end
    -- Remove trailing empty line if the whole message ended with \n
    if #lines > 0 and lines[#lines] == "" then
        table.remove(lines)
    end
    return lines
end

local lastMessageStart = 0

local function printMessage(sender, text)
    local w, _ = term.getSize()
    
    local color = colors.white
    local bgColor = colors.black
    if sender == "Pi" then
        color = colors.lightBlue
    elseif sender == "System" or sender == "Error" then
        color = colors.yellow
    end

    if sender == "You" then
        bgColor = colors.gray
    end

    local textStartIdx = #history + 1

    -- Mandatory black separator before EVERY message block to ensure distance
    table.insert(history, {
        text = string.rep(" ", w),
        color = colors.black,
        bgColor = colors.black,
        isDivider = false
    })
    textStartIdx = textStartIdx + 1

    -- Pre-text elements
    if sender == "System" or sender == "Error" then
        table.insert(history, {
            text = string.rep("-", w),
            color = colors.yellow,
            bgColor = colors.black,
            isDivider = true
        })
        textStartIdx = textStartIdx + 1
    elseif sender == "You" then
        table.insert(history, {
            text = string.rep(" ", w),
            color = color,
            bgColor = bgColor,
            isDivider = false
        })
        textStartIdx = textStartIdx + 1
    end

    local wrapped = wrapText(text, w)
    for _, line in ipairs(wrapped) do
        table.insert(history, {
            text = " " .. line,
            color = color,
            bgColor = bgColor,
            isDivider = false,
            isText = true
        })
    end

    -- Post-text elements
    if sender == "You" then
        table.insert(history, {
            text = string.rep(" ", w),
            color = color,
            bgColor = bgColor,
            isDivider = false
        })
    elseif sender == "System" or sender == "Error" then
        table.insert(history, {
            text = string.rep("-", w),
            color = colors.yellow,
            bgColor = colors.black,
            isDivider = true
        })
    end

    return textStartIdx
end

local function updateLastMessage(text, color, bgColor)
    local w, _ = term.getSize()
    
    if lastMessageStart == 0 then return end

    -- Remove everything from the start of the text block to the end
    -- (Since the end-blank-line and end-divider were added by printMessage,
    -- and we're currently in the middle of a stream, we need to keep the 
    -- trailing elements of the block if we want them.
    -- However, printMessage was called with "" at the start of streaming.
    -- So the structure was: [Pre-blank] [Empty Text] [Post-blank/Divider].
    -- We remove from textStartIdx onwards, and re-add the text, then re-add the post-elements.
    -- BUT, for simplicity in this implementation, the easiest way is to just
    -- replace the text lines and keep the surrounding structure.
    
    -- This is tricky because we don't know how many lines were removed.
    -- Let's use the `isText` flag we added.
    
    local currentIdx = lastMessageStart
    while currentIdx <= #history do
        if history[currentIdx] and history[currentIdx].isText then
            table.remove(history, currentIdx)
        else
            currentIdx = currentIdx + 1
        end
    end

    -- Re-wrap and add text
    local wrapped = wrapText(text, w)
    for _, line in ipairs(wrapped) do
        table.insert(history, {
            text = line,
            color = color,
            bgColor = bgColor,
            isDivider = false,
            isText = true
        })
    end
end

local function render(inputBuffer, status)
    clearScreen()
    local w, h = term.getSize()
    
    local availableH = h - 5
    local startIdx = #history - availableH + 1 - scrollPos
    if startIdx < 1 then startIdx = 1 end
    if startIdx > #history then startIdx = #history end

    for i = startIdx, math.min(#history, startIdx + availableH - 1) do
        if i > 0 then
            local line = history[i]
            term.setCursorPos(1, (i - startIdx) + 1)
            term.setBackgroundColor(line.bgColor or colors.black)
            term.setTextColor(line.color)
            
            if line.bgColor == colors.gray then
                term.write(line.text .. string.rep(" ", w - #line.text))
            else
                term.write(line.text)
            end
        end
    end

    term.setBackgroundColor(colors.black)

    -- Current Directory Line
    term.setCursorPos(1, h - 1)
    term.setTextColor(colors.gray)
    local cwd = "/" .. shell.dir()
    term.write(cwd)
    local cwdPadding = w - #cwd
    if cwdPadding > 0 then
        term.write(string.rep(" ", cwdPadding))
    end

    -- Status Line (Working...)
    term.setCursorPos(1, h - 4)
    term.setTextColor(colors.gray)
    if status then 
        local statusText = status
        if status == "Working..." then
            local label = config.thinking and "Thinking..." or "Working..."
            statusText = getSpinner() .. " " .. label
        end
        term.write(statusText)
        local padding = w - #statusText
        if padding > 0 then
            term.write(string.rep("-", padding))
        end
    else
        term.write(string.rep("-", w))
    end

    -- User Input Line
    term.setCursorPos(1, h - 3)
    term.setTextColor(colors.white)
    term.write((inputBuffer or "") .. string.char(127))
    local inputPadding = w - #((inputBuffer or "") .. "|" .. string.char(127))
    if inputPadding > 0 then
        term.write(string.rep(" ", inputPadding))
    end

    -- Lower Footer Divider
    term.setCursorPos(1, h - 2)
    term.setTextColor(colors.gray)
    term.write(string.rep("-", w))

    -- Stats / Model Line
    term.setCursorPos(1, h)
    term.setTextColor(colors.gray)
    
    local tokenText = string.format("%s %.1fk | %s %.1fk | %.1f/%dk", string.char(30), tokenUp/1000, string.char(31), tokenDown/1000, totalTokens/1000, contextSize)
    term.write(tokenText)
    
    -- Right align the model name
    local modelText = config.model
    term.setCursorPos(w - #modelText + 1, h)
    term.write(modelText)
end

local function getUserInput()
    local input = ""
    while true do
        local event = { os.pullEvent() }
        local e = event[1]
        if e == "char" then
            local char = event[2]
            input = input .. char
            render(input)
        elseif e == "key" then
            local key = event[2]
            if key == keys.enter then
                return input
            elseif key == keys.backspace then
                input = input:sub(1, -2)
                render(input)
            elseif key == keys.up then
                local _, h = term.getSize()
                local availableH = h - 5
                local maxScrollPos = math.max(0, #history - availableH)
                scrollPos = math.min(maxScrollPos, scrollPos + 1)
                render(input)
            elseif key == keys.down then
                scrollPos = math.max(0, scrollPos - 1)
                render(input)
            end
        end
    end
end

local function run()
    clearScreen()
    
    if config.apiKey == "" then
        printMessage("System", "Configuration missing! Please set your API KEY in the terminal using:")
        printMessage("System", "set pi_api_key <your-key>")
        printMessage("System", "Then restart the program.")
    else
        printMessage("System", "Welcome to Pi for CraftOS! How can I help you today?")
    end

    while true do
        render("")
        local input = getUserInput()
        if not input or input == "" then goto continue end
        if input == "/exit" or input == "/quit" then
            printMessage("System", "Goodbye!")
            render("")
            break
        elseif input:sub(1, 6) == "/name " then
            local newName = input:sub(7)
            if newName ~= "" then
                chatName = newName
                printMessage("System", "Chat renamed to: " .. chatName)
            else
                printMessage("System", "Please provide a name: /name <name>")
            end
            goto continue
        elseif input:sub(1, 7) == "/think " then
            local val = input:sub(8):lower()
            if val == "on" then
                config.thinking = true
                printMessage("System", "Thinking enabled")
            elseif val == "off" then
                config.thinking = false
                printMessage("System", "Thinking disabled")
            else
                printMessage("System", "Usage: /think <on|off>")
            end
            goto continue
        elseif input:sub(1, 8) == "/budget " then
            local val = tonumber(input:sub(9))
            if val then
                config.thinkingBudget = val
                printMessage("System", "Thinking budget set to " .. val)
            else
                printMessage("System", "Usage: /budget <number>")
            end
            goto continue
        end
        printMessage("You", input)
        table.insert(messages, { role = "user", content = input })
        scrollPos = 0
        
        render("", "Working...")
        lastMessageStart = printMessage("Pi", "")
        local fullResponse = ""
        local success, usage = ollama.streamChat(messages, function(chunk)
            fullResponse = fullResponse .. chunk
            updateLastMessage(fullResponse, colors.lightBlue, colors.black)
            render("", "Working...")
            os.sleep(0.1)
        end)
        
        if success then
            if usage then
                tokenUp = usage.prompt_eval_count or 0
                tokenDown = usage.eval_count or 0
                totalTokens = (usage.prompt_eval_count or 0) + (usage.eval_count or 0)
            end
            table.insert(messages, { role = "assistant", content = fullResponse })
            local code = executor.extractLua(fullResponse)
            if code then
                printMessage("System", "Executing Lua code...")
                local successExec, result = executor.execute(code)
                local executeMsg = successExec and ("Success: " .. result) or ("Error: " .. result)
                printMessage("System", executeMsg)
                table.insert(messages, { role = "user", content = "Execution result: " .. executeMsg })
                
                render("", "Working...")
                lastMessageStart = printMessage("Pi", "")
                local followUpFull = ""
                local successFollow, usageFollow = ollama.streamChat(messages, function(chunk)
                    followUpFull = followUpFull .. chunk
                    updateLastMessage(followUpFull, colors.lightBlue, colors.black)
                    render("", "Working...")
                    os.sleep(0.05)
                end)
                if usageFollow then
                    tokenUp = usageFollow.prompt_eval_count or 0
                    tokenDown = usageFollow.eval_count or 0
                    totalTokens = (usageFollow.prompt_eval_count or 0) + (usageFollow.eval_count or 0)
                end
                table.insert(messages, { role = "assistant", content = followUpFull })
            end
        else
            printMessage("Error", err or "Unknown error occurred")
        end
        ::continue::
    end
end

run()
