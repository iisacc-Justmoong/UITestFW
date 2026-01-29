import QtQuick
import UIFramework 1.0

AbstractButton {
    id: control

    checkable: true

    property color checkedBackground: Theme.accent
    property color checkedTextColor: Theme.onAccent
    property color checkedBorderColor: Theme.accent

    textColor: control.checked ? checkedTextColor : Theme.textPrimary
    backgroundColor: control.checked ? checkedBackground : Theme.surfaceSolid
    backgroundColorHover: control.checked ? checkedBackground : Theme.surfaceAlt
    backgroundColorPressed: control.checked ? Theme.accentMuted : Theme.surfaceAlt
    borderColor: control.checked ? checkedBorderColor : Theme.border
    borderColorHover: control.checked ? checkedBorderColor : Theme.border
    QtObject {
        Component.onCompleted: UIF.Debug.log("ToggleButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.ToggleButton { text: "Enabled"; checked: true }
