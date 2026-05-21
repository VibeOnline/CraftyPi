# Parallel API Reference

The `parallel` API allows you to run multiple functions concurrently. Note that this is **cooperative multitasking**, not true parallelism; the API switches between functions whenever they yield.

## Core Functions

- `parallel.waitForAny(...)`: Executes the provided functions. It stops and returns as soon as **any one** of the functions finishes or errors.
- `parallel.waitForAll(...)`: Executes the provided functions. It stops and returns only after **all** of the functions have finished.

## Key Concepts

### Yielding

The `parallel` API works by switching at "yield points." A function yields when it calls a function that pauses execution, such as:

- `os.sleep()`
- `os.pullEvent()`
- `rednet.receive()`
- Most `turtle` API methods.

### Event Queues

Each function run in parallel receives its own **copy** of the event queue. This means a `parallel.waitForAny` call can have one function waiting for a `key` event and another for a `timer` event without them interfering with each other's results.

### Warning: Passing Functions

Ensure you pass the **function reference**, not the result of the function call.

- **Correct**: `parallel.waitForAny(myFunc, otherFunc)`
- **Incorrect**: `parallel.waitForAny(myFunc(), otherFunc())`
