# AppShell

Location: `qml/AppShell.qml`

Compatibility wrapper over `ApplicationWindow`. New code should use `LV.ApplicationWindow` directly.

## Properties
- `title`, `subtitle`
- `navItems` (string or object list)
- `navIndex`, `navigationEnabled`, `navTitle`, `navTitleVisible`, `navWidth`, `navDrawerWidth`
- `navDelegate`, `navHeader`, `navFooter`
- `headerActions` (alias)

## Signals
- `navActivated(index, item)`

## Usage
```qml
LV.ApplicationWindow {
    title: "LVRS"
    navItems: ["Overview", "Runs"]
    onNavActivated: (idx, item) => console.log(idx, item)
}
```

## Practical Examples

### Example 1: Legacy wrapper quick start
```qml
import QtQuick
import LVRS 1.0 as LV

LV.AppShell {
    visible: true
    width: 1100
    height: 720
    title: "Legacy Shell"
    subtitle: "Compatibility Layer"
}
```

### Example 2: Simple menu-based navigation
```qml
import QtQuick
import LVRS 1.0 as LV

LV.AppShell {
    title: "Monitoring"
    navItems: ["Overview", "Runs", "Devices", "Settings"]
    onNavActivated: (index, item) => console.log("Selected", index, item)
}
```

### Example 3: Object-based nav model with route delegation
```qml
import QtQuick
import LVRS 1.0 as LV

LV.AppShell {
    title: "Route-Driven"
    navItems: [
        { label: "Overview", path: "/" },
        { label: "Reports", path: "/reports" },
        { label: "Settings", path: "/settings", enabled: false }
    ]
}
```
