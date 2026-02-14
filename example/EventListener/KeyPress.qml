import QtQuick
import LVRS 1.0 as LV

Rectangle {
    id: root

    signal eventRaised(string triggerName, string detail)

    width: 240
    height: 40
    radius: LV.Theme.radiusSm
    color: LV.Theme.subSurface
    property string lastMessage: "Press Enter"

    LV.Label {
        anchors.centerIn: parent
        text: root.lastMessage
        style: body
    }

    LV.EventListener {
        trigger: "keyPressed"
        action: (event) => {
            const readable = event.text && event.text.length > 0
                ? event.text
                : ("key=" + event.key)
            root.lastMessage = "Pressed: " + readable
            root.eventRaised("keyPressed", readable)
        }
    }

    LV.EventListener {
        trigger: "keyReleased"
        action: (event) => {
            const readable = event.text && event.text.length > 0
                ? event.text
                : ("key=" + event.key)
            root.eventRaised("keyReleased", readable)
        }
    }
}
