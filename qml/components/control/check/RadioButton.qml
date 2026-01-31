import QtQuick
import QtQuick.Layouts
import UIFramework 1.0

AbstractButton {
    id: control

    checkable: true

    property int indicatorSize: 18
    property int dotSize: 8
    property color dotColor: Theme.textPrimary
    property color checkedColor: Theme.accent
    property color uncheckedColor: "transparent"
    property color disabledColor: Theme.surfaceAlt

    contentItem: RowLayout {
        spacing: 8
        Layout.alignment: Qt.AlignVCenter

        Rectangle {
            width: control.indicatorSize
            height: control.indicatorSize
            radius: width / 2
            color: control.enabled
                ? (control.checked ? control.checkedColor : control.uncheckedColor)
                : control.disabledColor
            border.color: Theme.surfaceAlt
            border.width: 1

            Rectangle {
                width: control.dotSize
                height: control.dotSize
                radius: width / 2
                color: control.enabled ? control.dotColor : Theme.textTertiary
                anchors.centerIn: parent
                visible: control.checked
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
        Component.onCompleted: Debug.log("RadioButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.RadioButton { text: "Choice A"; checked: true }
