import QtQuick
import UIFramework 1.0
import UIFramework 1.0 as UIF

Text {
    id: control

    color: Theme.textPrimary
    font.family: Theme.fontBody
    font.pixelSize: 12
    elide: Text.ElideRight
    QtObject {
        Component.onCompleted: UIF.Debug.log("Label", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.Label { text: "Label" }
