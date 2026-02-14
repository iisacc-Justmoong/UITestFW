import QtQuick
import LVRS 1.0 as LV

Item {
    id: root

    signal eventRaised(string triggerName, string detail)

    implicitWidth: triggerButton.implicitWidth
    implicitHeight: triggerButton.implicitHeight

    LV.LabelButton {
        id: triggerButton
        text: "Click me"
        tone: LV.AbstractButton.Default
    }

    LV.EventListener {
        trigger: "clicked"
        action: () => root.eventRaised("clicked", "LabelButton clicked")
    }
}
