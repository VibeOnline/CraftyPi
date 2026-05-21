# Term API Reference

The `term` API is used to interact with the computer's terminal or external monitors, providing control over text output, cursor position, and colors.

## Text Output & Cursor Control

- `term.write(text)`: Writes `text` at the current cursor position. Does NOT handle line breaks or wrapping.
- `term.getCursorPos()`: Returns the current `{x, y}` cursor position.
- `term.setCursorPos(x, y)`: Sets the cursor position.
- `term.clear()`: Clears the entire terminal using the current background color.
- `term.clearLine()`: Clears the current line.
- `term.scroll(y)`: Scrolls the terminal view by `y` lines.
- `term.getSize()`: Returns the current terminal dimensions `{width, height}`.

## Color Management

- `term.setTextColor(color)`: Sets the foreground color for subsequent text.
- `term.getTextColor()`: Returns the current foreground color.
- `term.setBackgroundColor(color)`: Sets the background color for subsequent text and `clear()` operations.
- `term.getBackgroundColor()`: Returns the current background color.
- `term.blit(text, textColors, bgColors)`: Writes text with per-character colors. `textColors` and `bgColors` must be strings of the same length as `text` containing hex digits.
- `term.isColor()`: Returns `true` if the terminal supports colors.

## Palette Control

- `term.setPaletteColor(index, rgb)`: Changes the actual RGB value of a color index. `rgb` can be a 24-bit integer (e.g., `0xFF0000`) or three floats (0-1).
- `term.getPaletteColor(index)`: Returns the RGB values for a color index.

## Terminal Redirection

- `term.redirect(target)`: Redirects all terminal output to another terminal object (like a monitor wrap).
- `term.current()`: Returns the current terminal being used.
- `term.native()`: Returns the computer's original native terminal.
