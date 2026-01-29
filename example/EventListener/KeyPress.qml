import QtQuick
import QtQuick.Controls
import UIFramework 1.0 as UIF

TextInput {
    id: input
    focus: true
    width: 200
    placeholderText: "Press Enter"

    UIF.EventListner {
        trigger: "keyPressed"
        action: (event) => {
            if (event.key === Qt.Key_Return)
                console.log("enter")
        }
    }
}
