# Backend

Location: `backend/io/backend.h` / `backend/io/backend.cpp`

File helpers exposed to QML.

## Methods
- `saveTextFile(path, text)`
- `readTextFile(path)`
- `ensureDir(path)`
- `writableLocation(location)`

## Usage
```qml
LV.Backend.saveTextFile("/tmp/out.txt", "hello")
```
