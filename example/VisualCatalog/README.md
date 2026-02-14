# Visual Catalog Example

This is the design-system demo application driven by `Main.qml`.

## Run

From repository root:

```bash
cmake -S . -B build-codex -DLVRS_BUILD_EXAMPLES=ON
cmake --build build-codex --target LVRSExampleVisualCatalog
./build-codex/bin/LVRSExampleVisualCatalog
```

On macOS Finder, you can also click `example/run-visual-catalog.command`.
