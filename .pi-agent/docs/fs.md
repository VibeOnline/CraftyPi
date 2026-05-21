# FS API Reference

The `fs` API provides tools for interacting with the filesystem, including reading, writing, and organizing files and directories.

## File Operations

### Opening Files

- `fs.open(path, mode)`: Opens a file at `path` with the specified `mode`.
  - `"r"`: Read mode.
  - `"w"`: Write mode (erases content).
  - `"a"`: Append mode.
  - `"r+"`: Update mode (preserves data).
  - `"w+"`: Update mode (erases data).
  - Append `"b"` to any mode for binary mode (reads/writes bytes as numbers).
  - **Returns**: A file handle object or `nil` if the file doesn't exist or cannot be opened.

### File Handles

File handles returned by `fs.open` offer the following methods:

- `readAll()`: Reads the entire file into a string.
- `readLine()`: Reads a single line from the file.
- `write(text)`: Writes `text` to the file.
- `close()`: Closes the file handle. **Crucial: Changes may not be saved until closed.**

### Path Manipulation

- `fs.combine(path, ...)`: Joins multiple path segments into one absolute path.
- `fs.getName(path)`: Returns the filename only (final segment).
- `fs.getDir(path)`: Returns the parent directory path.

## Directory & Path Queries

- `fs.exists(path)`: Returns `true` if the path exists.
- `fs.isDir(path)`: Returns `true` if the path is a directory.
- `fs.isReadOnly(path)`: Returns `true` if the path is read-only.
- `fs.list(path)`: Returns a table of strings listing the contents of a directory.
- `fs.find(path)`: Searches for files matching a wildcard pattern (`*`, `?`).
- `fs.getSize(path)`: Returns the file size in bytes.

## File & Directory Manipulation

- `fs.makeDir(path)`: Creates a directory (and any required parent directories).
- `fs.move(path, dest)`: Moves a file or directory to `dest`.
- `fs.copy(path, dest)`: Copies a file or directory to `dest`.
- `fs.delete(path)`: Deletes a file or directory (recursively if it's a directory).

## Drive & Mounts

- `fs.getDrive(path)`: Returns the mount name (e.g., `"hdd"`, `"rom"`, `"disk1"`).
- `fs.getFreeSpace(path)`: Returns available space in bytes or `"unlimited"`.
- `fs.getCapacity(path)`: Returns total capacity of the drive in bytes.
- `fs.isDriveRoot(path)`: Returns `true` if the path is a mount root.

## Important Note

All `fs` functions expect **absolute paths**. Use `shell.resolve(path)` to convert relative paths to absolute ones.
