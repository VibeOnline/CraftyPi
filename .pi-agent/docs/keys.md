# Keys API Reference

The `keys` API provides human-readable constants for keyboard key codes used in `key` events.

## Functions

- `keys.getName(code)`: Translates a numerical key code (like those returned by `os.pullEvent("key")`) into a string representing the constant name (e.g., `keys.enter`).

## Constants

The `keys` table contains constants for all supported keys, such as:

- `keys.enter`
- `keys.backspace`
- `keys.up`, `keys.down`, `keys.left`, `keys.right`
- `keys.q`, `keys.w`, `keys.e`, etc.
- `keys.f1` through `keys.f12`
