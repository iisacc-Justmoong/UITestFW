import QtQuick
import QtQuick.Layouts
import UIFramework 1.0
import UIFramework 1.0 as UIF

AbstractButton {
    id: control

    checkable: true

    property int boxSize: 18
    property color checkColor: Theme.onAccent
    property color checkedColor: Theme.accent
    property color uncheckedColor: "transparent"
    property color disabledColor: Theme.surfaceAlt

    contentItem: RowLayout {
        spacing: 8
        Layout.alignment: Qt.AlignVCenter

        Rectangle {
            width: control.boxSize
            height: control.boxSize
            radius: 4
            color: control.enabled
                ? (control.checked ? control.checkedColor : control.uncheckedColor)
                : control.disabledColor
            border.color: Theme.border
            border.width: 1

            Text {
                visible: control.checked
                text: "✓"
                color: control.enabled ? control.checkColor : Theme.textTertiary
                font.family: Theme.fontBody
                font.pixelSize: 12
                anchors.centerIn: parent
            }
        }

        Text {
            text: control.text
            color: control.enabled ? Theme.textPrimary : Theme.textTertiary
            font.family: Theme.fontBody
            font.pixelSize: 12
            visible: control.text.length > 0
            Layout.alignment: Qt.AlignVCenter
        }
    }
    QtObject {
        Component.onCompleted: UIF.Debug.log("CheckBox", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.CheckBox { text: "Remember me"; checked: true }
