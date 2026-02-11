import QtQuick
import LVRS 1.0

Link {
    id: control

    property alias to: control.href
    QtObject {
        Component.onCompleted: Debug.log("NavigationLink", "created")
    }

}

// API usage (external):
// import LVRS 1.0 as UIF
// UIF.NavigationLink { text: "Reports"; to: "/reports"; router: pageRouter }
