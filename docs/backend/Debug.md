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
LV.Debug.enabled = true
LV.Debug.log("AppCard", "created", { id: "card-1" })
```
