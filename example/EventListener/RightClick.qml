import QtQuick
import UIFramework 1.0 as UIF

UIF.Label {
    text: "Right click"
    UIF.EventListener {
        trigger: "clicked"
        acceptedButtons: Qt.RightButton
        action: () => console.log("right click")
    }
}
