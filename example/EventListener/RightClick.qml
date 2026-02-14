import QtQuick
import LVRS 1.0 as LV

Item {
    id: root

    signal eventRaised(string triggerName, string detail)

    implicitWidth: rightClickTarget.implicitWidth
    implicitHeight: rightClickTarget.implicitHeight

    LV.LabelButton {
        id: rightClickTarget
        text: "Right click"
        tone: LV.AbstractButton.Default
    }

    LV.EventListener {
        trigger: "clicked"
        acceptedButtons: Qt.RightButton
        action: (mouse) => root.eventRaised(
                               "clicked",
                               "right click at (" + Math.round(mouse.x) + ", " + Math.round(mouse.y) + ")")
    }
}
