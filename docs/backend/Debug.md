# Debug

Location: `backend/runtime/debuglogger.h` / `backend/runtime/debuglogger.cpp`

Debug logger singleton for QML and C++.

## Properties
- `enabled` (bool)

## Methods
- `log(component, event, data?)`
- `warn(component, event, data?)`
- `error(component, event, data?)`

## Usage
```qml
UIF.Debug.enabled = true
UIF.Debug.log("AppCard", "created", { id: "card-1" })
```
