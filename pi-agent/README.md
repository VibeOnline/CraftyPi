# Pi for CraftOS

Pi for CraftOS is a high-performance, minimal coding assistant harness implemented in Lua. It integrates Large Language Models (LLMs) directly into the ComputerCraft/CraftOS environment, providing an interactive AI agent capable of navigating files, executing code, and assisting with development tasks.

## Features

- **Interactive Chat TUI**: A specialized terminal interface with scrolling history, real-time streaming, and visual status indicators.
- **Automated Lua Execution**: The agent can autonomously execute Lua code by wrapping it in ` ```lua ` blocks. The harness captures output and feeds it back to the AI, creating a tight loop of action and observation.
- **Ollama Integration**: Native support for Ollama APIs, allowing the use of local or remote models with full control over thinking budgets.
- **Context-Aware Intelligence**: The agent is grounded in your project through a dedicated knowledge base (`/.pi-agent/`), including documentation and examples.
- **State Management**: Supports session naming and persistent settings via the CraftOS `settings` API.

## Installation

1. Upload `pi.lua` to your CraftOS computer.
2. Ensure the computer has network access to your configured Ollama API endpoint.
3. Launch the assistant:
   ```lua
   lua pi.lua
   ```

## Configuration

Pi relies on the CraftOS `settings` API for its configuration. You can modify these settings from the terminal before launching the program to customize the agent's behavior.

| Setting              | Description                                          | Default              |
| :------------------- | :--------------------------------------------------- | :------------------- |
| `pi_api_url`         | The base URL of your Ollama API                      | `https://ollama.com` |
| `pi_api_key`         | API key for authentication (if required)             | `""`                 |
| `pi_model`           | The model identifier (e.g., `gemma4:31b`)            | `gemma4:31b`         |
| `pi_thinking`        | Enable/disable the model's internal thinking process | `true`               |
| `pi_thinking_budget` | Max tokens allocated for thinking blocks             | `4096`               |
| `pi_context_size`    | Total context window size in tokens                  | `262`                |

**Example Configuration:**

```bash
set pi_api_url http://192.168.1.100:11434
set pi_model llama3
```

## Usage

### Interact with the AI

Type your requests into the chat input. The agent is equipped with tools like `read`, `edit`, `write`, and `bash` to interact with the filesystem and shell.

### Code Execution Loop

When the AI provides a code block tagged as `lua`, the harness automatically:

1. Extracts the code.
2. Executes it using a protected `pcall` environment.
3. Captures the standard output.
4. Sends the result (Success or Error) back to the AI as a new user message.

This allows the AI to "test" its theories, debug scripts, and explore the environment in real-time.

### Slash Commands

While in the chat, use these commands to control the session:

- `/exit` or `/quit`: Terminate the session and return to the shell.
- `/name <name>`: Rename the current chat session.
- `/think <on|off>`: Toggle the model's thinking capabilities.
- `/budget <number>`: Adjust the thinking token budget on the fly.

## Knowledge Base

The harness maintains a hidden directory `/.pi-agent/` which serves as the agent's primary reference for its own operation:

- `/.pi-agent/README.md`: This high-level guide.
- `/.pi-agent/docs/`: Detailed technical specifications and API references.
- `/.pi-agent/examples/`: Implementation patterns for extensions and custom tools.

When the agent is asked about "pi", it is explicitly instructed to cross-reference these files to provide accurate information.

## License

MIT
