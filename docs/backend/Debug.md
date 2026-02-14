# Debug

Location: `backend/runtime/debuglogger.h` / `backend/runtime/debuglogger.cpp`

`Debug` is a shared QML/C++ logger singleton that provides both an in-memory buffer and stdout output.

Core API:

- `log(component, event, data?)`
- `warn(component, event, data?)`
- `error(component, event, data?)`
- `entries(limit?)`, `filteredEntries(limit?)`, `summary()`
- `attachRuntimeEvents()`, `detachRuntimeEvents()`

For the exact output schema and field definitions, refer to:

- `docs/backend/DebugOutput.md`
