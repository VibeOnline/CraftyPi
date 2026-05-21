# Window API Reference

The `window` API allows you to create "terminal redirects," which are subsections of a parent terminal (like a screen or monitor) that act as their own independent terminals.

## Window Creation

- `window.create(parent, x, y, width, height, [startVisible])`: Creates a new window.
  - `parent`: The terminal object to draw into (e.g., `term.current()`).
  - `x, y`: Top-left coordinates relative to the parent.
  - `width, height`: Dimensions of the window.
  - `startVisible`: Boolean. Defaults to `true`.

## Window Object Methods

A window object inherits almost all methods from the `term` API (like `write`, `clear`, `setCursorPos`, `setTextColor`, etc.), but adds the following specific controls:

- **Visibility**:
  - `window:setVisible(visible)`: Sets whether the window is rendered to the screen.
  - `window:isVisible()`: Returns the current visibility state.
- **Rendering**:
  - `window:redraw()`: Forces the window to draw its current buffer to the parent.
  - `window:restoreCursor()`: Sets the parent terminal's cursor to match the window's current cursor.
- **Positioning**:
  - `window:getPosition()`: Returns the `{x, y}` of the top-left corner.
  - `window:reposition(nx, ny, [nw, nh, [nparent]])`: Moves or resizes the window.
- **Content Access**:
  - `window:getLine(y)`: Returns the text, text colors, and background colors for a specific line within the window's buffer.

## Note on Redirection

Windows are often used in conjunction with `term.redirect(windowObject)`. This makes all subsequent `term` calls target the window instead of the main screen.
