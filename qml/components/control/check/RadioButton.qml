import QtQuick
import QtQuick.Layouts
import UIFramework 1.0

AbstractButton {
    id: control

    checkable: true
    text: ""
    tone: AbstractButton.Borderless

    property bool state: checked
    property bool available: enabled

    property int indicatorSize: 18
    property int dotSize: 8

    property color onColor: Theme.accent
    property color offColor: Theme.textPrimary
    property color onColorDisabled: Theme.textOctonary
    property color offColorDisabled: Theme.textOctonary
    property color dotColor: Theme.textPrimary
    property color dotColorDisabled: Theme.textSeptenary

    readonly property color indicatorColor: control.enabled
        ? (control.checked ? control.onColor : control.offColor)
        : (control.checked ? control.onColorDisabled : control.offColorDisabled)
    readonly property color indicatorDotColor: control.enabled ? control.dotColor : control.dotColorDisabled

    onStateChanged: {
        if (checked !== state)
            checked = state
    }

    onCheckedChanged: {
        if (state !== checked)
            state = checked
    }

    onAvailableChanged: {
        if (enabled !== available)
            enabled = available
    }

    onEnabledChanged: {
        if (available !== enabled)
            available = enabled
    }

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    spacing: 0
    borderWidth: 0
    backgroundColor: "transparent"
    backgroundColorHover: "transparent"
    backgroundColorPressed: "transparent"
    backgroundColorDisabled: "transparent"
    implicitHeight: contentItem.implicitHeight
    implicitWidth: contentItem.implicitWidth

    background: Item { }

    contentItem: RowLayout {
        spacing: control.text.length > 0 ? 8 : 0
        Layout.alignment: Qt.AlignVCenter

        Rectangle {
            width: control.indicatorSize
            height: control.indicatorSize
            radius: width / 2
            color: control.indicatorColor
            border.width: 0
            antialiasing: true

            Rectangle {
                width: control.dotSize
                height: control.dotSize
                radius: width / 2
                color: control.indicatorDotColor
                anchors.centerIn: parent
                visible: control.checked
                antialiasing: true
            }
        }

        Text {
            text: control.text
            color: control.enabled ? Theme.textPrimary : Theme.textOctonary
            font.family: Theme.fontBody
            font.pixelSize: 13
            visible: control.text.length > 0
            Layout.alignment: Qt.AlignVCenter
            elide: Text.ElideRight
        }
    }

    QtObject {
        Component.onCompleted: Debug.log("RadioButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.RadioButton { text: "Choice A"; checked: true }
