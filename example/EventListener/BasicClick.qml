import QtQuick
import UIFramework 1.0 as UIF

UIF.Label {
    text: "Click me"
    UIF.EventListner {
        trigger: "clicked"
        action: () => console.log("Label clicked")
    }
}
