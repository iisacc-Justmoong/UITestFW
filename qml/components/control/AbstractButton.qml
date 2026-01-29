import QtQuick
import QtQuick.Controls as Controls
import UIFramework 1.0
import UIFramework 1.0 as UIF

Controls.AbstractButton {
    id: control

    property int horizontalPadding: 14
    property int verticalPadding: 10
    property int cornerRadius: Theme.radiusMd
    property int borderWidth: 1

    property color textColor: Theme.textPrimary
    property color textColorDisabled: Theme.textTertiary

    property color backgroundColor: Theme.surfaceSolid
    property color backgroundColorHover: Theme.surfaceAlt
    property color backgroundColorPressed: Theme.accentMuted
    property color backgroundColorDisabled: Theme.surfaceAlt

    property color borderColor: Theme.border
    property color borderColorHover: Theme.border
    property color borderColorDisabled: Theme.borderSoft

    hoverEnabled: true
    focusPolicy: Qt.StrongFocus

    leftPadding: horizontalPadding
    rightPadding: horizontalPadding
    topPadding: verticalPadding
    bottomPadding: verticalPadding
    spacing: 8

    implicitHeight: Math.max(36, contentItem.implicitHeight + topPadding + bottomPadding)
    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding


    contentItem: Text {
        text: control.text
        color: control.enabled ? control.textColor : control.textColorDisabled
        font.family: Theme.fontBody
        font.pixelSize: 12
        font.weight: Font.DemiBold
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        radius: control.cornerRadius
        antialiasing: true
        color: !control.enabled
            ? control.backgroundColorDisabled
            : control.down
                ? control.backgroundColorPressed
                : control.hovered
                    ? control.backgroundColorHover
                    : control.backgroundColor
        border.color: !control.enabled
            ? control.borderColorDisabled
            : control.hovered
                ? control.borderColorHover
                : control.borderColor
        border.width: control.borderWidth
    }

    QtObject {
        Component.onCompleted: UIF.Debug.log("AbstractButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.AbstractButton { text: "Action" }
