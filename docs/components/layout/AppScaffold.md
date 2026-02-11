# AppScaffold

Location: `qml/components/layout/AppScaffold.qml`

Main layout scaffold: header, nav rail/drawer, and content area.

## Navigation Integration
- `pageRouter`: if set and `navModel` items include `path`, clicking updates router.

## Usage
```qml
LV.AppScaffold {
    headerTitle: "App"
    navModel: [{ label: "Overview", path: "/" }]
}
```

## Practical Examples

### Example 1: Basic scaffold with default slots
```qml
import QtQuick
import LVRS 1.0 as LV

LV.AppScaffold {
    headerTitle: "Platform"
    headerSubtitle: "Operations"
    navModel: ["Overview", "Runs", "Reports"]

    Rectangle { color: LV.Theme.surfaceAlt; anchors.fill: parent }
}
```

### Example 2: Object nav model with badges and icons
```qml
import QtQuick
import LVRS 1.0 as LV

LV.AppScaffold {
    headerTitle: "Alerts"
    navModel: [
        { label: "Open", icon: "!", badge: 12 },
        { label: "Acknowledged", icon: "✓", badge: 3 },
        { label: "Muted", icon: "·", enabled: false }
    ]
}
```

### Example 3: Delegate navigation to `PageRouter`
```qml
import QtQuick
import LVRS 1.0 as LV

Item {
    LV.PageRouter {
        id: router
        anchors.fill: parent
        initialPath: "/"
        routes: [
            { path: "/", component: overviewPage },
            { path: "/reports", component: reportsPage }
        ]
    }

    LV.AppScaffold {
        anchors.fill: parent
        pageRouter: router
        navModel: [
            { label: "Overview", path: "/" },
            { label: "Reports", path: "/reports" }
        ]
    }

    Component { id: overviewPage; Rectangle { color: LV.Theme.surfaceAlt } }
    Component { id: reportsPage; Rectangle { color: LV.Theme.surfaceGhost } }
}
```
