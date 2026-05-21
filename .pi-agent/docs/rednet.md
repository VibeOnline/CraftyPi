# Rednet API Reference

The `rednet` API provides a layer of abstraction over the `modem` peripheral, facilitating communication between computers using their IDs.

## Basic Operations

- `rednet.open(modem)`: Opens the specified modem for rednet use. The computer will now respond to its own ID and the broadcast channel.
- `rednet.close([modem])`: Closes the specified modem. If no modem is provided, all open modems are closed.
- `rednet.isOpen([modem])`: Returns `true` if the specified modem (or any modem if not specified) is open for rednet.

## Messaging

- `rednet.send(recipient, message, [protocol])`: Sends a message to a computer with the given `recipient` ID.
  - `protocol`: Optional string to categorize the message.
  - **Returns**: `true` if the message was successfully queued (not necessarily received).
- `rednet.broadcast(message, [protocol])`: Sends a message to every computer currently using rednet.
- `rednet.receive([protocol_filter, [timeout]])`: Waits for a rednet message.
  - `protocol_filter`: If provided, only messages matching this protocol are kept; others are discarded.
  - `timeout`: Max time to wait in seconds.
  - **Returns**: `{senderID, message, protocol}` or `nil` on timeout.

## Service Discovery (Hosting)

- `rednet.host(protocol, hostname)`: Registers the computer as a provider of a specific `protocol` under the given `hostname`.
- `rednet.unhost(protocol)`: Stops hosting the specified protocol.
- `rednet.lookup(protocol, [hostname, [timeout]])`: Searches for computers hosting a protocol.
  - If `hostname` is provided, returns a single computer ID (or `nil`).
  - If `hostname` is omitted, returns a list of all computer IDs hosting that protocol.

## Constants

- `rednet.CHANNEL_BROADCAST` (65535): Channel used for broadcasts.
- `rednet.CHANNEL_REPEAT` (65533): Channel used for repeating messages.
- `rednet.MAX_ID_CHANNELS` (65500): Max ID range for computers.
