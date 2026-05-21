-- 04_gps_locate.lua
-- Purpose: Retrieve and display world coordinates.
-- API Reference: https://tweaked.cc/gps.html

local function trackPosition()
    print("Attempting to locate GPS...")
    
    -- gps.locate() returns x, y, z or nil if it fails
    local x, y, z = gps.locate()
    
    if x then
        print(string.format("Current Position: X=%d, Y=%d, Z=%d", x, y, z))
    else
        print("GPS location failed. Ensure 4+ GPS hosts are in range.")
    end
end

trackPosition()
