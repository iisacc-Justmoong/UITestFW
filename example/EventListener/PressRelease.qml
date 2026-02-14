import QtQuick
import LVRS 1.0 as LV

Item {
    id: root

    signal eventRaised(string triggerName, string detail)

    implicitWidth: holdButton.implicitWidth
    implicitHeight: holdButton.implicitHeight
    property bool pressedNow: false

    LV.LabelButton {
        id: holdButton
        text: "Hold"
        tone: root.pressedNow ? LV.AbstractButton.Primary : LV.AbstractButton.Default
    }

    LV.EventListener {
        trigger: "pressed"
        action: () => {
            root.pressedNow = true
            root.eventRaised("pressed", "button pressed")
        }
    }

    LV.EventListener {
        trigger: "released"
        action: () => {
            root.pressedNow = false
            root.eventRaised("released", "button released")
        }
    }
}
