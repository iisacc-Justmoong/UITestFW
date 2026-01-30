import QtQuick
import UIFramework 1.0

AbstractButton {
    id: control

    property bool useTone: false
    property color accentColor: control.tone === AbstractButton.Destructive ? Theme.danger : Theme.accent
    property color accentHoverColor: control.tone === AbstractButton.Destructive
        ? Qt.darker(Theme.danger, 1.12)
        : Theme.textPrimary
    readonly property color resolvedTextColor: useTone
        ? (control.hovered || control.down ? Theme.textPrimary : control.toneTextColor)
        : (control.hovered || control.down ? control.accentHoverColor : control.accentColor)

    tone: AbstractButton.Borderless
    textColor: control.effectiveEnabled ? control.resolvedTextColor : control.textColorDisabled
    backgroundColor: useTone ? control.toneBackgroundColor : "transparent"
    backgroundColorHover: useTone ? control.toneBackgroundColorHover : "transparent"
    backgroundColorPressed: useTone ? control.toneBackgroundColorPressed : "transparent"
    backgroundColorDisabled: useTone ? Theme.surfaceAlt : "transparent"
    borderWidth: useTone ? 1 : 0

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
