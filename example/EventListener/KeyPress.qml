import QtQuick
import UIFramework 1.0 as UIF

Rectangle {
    id: root

    signal eventRaised(string triggerName, string detail)

    width: 240
    height: 40
    radius: UIF.Theme.radiusSm
    color: UIF.Theme.subSurface
    property string lastMessage: "Press Enter"

    UIF.Label {
        anchors.centerIn: parent
        text: root.lastMessage
        style: body
    }

    UIF.EventListener {
        trigger: "keyPressed"
        action: (event) => {
            const readable = event.text && event.text.length > 0
                ? event.text
                : ("key=" + event.key)
            root.lastMessage = "Pressed: " + readable
            root.eventRaised("keyPressed", readable)
        }
    }

    UIF.EventListener {
        trigger: "keyReleased"
        action: (event) => {
            const readable = event.text && event.text.length > 0
                ? event.text
                : ("key=" + event.key)
            root.eventRaised("keyReleased", readable)
        }
    }
}
