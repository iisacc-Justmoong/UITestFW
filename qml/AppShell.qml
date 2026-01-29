import QtQuick
import QtQuick.Layouts
import UIFramework 1.0
import UIFramework 1.0 as UIF

ApplicationWindow {
    id: root

    property string subtitle: ""
    property var navItems: ["Overview", "Suites", "Runs", "Devices", "Reports", "Settings"]

    property alias navIndex: scaffold.navIndex
    property alias navigationEnabled: scaffold.navigationEnabled
    property alias navTitle: scaffold.navTitle
    property alias navTitleVisible: scaffold.navTitleVisible
    property alias navWidth: scaffold.navWidth
    property alias navDrawerWidth: scaffold.navDrawerWidth
    property alias wideBreakpoint: scaffold.wideBreakpoint
    property alias navDelegate: scaffold.navDelegate
    property alias navHeader: scaffold.navHeader
    property alias navFooter: scaffold.navFooter
    property alias headerActions: scaffold.headerActions
    default property alias content: scaffold.content

    signal navActivated(int index, var item)

    AppScaffold {
        id: scaffold
        anchors.fill: parent
        headerTitle: root.title
        headerSubtitle: root.subtitle
        navModel: root.navItems
        onNavActivated: root.navActivated(index, item)
    }
    QtObject {
        Component.onCompleted: UIF.Debug.log("AppShell", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.AppShell { title: "UITestFW"; navItems: ["Overview"] }
