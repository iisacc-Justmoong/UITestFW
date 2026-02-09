import QtQuick
import UIFramework 1.0

Text {
    id: control

    color: Theme.textPrimary
    font.family: Theme.fontBody
    font.pixelSize: Theme.textDescription
    font.weight: Theme.textDescriptionWeight
    elide: Text.ElideRight
    QtObject {
        Component.onCompleted: Debug.log("Label", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.Label { text: "Label" }
