# Link

Location: `qml/components/navigation/Link.qml`

Single navigation control for all click-to-route scenarios.

## Properties
- `router`
- `href`
- `to` (alias of `href`)
- `params`
- `targetComponent`
- `replace`
- `text`
- `underline`

`router` is optional when `Navigator` has a registered `PageRouter`.

## Usage
```qml
LV.Link { href: "/reports"; Text { text: "Reports" } }
```

## Practical Examples

### Example 1: Text-only route navigation
```qml
import QtQuick
import LVRS 1.0 as LV

LV.Link {
    text: "Open Reports"
    href: "/reports"
    underline: true
}
```

### Example 2: `to` alias for route path
```qml
import QtQuick
import LVRS 1.0 as LV

LV.Link {
    text: "Open Overview"
    to: "/overview"
}
```

### Example 3: Link with custom child content (wrapper-style usage)
```qml
import QtQuick
import LVRS 1.0 as LV

LV.Link {
    href: "/settings"

    Rectangle {
        width: 180
        height: 40
        radius: 8
        color: LV.Theme.surfaceSolid
        LV.Label { anchors.centerIn: parent; text: "Open Settings"; style: body }
    }
}
```

### Example 4: Replace current page and pass params
```qml
import QtQuick
import LVRS 1.0 as LV

LV.Link {
    href: "/runs/42"
    params: ({ source: "notifications" })
    replace: true
    text: "Go to latest failed run"
}
```

### Example 5: Navigate directly to a component
```qml
import QtQuick
import LVRS 1.0 as LV

Item {
    Component {
        id: detailsPage
        Rectangle { color: LV.Theme.windowAlt }
    }

    LV.Link {
        targetComponent: detailsPage
        replace: true
        text: "Open Details"
    }
}
```
