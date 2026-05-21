-- 05_parallel_input.lua
-- Purpose: Monitor redstone input while waiting for a user key press.
-- API Reference: https://tweaked.cc/parallel.html

local side = "left"

local function monitorRedstone()
    while true do
        local input = redstone.getInput(side)
        if input then
            print("Redstone signal detected on " .. side)
        end
        -- Parallel tasks must yield to allow the other to run.
        os.sleep(0.5)
    end
end

local function waitForKey()
    while true do
        print("Waiting for any key press...")
        os.pullEvent("key")
        print("Key pressed! Terminating monitor.")
        break
    end
end

-- parallel.waitForAny executes functions and stops when the first one returns.
parallel.waitForAny(
    monitorRedstone,
    waitForKey
)

print("Program finished.")
