# ApplicationWindow

Location: `qml/ApplicationWindow.qml`

Primary app container that normalizes platform sizing and includes `AppScaffold` behavior.
Runtime rendering quality is driven by `LV.RenderQuality` and is supersampled by default.

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
import LVRS as LV

LV.ApplicationWindow {
    title: "App"
    subtitle: "Overview"
    navItems: ["Overview", "Runs"]
}
```

## Practical Examples

### Example 1: Minimal app window
```qml
import QtQuick
import LVRS 1.0 as LV

LV.ApplicationWindow {
    visible: true
    width: 1200
    height: 760
    title: "Ops Dashboard"
    subtitle: "Daily Overview"
}
```

### Example 2: Adaptive navigation by size class
```qml
import QtQuick
import LVRS 1.0 as LV

LV.ApplicationWindow {
    id: win
    title: "Adaptive App"
    navItems: ["Home", "Reports", "Settings"]
    navWidth: isCompact ? 180 : 240
    navDrawerWidth: isCompact ? 220 : 280
}
```

### Example 3: Router integration with header actions
```qml
import QtQuick
import LVRS 1.0 as LV

LV.ApplicationWindow {
    id: win
    title: "Routing Sample"
    pageRouter: router

    LV.IconButton {
        parent: win.headerActions
        tone: LV.AbstractButton.Borderless
        iconName: "view-more-symbolic-borderless"
        onClicked: LV.Navigator.go("/reports")
    }

    LV.PageRouter {
        id: router
        anchors.fill: parent
        initialPath: "/"
        routes: [{ path: "/", component: homePage }, { path: "/reports", component: reportsPage }]
    }

    Component { id: homePage; Rectangle { color: LV.Theme.surfaceAlt } }
    Component { id: reportsPage; Rectangle { color: LV.Theme.surfaceGhost } }
}
```
