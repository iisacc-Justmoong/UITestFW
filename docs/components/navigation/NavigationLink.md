# NavigationLink

Location: `qml/components/navigation/NavigationLink.qml`

Compatibility wrapper around `Link`.

## Usage
```qml
LV.NavigationLink { to: "/reports"; text: "Reports" }
```

## Practical Examples

### Example 1: Compatibility alias for route path
```qml
import QtQuick
import LVRS 1.0 as LV

LV.NavigationLink {
    text: "Reports"
    to: "/reports"
}
```

### Example 2: Use explicit router instance
```qml
import QtQuick
import LVRS 1.0 as LV

LV.NavigationLink {
    text: "Open Run #42"
    to: "/runs/42"
    router: router
}
```

### Example 3: Replace history entry
```qml
import QtQuick
import LVRS 1.0 as LV

LV.NavigationLink {
    text: "Go to Home"
    to: "/"
    replace: true
}
```
