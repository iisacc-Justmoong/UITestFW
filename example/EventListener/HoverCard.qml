import QtQuick
import UIFramework 1.0 as UIF

Rectangle {
    width: 140
    height: 48
    radius: 8
    color: "#2a2a2a"

    UIF.EventListener {
        trigger: "hoverChanged"
        action: (e) => console.log("hover:", e.containsMouse)
    }
}
