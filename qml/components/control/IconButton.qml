import QtQuick
import QtQuick.Layouts
import UIFramework 1.0

AbstractButton {
    id: control

    property string icon: ""
    property int iconSize: 14
    property color iconColor: textColor

    contentItem: RowLayout {
        spacing: control.spacing
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

        Text {
            visible: control.icon.length > 0
            text: control.icon
            color: control.iconColor
            font.family: Theme.fontDisplay
            font.pixelSize: control.iconSize
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: control.text
            color: control.enabled ? control.textColor : control.textColorDisabled
            font.family: Theme.fontBody
            font.pixelSize: 12
            font.weight: Font.DemiBold
            elide: Text.ElideRight
            visible: control.text.length > 0
            Layout.alignment: Qt.AlignVCenter
        }
    }
    QtObject {
        Component.onCompleted: Debug.log("IconButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.IconButton { icon: "⚙"; text: "Settings" }
