import QtQuick
import LVRS 1.0 as UIF

Rectangle {
    id: root

    signal eventRaised(string triggerName, string detail)

    width: 180
    height: 60
    radius: UIF.Theme.radiusSm
    color: hovered ? UIF.Theme.surfaceAlt : UIF.Theme.surfaceSolid
    property bool hovered: false

    UIF.Label {
        anchors.centerIn: parent
        text: "Interact"
        style: body
    }

    UIF.EventListener {
        trigger: "entered"
        action: () => {
            root.hovered = true
            root.eventRaised("entered", "pointer entered")
        }
    }

    UIF.EventListener {
        trigger: "exited"
        action: () => {
            root.hovered = false
            root.eventRaised("exited", "pointer exited")
        }
    }

    UIF.EventListener {
        trigger: "clicked"
        action: () => root.eventRaised("clicked", "surface clicked")
    }
}
