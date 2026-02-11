import QtQuick
import UIFramework 1.0 as UIF

Item {
    id: root

    signal eventRaised(string triggerName, string detail)

    implicitWidth: rightClickTarget.implicitWidth
    implicitHeight: rightClickTarget.implicitHeight

    UIF.LabelButton {
        id: rightClickTarget
        text: "Right click"
        tone: UIF.AbstractButton.Default
    }

    UIF.EventListener {
        trigger: "clicked"
        acceptedButtons: Qt.RightButton
        action: (mouse) => root.eventRaised(
                               "clicked",
                               "right click at (" + Math.round(mouse.x) + ", " + Math.round(mouse.y) + ")")
    }
}
