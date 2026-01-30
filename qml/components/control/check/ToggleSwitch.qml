import QtQuick
import UIFramework 1.0

AbstractButton {
    id: control

    checkable: true
    text: ""

    property int switchWidth: 44
    property int switchHeight: 24
    property int knobSize: 18

    property color onColor: Theme.accent
    property color offColor: Theme.borderSoft
    property color disabledColor: Theme.surfaceAlt
    property color knobColor: Theme.surfaceSolid
    property color knobDisabledColor: Theme.borderSoft

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    implicitWidth: switchWidth
    implicitHeight: switchHeight

    contentItem: Item { }

    background: Rectangle {
        width: control.switchWidth
        height: control.switchHeight
        radius: height / 2
        color: control.enabled
            ? (control.checked ? control.onColor : control.offColor)
            : control.disabledColor
        border.color: control.enabled ? "transparent" : Theme.border
        border.width: control.enabled ? 0 : 1

        Rectangle {
            width: control.knobSize
            height: control.knobSize
            radius: width / 2
            color: control.enabled ? control.knobColor : control.knobDisabledColor
            anchors.verticalCenter: parent.verticalCenter
            x: control.checked ? parent.width - width - 3 : 3
        }
    }
    QtObject {
        Component.onCompleted: Debug.log("ToggleSwitch", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.ToggleSwitch { checked: true }
