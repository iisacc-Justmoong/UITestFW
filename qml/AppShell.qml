import QtQuick
import LVRS 1.0

ApplicationWindow {
    id: root

    QtObject {
        Component.onCompleted: Debug.log("AppShell", "created")
    }

}

// API usage (external):
// import LVRS as UIF
// UIF.AppShell { title: "LVRS"; navItems: ["Overview"] }
