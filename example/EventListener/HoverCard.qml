import QtQuick
import UIFramework 1.0 as UIF

Rectangle {
    id: root

    signal eventRaised(string triggerName, string detail)

    width: 140
    height: 48
    radius: UIF.Theme.radiusSm
    color: hovered ? UIF.Theme.surfaceAlt : UIF.Theme.surfaceSolid
    property bool hovered: false

    UIF.Label {
        anchors.centerIn: parent
        text: "Hover me"
        style: body
    }

    UIF.EventListener {
        trigger: "hoverChanged"
        action: (e) => {
            hovered = e.containsMouse
            root.eventRaised("hoverChanged", e.containsMouse ? "pointer entered" : "pointer exited")
        }
    }
}
