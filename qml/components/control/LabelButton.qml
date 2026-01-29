import QtQuick
import UIFramework 1.0

AbstractButton {
    id: control

    property color accentColor: Theme.accent
    property color accentHoverColor: Theme.textPrimary

    textColor: control.enabled
        ? (control.hovered || control.down ? control.accentHoverColor : control.accentColor)
        : Theme.textTertiary
    backgroundColor: "transparent"
    backgroundColorHover: "transparent"
    backgroundColorPressed: "transparent"
    backgroundColorDisabled: "transparent"
    borderWidth: 0

    contentItem: Text {
        text: control.text
        color: control.textColor
        font.family: Theme.fontBody
        font.pixelSize: 12
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    QtObject {
        Component.onCompleted: Debug.log("LabelButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.LabelButton { text: "Learn more" }
