# ViewModels

Location: `backend/viewmodelregistry.h` / `backend/viewmodelregistry.cpp`

Registry for ViewModel instances, accessed by key.

## Methods
- `get(key)`
- `set(key, object)`
- `remove(key)`
- `clear()`

## Usage
```qml
property var vm: UIF.ViewModels.get("Main")
```
