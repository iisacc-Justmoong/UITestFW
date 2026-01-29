import QtQuick
import UIFramework 1.0

Link {
    id: control

    property alias to: control.href
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.NavigationLink { text: "Reports"; to: "/reports"; router: pageRouter }
