# CC: Tweaked API Overview

This document provides a high-level mapping of the CC: Tweaked environment.

## Global APIs (\_G)

The following tables are available globally in the environment:

- **fs**: Filesystem interaction (reading, writing, manipulating files/directories).
- **os**: System operations (timers, alarms, events, reboot/shutdown, computer IDs).
- **shell**: Command-line interface access and program execution.
- **term**: Terminal and monitor interaction (text output, ASCII graphics).
- **http**: Networking and HTTP requests.
- **peripheral**: Management and interaction with attached hardware.
- **textutils**: String formatting, serialization (JSON), and manipulation.
- **redstone**: Reading and writing redstone signals.
- **rednet**: Wireless communication between computers using modems.
- **parallel**: Running multiple Lua functions concurrently.
- **colors**: Color constants for terminal and redstone.
- **keys**: Key codes for keyboard events.
- **paintutils**: Drawing primitives (lines, pixels, images).
- **window**: Creating sub-terminals within the main terminal.

## Modules

Advanced functionality available via `require` or specific modules:

- **cc.base64**: Binary to Base64 conversion.
- **cc.expect**: Argument verification.
- **cc.pretty**: Data structure rendering.
- **cc.require**: Package loading implementation.

## Peripherals

Specialized hardware that can be wrapped via `peripheral.wrap()`:

- **computer/turtle**: Interacting with other computers/turtles.
- **drive**: Accessing floppy disks and mountable media.
- **modem**: Long-distance messaging.
- **monitor**: External displays.
- **printer**: Document printing.
- **speaker**: Audio playback.
- **inventory**: Generic item management (chests, etc).

## Key Events

Events can be captured via `os.pullEvent()` or `os.pullEventRaw()`:

- **char / key**: Keyboard input.
- **timer / alarm**: Time-based triggers.
- **http_success / http_failure**: Web request results.
- **peripheral / peripheral_detach**: Hardware changes.
- **rednet_message**: Wireless messages.
- **terminate**: Ctrl+T signal.
## Reference

- **symbols**: Available characters in the CraftOS character set.
