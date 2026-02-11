# AppCard

Location: `qml/components/surfaces/AppCard.qml`

Card container with title and subtitle, plus a content slot.

## Usage
```qml
LV.AppCard { title: "Summary"; subtitle: "Details" }
```

## Practical Examples

### Example 1: Summary card with title and subtitle
```qml
import QtQuick
import LVRS 1.0 as LV

LV.AppCard {
    width: 360
    title: "System Health"
    subtitle: "Last 15 minutes"

    LV.Label { text: "No incidents detected"; style: body }
}
```

### Example 2: Card containing form controls
```qml
import QtQuick
import LVRS 1.0 as LV

LV.AppCard {
    title: "Notification Settings"

    Column {
        spacing: 8
        LV.CheckBox { text: "Email alerts"; checked: true }
        LV.CheckBox { text: "Slack alerts"; checked: false }
        LV.ToggleSwitch { checked: true }
    }
}
```

### Example 3: Metric card with compact layout
```qml
import QtQuick
import LVRS 1.0 as LV

LV.AppCard {
    width: 280
    title: "Run Metrics"

    LV.VStack {
        spacing: 6
        LV.Label { text: "Success Rate: 98.2%"; style: body }
        LV.Label { text: "Average Duration: 4m 32s"; style: description }
        LV.Label { text: "Failures Today: 3"; style: description }
    }
}
```
