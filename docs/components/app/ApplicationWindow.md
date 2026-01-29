# ApplicationWindow

Location: `qml/ApplicationWindow.qml`

Window wrapper that normalizes platform sizing and applies safe margins.

## Properties
- `desktopMinWidth`, `desktopMinHeight`
- `mobileMinWidth`, `mobileMinHeight`
- `usePlatformSafeMargin`, `safeMargin`
- `styleSheet`, `styleSheetUrl`

## Usage
```qml
UIF.ApplicationWindow {
    title: "App"
    usePlatformSafeMargin: true
}
```
