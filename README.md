This project was generated using the official [Pi agent](https://pi.dev) with ```gemma4:31b-cloud``` from [Ollama](https://ollama.com)

# Pi Coding Agent for ComputerCraft 🤖

Pi is an expert coding assistant operating directly inside a **CraftOS (CC: Tweaked)** environment. It leverages Large Language Models to help you write, debug, and manage Lua code, automate filesystem tasks, and execute shell commands—all from within the game.

## 🚀 Features

- **TUI Interface**: A full-screen, scrollable chat interface with real-time streaming responses.
- **Tool Integration**: Built-in capabilities to interact with the computer:
    - `pi.read(path)`: Read the contents of files.
    - `pi.write(path, content)`: Save code or data to files.
    - `pi.run(command)`: Execute shell commands.
- **Context Awareness**: The agent knows its working directory and has access to a comprehensive API overview of the CC: Tweaked environment.
- **LLM-Powered**: Intelligent code generation tailored specifically for Lua 5.1 and CraftOS constraints.

## 🛠️ Installation

The easiest way to install Pi is via the bootstrapper script. Run the following command in your computer's terminal:

```lua
lua https://raw.githubusercontent.com/YOUR_USERNAME/YOUR_REPO/main/install.lua
```

*(Replace the URL with the actual link to the `install.lua` script in your release)*

## 📖 Usage

Once installed, you can launch the agent by running:

```bash
@pi.lua
```

### Basic Interaction
- **Ask for Code**: "Create a program that calculates the Fibonacci sequence."
- **Edit Files**: "Read `main.lua` and change the variable `speed` to 10."
- **Automate**: "Read all files in this folder and list them."
- **Exit**: Type `/exit` to leave the TUI and return to the shell.

## 📂 Project Structure

- `pi.lua`: The main entry point and TUI loop.
- `pi-agent/lib/`: Internal library for prompt building, execution, and UI rendering.
- `pi-agent/tools/`: The toolset used by the agent (read, write, run).
- `pi-agent/docs/`: Comprehensive documentation for the agent.

## ⚠️ Limitations

- **Unicode**: Only symbols supported by CraftOS are rendered. See `pi-agent/docs/symbols.md` for the full list.
- **Permissions**: The agent can only access files and directories that the current user has permission to modify.
