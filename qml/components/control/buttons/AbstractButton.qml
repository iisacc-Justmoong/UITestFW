import QtQuick
import QtQuick.Controls as Controls
import LVRS 1.0

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
    horizontalPadding: Theme.gap14
    verticalPadding: Theme.gap10
    property int cornerRadius: Theme.radiusMd

    property color textColor: control.toneTextColor
    property color textColorDisabled: Theme.textOctonary

    property color backgroundColor: control.toneBackgroundColor
    property color backgroundColorHover: control.toneBackgroundColorHover
    property color backgroundColorPressed: control.toneBackgroundColorPressed
    property color backgroundColorDisabled: Theme.subSurface

    hoverEnabled: control.effectiveEnabled
    focusPolicy: control.effectiveEnabled ? Qt.StrongFocus : Qt.NoFocus
    activeFocusOnTab: control.effectiveEnabled

    leftPadding: horizontalPadding
    rightPadding: horizontalPadding
    topPadding: verticalPadding
    bottomPadding: verticalPadding
    spacing: Theme.gap8

    implicitHeight: Math.max(Theme.controlHeightMd, contentItem.implicitHeight + topPadding + bottomPadding)
    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding

    onEffectiveEnabledChanged: {
        if (!control.effectiveEnabled && control.activeFocus)
            control.focus = false
    }


    contentItem: Label {
        style: description
        text: control.text
        color: control.effectiveEnabled ? control.textColor : control.textColorDisabled
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
    }

    MouseArea {
        anchors.fill: parent
        enabled: !control.effectiveEnabled
        acceptedButtons: Qt.AllButtons
        hoverEnabled: enabled
    }

    QtObject {
        Component.onCompleted: Debug.log("AbstractButton", "created")
    }

}

// API usage (external):
// import LVRS 1.0 as UIF
// UIF.AbstractButton { text: "Action"; tone: UIF.AbstractButton.Accent }
