# GPS API Reference

The `gps` API uses modems to determine the computer's (or turtle's) global coordinates in the Minecraft world.

## Core Functionality

- `gps.locate([timeout=2, [debug=false]])`: Attempts to retrieve the current X, Y, and Z coordinates.
  - **Returns**: `{x, y, z}` as numbers, or `nil` if the position could not be established.
  - `timeout`: Max time to wait for responses from GPS hosts.
  - `debug`: If `true`, prints debugging information to the terminal.

## Requirements

For `gps.locate` to work, there must be at least 4 GPS hosts (computers with modems running a GPS host program) within wireless range.

## Constants

- `gps.CHANNEL_GPS` (65534): The communication channel used for GPS requests and responses.
