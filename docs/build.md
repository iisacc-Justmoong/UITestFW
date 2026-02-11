# Build

Configure and build:
```
cmake -S . -B build
cmake --build build
```

Run demo app:
```
./build/UIFramework
```

Notes:
- Qt 6.5+ with `QtQuick` and `QtQuickControls2` required.
- `example/` is not part of any build target.
