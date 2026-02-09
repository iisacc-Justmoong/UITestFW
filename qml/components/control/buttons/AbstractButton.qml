import QtQuick
import QtQuick.Controls as Controls
import UIFramework 1.0

Controls.AbstractButton {
    id: control

    enum ButtonTone {
        Accent,
        Default,
        Borderless,
        Destructive,
        Disabled
    }

    property int tone: AbstractButton.Default
    property bool effectiveEnabled: enabled && tone !== AbstractButton.Disabled

    readonly property color toneTextColor: {
        if (tone === AbstractButton.Accent || tone === AbstractButton.Destructive)
            return Theme.textPrimary
        return Theme.textPrimary
    }
    readonly property color toneBackgroundColor: {
        if (tone === AbstractButton.Accent)
            return Theme.accent
        if (tone === AbstractButton.Destructive)
            return Theme.danger
        if (tone === AbstractButton.Borderless)
            return "transparent"
        return Theme.surfaceSolid
    }
    readonly property color toneBackgroundColorHover: {
        if (tone === AbstractButton.Accent)
            return Qt.darker(Theme.accent, 1.12)
        if (tone === AbstractButton.Destructive)
            return Qt.darker(Theme.danger, 1.12)
        if (tone === AbstractButton.Borderless)
            return Theme.surfaceAlt
        return Theme.surfaceAlt
    }
    readonly property color toneBackgroundColorPressed: {
        if (tone === AbstractButton.Accent)
            return Qt.darker(Theme.accent, 1.2)
        if (tone === AbstractButton.Destructive)
            return Qt.darker(Theme.danger, 1.2)
        if (tone === AbstractButton.Borderless)
            return Theme.accent
        return Theme.accent
    }
    readonly property color toneBorderColor: {
        if (tone === AbstractButton.Borderless)
            return "transparent"
        if (tone === AbstractButton.Accent)
            return Qt.darker(Theme.accent, 1.2)
        if (tone === AbstractButton.Destructive)
            return Qt.darker(Theme.danger, 1.2)
        return Theme.surfaceAlt
    }
    readonly property color toneBorderColorHover: {
        if (tone === AbstractButton.Borderless)
            return "transparent"
        return Theme.surfaceAlt
    }

    property int horizontalPadding: 14
    property int verticalPadding: 10
    property int cornerRadius: Theme.radiusMd
    property int borderWidth: 1

    property color textColor: control.toneTextColor
    property color textColorDisabled: Theme.textOctonary

    property color backgroundColor: control.toneBackgroundColor
    property color backgroundColorHover: control.toneBackgroundColorHover
    property color backgroundColorPressed: control.toneBackgroundColorPressed
    property color backgroundColorDisabled: Theme.subSurface

    property color borderColor: control.toneBorderColor
    property color borderColorHover: control.toneBorderColorHover
    property color borderColorDisabled: "transparent"

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
        color: control.effectiveEnabled ? control.textColor : control.textColorDisabled
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
        color: !control.effectiveEnabled
            ? control.backgroundColorDisabled
            : control.down
                ? control.backgroundColorPressed
                : control.hovered
                    ? control.backgroundColorHover
                    : control.backgroundColor
        border.color: !control.effectiveEnabled
            ? control.borderColorDisabled
            : control.hovered
                ? control.borderColorHover
                : control.borderColor
        border.width: control.borderWidth
    }

    QtObject {
        Component.onCompleted: Debug.log("AbstractButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.AbstractButton { text: "Action"; tone: UIF.AbstractButton.Accent }
