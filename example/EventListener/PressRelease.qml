import QtQuick
import UIFramework 1.0 as UIF

Rectangle {
    width: 120
    height: 40
    color: "#1f1f1f"

    UIF.Label {
        anchors.centerIn: parent
        text: "Hold"
    }

    UIF.EventListner {
        trigger: "pressed"
        action: () => console.log("pressed")
    }

    UIF.EventListner {
        trigger: "released"
        action: () => console.log("released")
    }
}
