import QtQuick
import UIFramework 1.0 as UIF

Rectangle {
    width: 180
    height: 60
    color: "#222"

    UIF.EventListener {
        trigger: "entered"
        action: () => console.log("hover enter")
    }

    UIF.EventListener {
        trigger: "exited"
        action: () => console.log("hover exit")
    }

    UIF.EventListener {
        trigger: "clicked"
        action: () => console.log("clicked")
    }
}
