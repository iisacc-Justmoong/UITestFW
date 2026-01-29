import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import UIFramework 1.0

Item {
    id: root

    property string headerTitle: "UITestFW"
    property string headerSubtitle: ""
    property var navModel: ["Overview", "Suites", "Runs", "Devices", "Reports", "Settings"]
    property int navIndex: 0
    property bool navigationEnabled: true
    property string navTitle: "Navigation"
    property bool navTitleVisible: true
    property int navWidth: 220
    property int navDrawerWidth: 240
    property int wideBreakpoint: 980
    property Component navDelegate: null
    property Component navHeader: null
    property Component navFooter: null
    property var pageRouter: null

    signal navActivated(int index, var item)

    property alias headerActions: appHeader.actions

    default property alias content: contentArea.data

    readonly property bool wide: width >= wideBreakpoint
    readonly property bool hasNav: navigationEnabled && navModel && (navModel.length !== undefined ? navModel.length > 0 : navModel.count > 0)

    implicitWidth: 1200
    implicitHeight: 760

    function routeForItem(item) {
        if (item && typeof item === "object")
            return item.path || item.route || ""
        return ""
    }

    function paramsForItem(item) {
        if (item && typeof item === "object" && item.params !== undefined)
            return item.params
        return ({})
    }

    onWideChanged: {
        if (wide && navDrawer.opened)
            navDrawer.close()
    }

    Component {
        id: defaultNavDelegate

        ItemDelegate {
            property var item: modelData
            property string itemLabel: typeof item === "string" ? item : (item.label || item.title || item.text || "")
            property string itemIcon: typeof item === "object" ? (item.icon || item.iconName || item.symbol || "") : ""
            property string itemBadge: typeof item === "object" && item.badge !== undefined ? String(item.badge) : ""
            property bool itemEnabled: typeof item === "object" && item.enabled !== undefined ? item.enabled : true

            width: parent ? parent.width : implicitWidth
            text: itemLabel
            enabled: itemEnabled
            highlighted: index === root.navIndex
            padding: 10

            contentItem: RowLayout {
                spacing: 8
                Layout.fillWidth: true

                Label {
                    visible: itemIcon.length > 0
                    text: itemIcon
                    color: control.highlighted ? Theme.textPrimary : Theme.textTertiary
                    font.family: Theme.fontDisplay
                    font.pixelSize: 12
                }

                Label {
                    text: control.text
                    color: control.highlighted ? Theme.textPrimary : Theme.textSecondary
                    font.family: Theme.fontBody
                    font.pixelSize: 13
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Rectangle {
                    visible: itemBadge.length > 0
                    radius: 8
                    color: control.highlighted ? Theme.accent : Theme.borderSoft
                    Layout.preferredHeight: 18
                    Layout.preferredWidth: Math.max(18, badgeText.implicitWidth + 10)

                    Label {
                        id: badgeText
                        anchors.centerIn: parent
                        text: itemBadge
                        color: control.highlighted ? Theme.onAccent : Theme.textPrimary
                        font.family: Theme.fontBody
                        font.pixelSize: 10
                    }
                }
            }

            background: Rectangle {
                radius: Theme.radiusSm
                color: control.highlighted ? Theme.accentMuted : "transparent"
                border.color: control.highlighted ? Theme.border : "transparent"
                border.width: 1
            }

            onClicked: {
                root.navIndex = index
                root.navActivated(index, item)
                var path = root.routeForItem(item)
                if (root.pageRouter && path)
                    root.pageRouter.go(path, root.paramsForItem(item))
            }
        }
    }

    Component {
        id: defaultDrawerDelegate

        ItemDelegate {
            property var item: modelData
            property string itemLabel: typeof item === "string" ? item : (item.label || item.title || item.text || "")
            property string itemIcon: typeof item === "object" ? (item.icon || item.iconName || item.symbol || "") : ""
            property string itemBadge: typeof item === "object" && item.badge !== undefined ? String(item.badge) : ""
            property bool itemEnabled: typeof item === "object" && item.enabled !== undefined ? item.enabled : true

            width: parent ? parent.width : implicitWidth
            text: itemLabel
            enabled: itemEnabled
            highlighted: index === root.navIndex
            padding: 10

            contentItem: RowLayout {
                spacing: 8
                Layout.fillWidth: true

                Label {
                    visible: itemIcon.length > 0
                    text: itemIcon
                    color: control.highlighted ? Theme.textPrimary : Theme.textTertiary
                    font.family: Theme.fontDisplay
                    font.pixelSize: 12
                }

                Label {
                    text: control.text
                    color: control.highlighted ? Theme.textPrimary : Theme.textSecondary
                    font.family: Theme.fontBody
                    font.pixelSize: 13
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                }

                Rectangle {
                    visible: itemBadge.length > 0
                    radius: 8
                    color: control.highlighted ? Theme.accent : Theme.borderSoft
                    Layout.preferredHeight: 18
                    Layout.preferredWidth: Math.max(18, badgeText.implicitWidth + 10)

                    Label {
                        id: badgeText
                        anchors.centerIn: parent
                        text: itemBadge
                        color: control.highlighted ? Theme.onAccent : Theme.textPrimary
                        font.family: Theme.fontBody
                        font.pixelSize: 10
                    }
                }
            }

            background: Rectangle {
                radius: Theme.radiusSm
                color: control.highlighted ? Theme.accentMuted : "transparent"
                border.color: control.highlighted ? Theme.border : "transparent"
                border.width: 1
            }

            onClicked: {
                root.navIndex = index
                root.navActivated(index, item)
                var path = root.routeForItem(item)
                if (root.pageRouter && path)
                    root.pageRouter.go(path, root.paramsForItem(item))
                navDrawer.close()
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: Theme.window

        gradient: Gradient {
            GradientStop { position: 0.0; color: Theme.window }
            GradientStop { position: 0.6; color: Theme.windowAlt }
            GradientStop { position: 1.0; color: Theme.window }
        }

        Rectangle {
            width: 520
            height: 520
            radius: 260
            color: Theme.accentGlow
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.rightMargin: -140
            anchors.topMargin: -200
        }

        Rectangle {
            width: 640
            height: 380
            radius: 220
            color: Theme.accentMuted
            opacity: 0.3
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            anchors.leftMargin: -200
            anchors.bottomMargin: -180
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        AppHeader {
            id: appHeader
            title: root.headerTitle
            subtitle: root.headerSubtitle
            menuVisible: root.hasNav && !root.wide
            Layout.fillWidth: true
            Layout.preferredHeight: implicitHeight
            onMenuClicked: navDrawer.open()
        }

        Item {
            id: contentRoot
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                id: navRail
                visible: root.hasNav && root.wide
                width: root.hasNav && root.wide ? root.navWidth : 0
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: parent.left
                anchors.margins: Theme.pageMargin
                radius: Theme.radiusLg
                color: Theme.surfaceSolid
                border.color: Theme.border
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    Loader {
                        active: root.navHeader !== null
                        sourceComponent: root.navHeader
                        visible: active
                        Layout.fillWidth: true
                    }

                    Label {
                        visible: root.navTitleVisible
                        text: root.navTitle
                        color: Theme.textTertiary
                        font.family: Theme.fontBody
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        font.letterSpacing: 1.2
                    }

                    Repeater {
                        model: root.navModel
                        delegate: root.navDelegate ? root.navDelegate : defaultNavDelegate
                    }

                    Loader {
                        active: root.navFooter !== null
                        sourceComponent: root.navFooter
                        visible: active
                        Layout.fillWidth: true
                    }
                }
            }

            Item {
                id: contentWrap
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.left: root.hasNav && root.wide ? navRail.right : parent.left
                anchors.margins: Theme.pageMargin
            }

            Rectangle {
                anchors.fill: contentWrap
                radius: Theme.radiusXl
                color: Theme.surfaceAlt
                border.color: Theme.border
                border.width: 1
            }

            Item {
                id: contentArea
                anchors.fill: contentWrap
                anchors.margins: Theme.contentMargin
            }
        }
    }

    Drawer {
        id: navDrawer
        width: root.navDrawerWidth
        height: root.height
        edge: Qt.LeftEdge
        modal: true
        interactive: root.hasNav && !root.wide

        background: Rectangle {
            color: Theme.surfaceSolid
            border.color: Theme.border
            border.width: 1
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.pageMargin
            spacing: 12

            Label {
                text: root.headerTitle
                color: Theme.textPrimary
                font.family: Theme.fontDisplay
                font.pixelSize: 18
                font.weight: Font.DemiBold
            }

            Loader {
                active: root.navHeader !== null
                sourceComponent: root.navHeader
                visible: active
                Layout.fillWidth: true
            }

            Label {
                visible: root.navTitleVisible
                text: root.navTitle
                color: Theme.textTertiary
                font.family: Theme.fontBody
                font.pixelSize: 11
                font.weight: Font.DemiBold
                font.letterSpacing: 1.2
            }

            Repeater {
                model: root.navModel
                delegate: root.navDelegate ? root.navDelegate : defaultDrawerDelegate
            }

            Loader {
                active: root.navFooter !== null
                sourceComponent: root.navFooter
                visible: active
                Layout.fillWidth: true
            }
        }
    }
    QtObject {
        Component.onCompleted: Debug.log("AppScaffold", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.AppScaffold { headerTitle: "UITestFW"; navModel: ["Overview"] }
