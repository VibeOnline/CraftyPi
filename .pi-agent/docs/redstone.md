# Redstone API Reference

The `redstone` API (also accessible as `rs`) allows you and interact with redstone signals on the sides of the computer.

## Signal Types

### 1. Binary Level (On/Off)

Used for simple logic triggers.

- `redstone.setOutput(side, on)`: Sets the redstone signal of `side` to on (`true`) or off (`false`). When on, signal strength is 15.
- `redstone.getInput(side)`: Returns `true` if the signal on `side` is on, `false` otherwise.
- `redstone.getOutput(side)`: Returns `true` if the computer is currently outputting a signal on `side`.

### 2. Analog Level (0-15)

Used for signal strength modulation.

- `redstone.setAnalogOutput(side, value)`: Sets the signal strength on `side` (range: 0 to 15).
- `redstone.getAnalogInput(side)`: Returns the input signal strength on `side` (0-15).
- `redstone.getAnalogOutput(side)`: Returns the current output signal strength on `side` (0-15).

### 3. Bundled Cables (Multi-channel)

Used with modded cables to send up to 16 simultaneous signals.

- `redstone.setBundledOutput(side, output)`: Sets the color bitmask output for `side`.
- `redstone.getBundledInput(side)`: Returns the current color bitmask input for `side`.
- `redstone.getBundledOutput(side)`: Returns the current color bitmask output for `side`.
- `redstone.testBundledInput(side, mask)`: Returns `true` if the current input on `side` contains all the colors specified in `mask`.

## Helpers

- `redstone.getSides()`: Returns a table of valid sides (`"top"`, `"bottom"`, `"left"`, `"right"`, `"front"`, `"back"`).

## Events

Whenever any redstone input changes, a `"redstone"` event is queued.
