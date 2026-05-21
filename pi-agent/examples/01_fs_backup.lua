-- 01_fs_backup.lua
-- Purpose: Backup all files from one directory to another.
-- API Reference: https://tweaked.cc/fs.html

local sourceDir = "home"
local targetDir = "backup"

-- Ensure target directory exists
if not fs.exists(targetDir) then
    fs.makeDir(targetDir)
end

local function backupFiles()
    print("Backing up " .. sourceDir .. " to " .. targetDir .. "...")
    
    local files = fs.list(sourceDir)
    for _, file in ipairs(files) do
        local sourcePath = sourceDir .. "/" .. file
        local targetPath = targetDir .. "/" .. file
        
        if fs.isDir(sourcePath) then
            -- Simple recursion for one level of subdirectories
            if not fs.exists(targetPath) then
                fs.makeDir(targetPath)
            end
            -- For deeper recursion, a recursive function would be needed.
        else
            -- Use fs.copy: copies file from source to destination
            if fs.copy(sourcePath, targetPath) then
                print("Copied: " .. file)
            else
                print("Failed to copy: " .. file)
            end
        end
    end
    print("Backup complete.")
end

backupFiles()
