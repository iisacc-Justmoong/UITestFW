import QtQuick
import LVRS 1.0

AbstractButton {
    id: control

    tone: AbstractButton.Primary
    horizontalPadding: Theme.gap8
    verticalPadding: control.tone === AbstractButton.Primary ? Theme.gap2 : Theme.gap4
    spacing: Theme.gapNone
    cornerRadius: Theme.radiusSm
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding

    contentItem: Label {
        style: body
        text: control.text
        color: control.effectiveEnabled ? control.textColor : control.textColorDisabled
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    QtObject {
        Component.onCompleted: Debug.log("LabelButton", "created")
    }

}

// API usage (external):
// import LVRS 1.0 as UIF
// UIF.LabelButton { text: "Button"; tone: UIF.AbstractButton.Primary }
