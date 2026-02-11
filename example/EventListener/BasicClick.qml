import QtQuick
import UIFramework 1.0 as UIF

Item {
    id: root

    signal eventRaised(string triggerName, string detail)

    implicitWidth: triggerButton.implicitWidth
    implicitHeight: triggerButton.implicitHeight

    UIF.LabelButton {
        id: triggerButton
        text: "Click me"
        tone: UIF.AbstractButton.Default
    }

    UIF.EventListener {
        trigger: "clicked"
        action: () => root.eventRaised("clicked", "LabelButton clicked")
    }
}
