# Building TUI Applications in CC: Tweaked

This guide explains how to create Terminal User Interfaces (TUI) using the CC: Tweaked API. A TUI transforms the simple command-line interface into a full-screen application with layouts, interactive elements, and dynamic updates.

## The Foundation: The `term` API

The `term` API is the primary tool for controlling the display. Unlike `print()`, which always adds a newline and moves the cursor down, the `term` API allows you to place text anywhere on the screen.

### Basic Positioning and Output
- **`term.setCursorPos(x, y)`**: Moves the cursor to a specific coordinate. `(1, 1)` is the top-left corner.
- **`term.write(text)`**: Prints text at the current cursor position without advancing to the next line.
- **`term.clear()`**: Clears the entire screen using the current background color.
- **`term.getSize()`**: Returns the current width and height of the terminal. This is critical for creating responsive layouts that adapt to different window sizes.

### Visual Styling
- **`term.setTextColor(color)`**: Changes the color of the text being written.
- **`term.setBackgroundColor(color)`**: Changes the background color of the cells being written.
- **`term.blit(text, textColors, bgColors)`**: An advanced function that writes a string where every character can have a unique foreground and background color. This is significantly more efficient for complex UI elements like status bars or syntax highlighting.

---

## The Interactive Loop (Event Handling)

A TUI application must react to user input without blocking the entire program. This is achieved using the `os.pullEvent()` loop.

### Handling Keyboard Input
There are two primary types of keyboard events:
1. **`char`**: Triggered when a printable character (like 'a', '1', or ' ') is pressed.
2. **`key`**: Triggered for non-printable keys (like `keys.enter`, `keys.backspace`, `keys.up`, `keys.down`).

```lua
while true do
    local event, param = os.pullEvent()
    if event == "char" then
        print("User typed: " .. param)
    elseif event == "key" then
        if param == keys.enter then
            print("User pressed Enter!")
        end
    end
end
```

---

## Common TUI Design Patterns

### 1. The "Clear-and-Redraw" Pattern
The simplest way to update a UI is to clear the screen and redraw the entire state every time something changes.
- **Pros**: Simple to implement.
- **Cons**: Can cause "flickering" on slow computers or over networks.

### 2. The Layout Model
Divide your screen into functional zones to keep the code organized:
- **Header/Title Bar**: Fixed at the top.
- **Main Content Area**: The dynamic part of the screen (e.g., a chat log or a list).
- **Footer/Status Bar**: Fixed at the bottom (e.g., for token counts or CWD).

### 3. Implementing a Scrollable Buffer
To display more text than the screen can fit, maintain a "history list" (an array of strings) and a `scrollPos` variable.
- **Render Logic**: Only draw lines from `scrollPos` to `scrollPos + terminalHeight`.
- **Scrolling**: Increment or decrement `scrollPos` when `keys.up` or `keys.down` are detected.

### 4. Word Wrapping
Since `term.write` does not wrap text, you must implement a wrapping function.
- Calculate the limit based on `term.getSize()`.
- Split strings by spaces to avoid cutting words in half.
- Insert a newline characters or multiple `term.setCursorPos` calls to move to the next line.

---

## Advanced Tips

### Performance Optimization
- **Minimize Redraws**: Only call `term.clear()` when necessary. If you only need to update one line, use `term.setCursorPos` and overwrite that specific line.
- **Use `term.blit`**: When rendering a long line of text with multiple colors, a single `blit` call is much faster than multiple `setTextColor` and `write` calls.

### Responsive Design
Always call `term.getSize()` during your render loop. If a user resizes the window (e.g., using a monitor or a split-screen emulator), your TUI should automatically recalculate its margins and word-wrapping points.

### Cursor Management
When building a professional TUI, you often want to hide the blinking cursor or place it specifically in an input field.
- Use `term.setCursorPos` carefully to ensure the cursor is always where the user expects to be typing.
