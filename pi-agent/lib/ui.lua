local ui = {}

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

function ui.clearScreen()
    term.clear()
    term.setCursorPos(1, 1)
end

function ui.wrapText(text, width)
    local lines = {}
    for line in text:gmatch("[^\n]*\n?") do
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
    if #lines > 0 and lines[#lines] == "" then
        table.remove(lines)
    end
    return lines
end

function ui.printMessage(sender, text, history)
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

    table.insert(history, {
        text = string.rep(" ", w),
        color = colors.black,
        bgColor = colors.black,
        isDivider = false
    })
    textStartIdx = textStartIdx + 1

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

    local wrapped = ui.wrapText(text, w)
    for _, line in ipairs(wrapped) do
        table.insert(history, {
            text = " " .. line,
            color = color,
            bgColor = bgColor,
            isDivider = false,
            isText = true
        })
    end

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

function ui.printBlock(text, color, history)
    local w, _ = term.getSize()
    local wrapped = ui.wrapText(text, w - 2)
    
    -- Pre-block padding
    table.insert(history, {
        text = string.rep(" ", w),
        color = colors.black,
        bgColor = colors.black,
        isDivider = false
    })

    -- Top border line
    table.insert(history, {
        text = string.rep(" ", w),
        color = colors.black,
        bgColor = color,
        isDivider = false,
        isText = false
    })

    for _, line in ipairs(wrapped) do
        table.insert(history, {
            text = " " .. line .. string.rep(" ", w - #line - 1),
            color = colors.white,
            bgColor = color,
            isDivider = false,
            isText = true
        })
    end
    
    -- Bottom border line
    table.insert(history, {
        text = string.rep(" ", w),
        color = colors.black,
        bgColor = color,
        isDivider = false,
        isText = false
    })

    -- Post-block padding
    table.insert(history, {
        text = string.rep(" ", w),
        color = colors.black,
        bgColor = colors.black,
        isDivider = false
    })
end

function ui.updateLastMessage(text, color, bgColor, history, lastMessageStart)
    if lastMessageStart == 0 then return end
    local w, _ = term.getSize()
    
    local currentIdx = lastMessageStart
    while currentIdx <= #history do
        if history[currentIdx] and history[currentIdx].isText then
            table.remove(history, currentIdx)
        else
            currentIdx = currentIdx + 1
        end
    end

    local wrapped = ui.wrapText(text, w)
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

function ui.render(inputBuffer, status, history, scrollPos, config, stats)
    ui.clearScreen()
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

    term.setCursorPos(1, h - 1)
    term.setTextColor(colors.gray)
    local cwd = "/" .. shell.dir()
    term.write(cwd)
    local cwdPadding = w - #cwd
    if cwdPadding > 0 then
        term.write(string.rep(" ", cwdPadding))
    end

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

    term.setCursorPos(1, h - 3)
    term.setTextColor(colors.white)
    term.write((inputBuffer or "") .. string.char(127))
    local inputPadding = w - #((inputBuffer or "") .. "|" .. string.char(127))
    if inputPadding > 0 then
        term.write(string.rep(" ", inputPadding))
    end

    term.setCursorPos(1, h - 2)
    term.setTextColor(colors.gray)
    term.write(string.rep("-", w))

    term.setCursorPos(1, h)
    term.setTextColor(colors.gray)
    
    local tUp = stats and stats.up or 0
    local tDown = stats and stats.down or 0
    local tTotal = stats and stats.total or 0
    local tokenText = string.format("%s %.1fk | %s %.1fk | %.1f/%dk", string.char(30), tUp/1000, string.char(31), tDown/1000, tTotal/1000, config.contextSize)
    term.write(tokenText)
    
    local modelText = config.model
    term.setCursorPos(w - #modelText + 1, h)
    term.write(modelText)
end

function ui.getUserInput(renderCallback)
    local input = ""
    while true do
        local event = { os.pullEvent() }
        local e = event[1]
        if e == "char" then
            local char = event[2]
            input = input .. char
            renderCallback(input)
        elseif e == "key" then
            local key = event[2]
            if key == keys.enter then
                return input
            elseif key == keys.backspace then
                input = input:sub(1, -2)
                renderCallback(input)
            elseif key == keys.up then
                return "SCROLL_UP"
            elseif key == keys.down then
                return "SCROLL_DOWN"
            end
        end
    end
end

return ui
