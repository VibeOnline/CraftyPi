-- install.lua
-- Installer for the Pi Coding Agent
-- Usage: Run this file via 'lua' or 'shell.run' after downloading.

local BASE_URL = "https://raw.githubusercontent.com/VibeOnline/CraftyPi/main/"

local FILES = {
    "pi.lua",
    "pi-agent/README.md",
    "pi-agent/docs/api_overview.md",
    "pi-agent/docs/colors.md",
    "pi-agent/docs/fs.md",
    "pi-agent/docs/gps.md",
    "pi-agent/docs/http.md",
    "pi-agent/docs/keys.md",
    "pi-agent/docs/os.md",
    "pi-agent/docs/paintutils.md",
    "pi-agent/docs/parallel.md",
    "pi-agent/docs/rednet.md",
    "pi-agent/docs/redstone.md",
    "pi-agent/docs/shell.md",
    "pi-agent/docs/symbols.md",
    "pi-agent/docs/term.md",
    "pi-agent/docs/tui.md",
    "pi-agent/docs/textutils.md",
    "pi-agent/docs/window.md",
    "pi-agent/examples/README.md",
    "pi-agent/examples/01_fs_backup.lua",
    "pi-agent/examples/02_redstone_toggle.lua",
    "pi-agent/examples/03_rednet_chat.lua",
    "pi-agent/examples/04_gps_locate.lua",
    "pi-agent/examples/05_parallel_input.lua",
    "pi-agent/examples/06_http_request.lua",
    "pi-agent/lib/api.lua",
    "pi-agent/lib/commands.lua",
    "pi-agent/lib/config.lua",
    "pi-agent/lib/executor.lua",
    "pi-agent/lib/prompt.lua",
    "pi-agent/lib/tools.lua",
    "pi-agent/lib/ui.lua",
    "pi-agent/tools/read.lua",
    "pi-agent/tools/run.lua",
    "pi-agent/tools/write.lua",
}

local function createDirRecursive(path)
    local parts = {}
    for part in path:gmatch("[^/]+") do
        table.insert(parts, part)
    end

    local currentPath = ""
    for i = 1, #parts do
        currentPath = currentPath == "" and parts[i] or currentPath .. "/" .. parts[i]
        if not fs.exists(currentPath) then
            fs.makeDir(currentPath)
        end
    end
end

local function install()
    term.clear()
    term.setCursorPos(1, 1)
    term.setTextColor(colors.lightBlue)
    print("========================================")
    print("   Pi Coding Agent Installation")
    print("========================================")
    term.setTextColor(colors.white)
    print("\nFetching files from: " .. BASE_URL)
    print("----------------------------------------\n")

    for i, path in ipairs(FILES) do
        -- Calculate progress percentage
        local progress = math.floor((i / #FILES) * 100)
        
        -- Update status line
        term.setCursorPos(1, 6)
        term.clearLine()
        print(string.format("[%3d%%] Downloading %s...", progress, path))

        -- Ensure directory exists
        local dir = path:match("(.*)/")
        if dir then
            createDirRecursive(dir)
        end

        -- Download file
        local success, response = pcall(http.get, BASE_URL .. path)
        
        if not success or not response then
            term.setCursorPos(1, 7)
            term.setTextColor(colors.red)
            print("\nERROR: Failed to download " .. path)
            print("Please check your BASE_URL and internet connection.")
            return false
        end

        -- Read content from response handle
        local content = response.readAll()
        response.close()

        -- Save file
        local file = fs.open(path, "w")
        file.write(content)
        file.close()
    end

    term.setCursorPos(1, 7)
    term.setTextColor(colors.green)
    print("\n\nInstallation Complete!")
    term.setTextColor(colors.white)
    print("You can now start the agent by running:")
    print("\n    pi\n")
    print("----------------------------------------")
    return true
end

-- Run the installer
local success = install()
if not success then
    term.setTextColor(colors.white)
    print("\nInstallation failed. Review the errors above.")
end
