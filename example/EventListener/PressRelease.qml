import QtQuick
import LVRS 1.0 as UIF

Item {
    id: root

    signal eventRaised(string triggerName, string detail)

    implicitWidth: holdButton.implicitWidth
    implicitHeight: holdButton.implicitHeight
    property bool pressedNow: false

    UIF.LabelButton {
        id: holdButton
        text: "Hold"
        tone: root.pressedNow ? UIF.AbstractButton.Accent : UIF.AbstractButton.Default
    }

    UIF.EventListener {
        trigger: "pressed"
        action: () => {
            root.pressedNow = true
            root.eventRaised("pressed", "button pressed")
        }
    }

    UIF.EventListener {
        trigger: "released"
        action: () => {
            root.pressedNow = false
            root.eventRaised("released", "button released")
        }
    }
}
