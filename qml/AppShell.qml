import QtQuick
import UIFramework 1.0

ApplicationWindow {
    id: root

    QtObject {
        Component.onCompleted: Debug.log("AppShell", "created")
    }

}

// API usage (external):
// import UIFramework as UIF
// UIF.AppShell { title: "UITestFW"; navItems: ["Overview"] }
