# HTTP API Reference

The `http` API allows the computer to send and receive data from remote web servers.

## Standard Requests

- `http.get(url, [headers], [binary])`: Makes a synchronous HTTP GET request.
- `http.post(url, body, [headers], [binary])`: Makes a synchronous HTTP POST request.
- `http.request(url, [body], [headers], [binary])`: Asynchronous HTTP request. Returns immediately. Results are delivered via `http_success` or `http_failure` events.

### Request Parameters

- `headers`: A table of key-value pairs for HTTP headers.
- `binary`: Boolean. If `true`, the response handle is opened in binary mode.

## Response Handle

Returned by `get`, `post`, and `request` (via event). It behaves like a file handle:

- `readAll()`: Reads the entire response body.
- `readLine()`: Reads one line.
- `close()`: Closes the response handle.
- `getResponseCode()`: Returns the HTTP status code (e.g., `200`) and the response message (e.g., `"OK"`).
- `getResponseHeaders()`: Returns a table of the response headers.

## WebSockets

- `http.websocket(url, [headers])`: Opens a synchronous WebSocket connection.
- `http.websocketAsync(url, [headers])`: Opens an asynchronous WebSocket connection. Result via `websocket_success` or `websocket_failure`.

### WebSocket Object

- `send(message, [binary])`: Sends a message to the server.
- `receive([timeout])`: Waits for a message from the server. Returns the message and a binary flag.
- `close()`: Terminates the connection.
- `getResponseHeaders()`: returns the handshake response headers.

## URL Verification

- `http.checkURL(url)`: Synchronously checks if a URL is valid and allowed.
- `http.checkURLAsync(url)`: Asynchronously checks if a URL is valid. Result via `http_check` event.
