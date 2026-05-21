# Shell API Reference

The `shell` API provides access to the CraftOS command line interface. It is used to manage the working environment and execute programs.

## Program Execution

- `shell.run(...)`: Runs a program with the supplied arguments. All arguments are concatenated and parsed as a command line.
- `shell.execute(command, ...)`: Runs a program with supplied arguments, passing each argument verbatim (no concatenation/parsing).
- `shell.resolveProgram(command)`: Returns the absolute path to a program, considering the program path and aliases.
- `shell.programs([include_hidden])`: Returns a list of all lauchable programs on the path.

## Environment Management

- `shell.dir()`: Returns the current working directory.
- `shell.setDir(dir)`: Sets the current working directory.
- `shell.path()`: Returns the list of directories where programs are located (colon-separated).
- `shell.setPath(path)`: Sets the program path.
- `shell.resolve(path)`: Converts a relative path to an absolute path based on the current directory.
- `shell.getRunningProgram()`: Returns the absolute path of the currently executing program.

## Aliases & Completion

- `shell.setAlias(command, program)`: Creates a shortcut for a program.
- `shell.clearAlias(command)`: Removes an alias.
- `shell.aliases()`: Returns a table of all current aliases.
- `shell.complete(sLine)`: Completes a partial shell command line.
- `shell.setCompletionFunction(program, complete)`: Sets an auto-complete handler for a specific program.

## Multishell Integration

- `shell.openTab(...)`: Opens a new multishell tab running the specified command.
- `shell.switchTab(id)`: Switches focus to the tab with the given ID.

## Note on Scope

Unlike `os` or `fs`, `shell` is not a global API injected by the BIOS; it is a program that injects its own API into the programs it launches.
