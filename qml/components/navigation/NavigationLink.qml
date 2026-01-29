import QtQuick
import UIFramework 1.0
import UIFramework 1.0 as UIF

Link {
    id: control

    property alias to: control.href
    QtObject {
        Component.onCompleted: UIF.Debug.log("NavigationLink", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.NavigationLink { text: "Reports"; to: "/reports"; router: pageRouter }
