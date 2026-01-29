import QtQuick
import UIFramework 1.0 as UIF

Rectangle {
    width: 180
    height: 60
    color: "#222"

    UIF.EventListner {
        trigger: "entered"
        action: () => console.log("hover enter")
    }

    UIF.EventListner {
        trigger: "exited"
        action: () => console.log("hover exit")
    }

    UIF.EventListner {
        trigger: "clicked"
        action: () => console.log("clicked")
    }
}
