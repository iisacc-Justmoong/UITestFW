import QtQuick
import LVRS 1.0 as LV

Rectangle {
    id: root

    signal eventRaised(string triggerName, string detail)

    width: 180
    height: 60
    radius: LV.Theme.radiusSm
    color: hovered ? LV.Theme.surfaceAlt : LV.Theme.surfaceSolid
    property bool hovered: false

    LV.Label {
        anchors.centerIn: parent
        text: "Interact"
        style: body
    }

    LV.EventListener {
        trigger: "entered"
        action: () => {
            root.hovered = true
            root.eventRaised("entered", "pointer entered")
        }
    }

    LV.EventListener {
        trigger: "exited"
        action: () => {
            root.hovered = false
            root.eventRaised("exited", "pointer exited")
        }
    }

    LV.EventListener {
        trigger: "clicked"
        action: () => root.eventRaised("clicked", "surface clicked")
    }
}
