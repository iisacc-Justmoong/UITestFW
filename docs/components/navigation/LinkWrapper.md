# LinkWrapper

Location: `qml/components/navigation/LinkWrapper.qml`

Wrap any component to make it navigable.

## Usage
```qml
LV.LinkWrapper {
    href: "/b"
    Rectangle { width: 120; height: 40 }
}
```

## Practical Examples

### Example 1: Clickable card navigation
```qml
import QtQuick
import LVRS 1.0 as LV

LV.LinkWrapper {
    href: "/reports"

    Rectangle {
        width: 220
        height: 72
        radius: 12
        color: LV.Theme.surfaceAlt
        LV.Label { anchors.centerIn: parent; text: "Open Reports"; style: body }
    }
}
```

### Example 2: Pass route params from tile click
```qml
import QtQuick
import LVRS 1.0 as LV

LV.LinkWrapper {
    href: "/runs/42"
    params: ({ tab: "logs" })

    Rectangle { width: 180; height: 48; color: LV.Theme.surfaceGhost }
}
```

### Example 3: Navigate directly to a component
```qml
import QtQuick
import LVRS 1.0 as LV

Item {
    Component {
        id: detailsPage
        Rectangle { color: LV.Theme.windowAlt }
    }

    LV.LinkWrapper {
        targetComponent: detailsPage
        replace: true
        Rectangle { width: 160; height: 44; color: LV.Theme.accent }
    }
}
```
