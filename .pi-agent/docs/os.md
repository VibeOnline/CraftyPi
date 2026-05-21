# OS API Reference

The `os` API allows interaction with the current computer's system state and event loop.

## Core Functions

### Event Management

- `os.pullEvent([filter])`: Yields execution until an event matches `filter`. Stops on `terminate`.
- `os.pullEventRaw([filter])`: Yields execution until an event matches `filter`. Allows handling `terminate` manually.
- `os.queueEvent(name, ...)`: Manually adds an event to the queue.

### Timing & Scheduling

- `os.sleep(time)`: Pauses execution for `time` seconds.
- `os.startTimer(time)`: Starts a timer. Returns timer ID. Fires `timer` event.
- `os.cancelTimer(token)`: Cancels a specific timer.
- `os.setAlarm(time)`: Sets a time-of-day alarm. Returns alarm ID. Fires `alarm` event.
- `os.cancelAlarm(token)`: Cancels a specific alarm.

### System Control

- `os.shutdown()`: Shuts down the computer.
- `os.reboot()`: Reboots the computer.
- `os.run(env, path, ...)`: Runs a program at `path` with environment `env`. Does NOT resolve shell names.

### Identity & State

- `os.getComputerID()`: Returns computer ID.
- `os.getComputerLabel()`: Returns computer label (or `nil`).
- `os.setComputerLabel(label)`: Sets or clears the computer label.
- `os.clock()`: Returns uptime in seconds.
- `os.version()`: Returns CraftOS version.

### Date & Time

- `os.time([locale])`: Returns hour in range [0.0, 24.0) for `ingame` (default), `utc`, or `local`.
- `os.day([locale])`: Returns days since epoch for `ingame` (default), `utc`, or `local`.
- `os.epoch([locale])`: Returns milliseconds since epoch for `ingame` (default), `utc`, or `local`.
- `os.date(format, [time])`: Formats a timestamp. Use `"*t"` or `"!*t"` for a table representation.

## Common Patterns

### Event Loop

```lua
while true do
    local event, ... = os.pullEvent()
    if event == "key" then
        -- handle key
    end
end
```

### Using Timers

```lua
local id = os.startTimer(5)
-- do other things
local event, timerId = os.pullEvent("timer")
if timerId == id then
    print("5 seconds passed!")
end
```
