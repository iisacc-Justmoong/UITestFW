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
    readonly property color inactiveBackgroundPressed: useTone ? control.toneBackgroundColorPressed : Theme.accentMuted
    readonly property color inactiveBorderColor: useTone ? control.toneBorderColor : "transparent"
    readonly property color inactiveBorderHover: useTone ? control.toneBorderColorHover : Theme.borderSoft

    readonly property color resolvedTextColor: control.active ? Theme.textPrimary : control.inactiveTextColor

    textColor: control.effectiveEnabled ? control.resolvedTextColor : control.textColorDisabled
    backgroundColor: control.active ? Theme.accentMuted : control.inactiveBackgroundColor
    backgroundColorHover: control.active ? Theme.accentMuted : control.inactiveBackgroundHover
    backgroundColorPressed: control.active ? Theme.accentMuted : control.inactiveBackgroundPressed
    borderColor: control.active ? Theme.border : control.inactiveBorderColor
    borderColorHover: control.active ? Theme.border : control.inactiveBorderHover

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
        Component.onCompleted: Debug.log("IconMenuButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.IconMenuButton { icon: "●"; badge: "3"; active: true }
