import QtQuick
import LVRS 1.0

AbstractButton {
    id: control

    tone: AbstractButton.Default
    horizontalPadding: Theme.gap8
    verticalPadding: Theme.gap4
    spacing: Theme.gapNone
    cornerRadius: Theme.radiusSm
    implicitHeight: Theme.gap20
    height: Theme.gap20
    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding

    contentItem: Label {
        style: body
        text: control.text
        color: control.effectiveEnabled ? control.textColor : control.textColorDisabled
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}

// API usage (external):
// import LVRS 1.0 as LV
// LV.AlertButton { text: "Button"; tone: LV.AbstractButton.Primary }
