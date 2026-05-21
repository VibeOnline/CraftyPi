# TextUtils API Reference

The `textutils` API provides utility functions for manipulating strings, formatting time, and serializing data.

## String & Terminal Utilities

- `textutils.slowWrite(text, [rate])`: Writes text to the cursor position character-by-character.
- `textutils.slowPrint(text, [rate])`: Like `slowWrite` but adds a newline.
- `textutils.formatTime(time, [twentyFourHour])`: Formats a number from `os.time()` into a readable string (e.g., "6:30 PM").
- `textutils.pagedPrint(text, [free_lines])`: Prints text to the screen, paging with "Press any key to continue" when the screen is full.
- `textutils.tabulate(...)`: Prints a series of tables as a structured grid.
- `textutils.pagedTabulate(...)`: Like `tabulate` but with paging.

## Serialization & JSON

### Lua-Specific Serialization

- `textutils.serialize(t, [opts])`: Converts a Lua table into a textual representation.
  - `opts.compact`: Removes indentation.
  - `opts.allow_repetitions`: Allows non-recursive table repetitions.
- `textutils.unserialize(s)`: Converts a serialized string back into a Lua table.

### JSON Serialization

- `textutils.serializeJSON(t, [options])`: Converts a Lua table to a JSON string.
  - `options.nbt_style`: Produces NBT-style JSON (unquoted keys).
  - `options.unicode_strings`: Treats strings as UTF-8.
- `textutils.unserializeJSON(s, [options])`: Converts a JSON string back to a Lua table.

### JSON Special Values

- `textutils.empty_json_array`: A special table used to ensure an empty array `[]` is produced instead of an empty object `{}`.
- `textutils.json_null`: A special table used to produce an explicit `null` value in JSON.

## Other Utilities

- `textutils.urlEncode(str)`: Encodes a string for use in URLs.
- `textutils.complete(search, [table])`: Provides list of possible completions for a partial expression.
