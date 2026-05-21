local config = require("pi-agent.lib.config")

local prompt = {}

local function formatSkillsForPrompt(skills)
    if not skills or #skills == 0 then return "" end
    local p = "\n\n<skills>\n\n"
    for _, skill in ipairs(skills) do
        p = p .. "- " .. (type(skill) == "table" and (skill.name or "Unknown Skill") or skill) .. "\n"
    end
    p = p .. "</skills>\n"
    return p
end

local function getReadmePath() return "pi-agent/README.md" end
local function getDocsPath() return "pi-agent/docs/" end
local function getExamplesPath() return "pi-agent/examples/" end

function prompt.build(options)
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
        local p = customPrompt
        if appendSection ~= "" then
            p = p .. appendSection
        end

        if #providedContextFiles > 0 then
            p = p .. "\n\n<project_context>\n\n"
            p = p .. "Project-specific instructions and guidelines:\n\n"
            for _, file in ipairs(providedContextFiles) do
                p = p .. string.format("<project_instructions path=\"%s\">\n%s\n</project_instructions>\n\n", file.path, file.content)
            end
            p = p .. "</project_context>\n"
        end

        local customPromptHasRead = not selectedTools or (function()
            for _, tool in ipairs(selectedTools) do if tool == "read" then return true end end
            return false
        end)()
 
        if customPromptHasRead and #providedSkills > 0 then
            p = p .. formatSkillsForPrompt(providedSkills)
        end

        p = p .. "\nCurrent date: " .. date
        p = p .. "\nCurrent working directory: " .. promptCwd

        return p
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
    addGuideline("To use any tool, you MUST wrap the function call inside a markdown Lua code block (```lua\n ... \n```)")
    addGuideline("Only use the tool that is actually required for the request. For example, do not use the 'write' tool if the user only asked for a command to be run.")
    addGuideline("Call tools directly. Do not attempt to create complex Lua scripts, loops, or logic to manage tool outputs. Call the tool, let the system return the result, and then react to that result in your next message.")

    local guidelines = ""
    for i, g in ipairs(guidelinesList) do
        guidelines = guidelines .. (i > 1 and "\n" or "") .. "- " .. g
    end

    local p = string.format([[You are an expert coding assistant operating inside pi, a coding agent harness. You are running inside a CraftOS Lua 5.1 environment (CC: Tweaked). You help users by reading files, executing commands, and writing new files.

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
        p = p .. appendSection
    end

    if #providedContextFiles > 0 then
        p = p .. "\n\n<project_context>\n\n"
        p = p .. "Project-specific instructions and guidelines:\n\n"
        for _, file in ipairs(providedContextFiles) do
            p = p .. string.format("<project_instructions path=\"%s\">\n%s\n</project_instructions>\n\n", file.path, file.content)
        end
        p = p .. "</project_context>\n"
    end

    -- Note: there was a bug in original code where 'hasRead' was used but not defined.
    -- I'll use customPromptHasRead if needed, or just check if it's general.
    -- The original had: if hasRead and #providedSkills > 0 then
    -- Based on the logic above, hasRead probably meant "the prompt has a read tool".
    -- I'll fix it to use customPromptHasRead.
    if customPromptHasRead and #providedSkills > 0 then
        p = p .. formatSkillsForPrompt(providedSkills)
    end

    p = p .. "\nCurrent date: " .. date
    p = p .. "\nCurrent working directory: " .. promptCwd

    return p
end

return prompt
