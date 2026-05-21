# Colors API Reference

The `colors` (or `colours`) API provides constants and utilities for working with colors in `term` and `redstone`.

## Color Constants

The following constants are available (all are powers of 2):
`white` (1), `orange` (2), `magenta` (4), `lightBlue` (8), `yellow` (16), `lime` (32), `pink` (64), `gray` (128), `lightGray` (256), `cyan` (512), `purple` (1024), `blue` (2048), `brown` (4096), `green` (8192), `red` (16384), `black` (32768).

## Color Set Operations

Useful for Bundled Cables and complex UI masks.

- `colors.combine(...)`: Combines multiple colors or color sets into a single bitmask.
- `colors.subtract(initialSet, ...)`: Removes specified colors from a set.
- `colors.test(set, color)`: Returns `true` if `color` is contained within `set`.

## RGB Conversion

- `colors.packRGB(r, g, b)`: Combines three RGB channels (0.0 to 1.0) into a 24-bit hexadecimal integer.
- `colors.unpackRGB(rgb)`: Extracts the three RGB channels from a 24-bit hexadecimal integer.

## Blit Conversion

- `colors.toBlit(color)`: Converts a color constant to a hex character (`0-9a-f`) used in `term.blit`.
- `colors.fromBlit(hex)`: Converts a hex character (`0-9a-f`) back to a color constant.
