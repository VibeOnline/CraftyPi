-- 02_redstone_toggle.lua
-- Purpose: Create a redstone clock (toggling a signal on/off).
-- API Reference: https://tweaked.cc/redstone.html

local side = "right"
local delay = 1 -- seconds

local function redstoneClock()
    print("Starting redstone clock on side: " .. side)
    print("Press Ctrl+T to terminate.")
    
    while true do
        -- Set signal to ON
        redstone.setOutput(side, true)
        print("Signal: ON")
        os.sleep(delay)
        
        -- Set signal to OFF
        redstone.setOutput(side, false)
        print("Signal: OFF")
        os.sleep(delay)
    end
end

redstoneClock()
