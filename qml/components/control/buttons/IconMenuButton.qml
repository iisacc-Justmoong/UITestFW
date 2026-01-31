import QtQuick
import QtQuick.Layouts
import UIFramework 1.0

AbstractButton {
    id: control

    checkable: true

    property bool useTone: false
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

    readonly property color inactiveTextColor: useTone ? control.toneTextColor : Theme.textSecondary
    readonly property color inactiveBackgroundColor: useTone ? control.toneBackgroundColor : "transparent"
    readonly property color inactiveBackgroundHover: useTone ? control.toneBackgroundColorHover : Theme.surfaceAlt
    readonly property color inactiveBackgroundPressed: useTone ? control.toneBackgroundColorPressed : Theme.accent
    readonly property color inactiveBorderColor: useTone ? control.toneBorderColor : "transparent"
    readonly property color inactiveBorderHover: useTone ? control.toneBorderColorHover : Theme.surfaceSolid

    readonly property color resolvedTextColor: control.active ? Theme.textPrimary : control.inactiveTextColor

    textColor: control.effectiveEnabled ? control.resolvedTextColor : control.textColorDisabled
    backgroundColor: control.active ? Theme.accent : control.inactiveBackgroundColor
    backgroundColorHover: control.active ? Theme.accent : control.inactiveBackgroundHover
    backgroundColorPressed: control.active ? Theme.accent : control.inactiveBackgroundPressed
    borderColor: control.active ? Theme.surfaceAlt : control.inactiveBorderColor
    borderColorHover: control.active ? Theme.surfaceAlt : control.inactiveBorderHover

    contentItem: RowLayout {
        spacing: 8
        Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft

        Text {
            text: control.icon
            color: control.effectiveEnabled
                ? (control.active ? Theme.textPrimary : (useTone ? control.textColor : Theme.textTertiary))
                : control.textColorDisabled
            font.family: Theme.fontDisplay
            font.pixelSize: 12
            Layout.alignment: Qt.AlignVCenter
        }

        Rectangle {
            visible: control.badge.length > 0
            radius: 8
            color: control.active ? Theme.accent : Theme.surfaceSolid
            Layout.preferredHeight: 18
            Layout.preferredWidth: Math.max(18, badgeText.implicitWidth + 10)

            Text {
                id: badgeText
                anchors.centerIn: parent
                text: control.badge
                color: control.active ? Theme.textPrimary : Theme.textPrimary
                font.family: Theme.fontBody
                font.pixelSize: 10
            }
        }
    }

    QtObject {
        Component.onCompleted: Debug.log("IconMenuButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.IconMenuButton { icon: "●"; badge: "3"; active: true }
