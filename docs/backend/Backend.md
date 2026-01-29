# Backend

Location: `backend/backend.h` / `backend/backend.cpp`

File helpers exposed to QML.

## Methods
- `saveTextFile(path, text)`
- `readTextFile(path)`
- `ensureDir(path)`
- `writableLocation(location)`

## Usage
```qml
UIF.Backend.saveTextFile("/tmp/out.txt", "hello")
```
