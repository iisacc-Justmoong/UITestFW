import QtQuick
import QtQuick.Layouts
import UIFramework 1.0

AbstractButton {
    id: control

    checkable: true

    property string icon: ""
    property string badge: ""
    property bool active: checked

    onActiveChanged: {
        if (checked !== active)
            checked = active
    }

    onCheckedChanged: {
        if (active !== checked)
            active = checked
    }

    textColor: control.active ? Theme.textPrimary : Theme.textSecondary
    backgroundColor: control.active ? Theme.accentMuted : "transparent"
    backgroundColorHover: control.active ? Theme.accentMuted : Theme.surfaceAlt
    backgroundColorPressed: Theme.accentMuted
    borderColor: control.active ? Theme.border : "transparent"
    borderColorHover: control.active ? Theme.border : Theme.borderSoft

    contentItem: RowLayout {
        spacing: 8
        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

        Text {
            visible: control.icon.length > 0
            text: control.icon
            color: control.active ? Theme.textPrimary : Theme.textTertiary
            font.family: Theme.fontDisplay
            font.pixelSize: 12
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            text: control.text
            color: control.textColor
            font.family: Theme.fontBody
            font.pixelSize: 13
            elide: Text.ElideRight
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle {
            visible: control.badge.length > 0
            radius: 8
            color: control.active ? Theme.accent : Theme.borderSoft
            Layout.preferredHeight: 18
            Layout.preferredWidth: Math.max(18, badgeText.implicitWidth + 10)

            Text {
                id: badgeText
                anchors.centerIn: parent
                text: control.badge
                color: control.active ? Theme.onAccent : Theme.textPrimary
                font.family: Theme.fontBody
                font.pixelSize: 10
            }
        }
    }
    QtObject {
        Component.onCompleted: UIF.Debug.log("DrawerButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.DrawerButton { text: "Overview"; icon: "●"; active: true }
