import QtQuick
import LVRS 1.0 as LV

Rectangle {
    id: root

    signal eventRaised(string triggerName, string detail)

    width: 140
    height: 48
    radius: LV.Theme.radiusSm
    color: hovered ? LV.Theme.surfaceAlt : LV.Theme.surfaceSolid
    property bool hovered: false

    LV.Label {
        anchors.centerIn: parent
        text: "Hover me"
        style: body
    }

    LV.EventListener {
        trigger: "hoverChanged"
        action: (e) => {
            hovered = e.containsMouse
            root.eventRaised("hoverChanged", e.containsMouse ? "pointer entered" : "pointer exited")
        }
    }
}
