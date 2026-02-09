# ApplicationWindow

Location: `qml/ApplicationWindow.qml`

Primary app container that normalizes platform sizing and includes `AppScaffold` behavior.
Runtime rendering quality is driven by `UIF.RenderQuality` and is supersampled by default.

## Properties
- `desktopMinWidth`, `desktopMinHeight`
- `mobileMinWidth`, `mobileMinHeight`
- `usePlatformSafeMargin`, `safeMargin`
- `subtitle`, `navItems`
- `navIndex`, `navigationEnabled`, `navTitle`, `navTitleVisible`
- `navWidth`, `navDrawerWidth`, `wideBreakpoint`
- `navDelegate`, `navHeader`, `navFooter`, `headerActions`, `pageRouter`

## Usage
```qml
import UIFramework as UIF

UIF.ApplicationWindow {
    title: "App"
    subtitle: "Overview"
    navItems: ["Overview", "Runs"]
}
```
