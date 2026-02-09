pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import UIFramework 1.0 as UIF

UIF.ApplicationWindow {
    id: root

    visible: true
    width: 1480
    height: 980
    title: "UIFramework Visual Gallery"

    property bool alertOpen: false
    property int eventClickCount: 0
    property string eventLastTrigger: "none"

    Component.onCompleted: {
        UIF.Debug.enabled = true
        UIF.Debug.log("Main", "gallery-opened")
        UIF.RenderMonitor.attachWindow(root)
        UIF.PageMonitor.record("/gallery")
    }

    UIF.Alert {
        id: sampleAlert
        anchors.fill: parent
        open: root.alertOpen
        title: "Sample Alert"
        message: "Alert component preview"
        primaryText: "Close"
        secondaryText: "Cancel"
        onPrimaryClicked: {
            root.alertOpen = false
        }
        onSecondaryClicked: {
            root.alertOpen = false
        }
        onDismissed: {
            root.alertOpen = false
        }
    }

    Component {
        id: routeOverview
        Rectangle {
            color: Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.03)
            border.color: UIF.Theme.surfaceAlt
            border.width: 1
            radius: UIF.Theme.radiusMd
            UIF.Label {
                anchors.centerIn: parent
                text: "Router: Overview"
                color: UIF.Theme.textPrimary
                font.pixelSize: 13
            }
        }
    }

    Component {
        id: routeReports
        Rectangle {
            color: Qt.rgba(0 / 255, 122 / 255, 255 / 255, 0.12)
            border.color: UIF.Theme.accent
            border.width: 1
            radius: UIF.Theme.radiusMd
            UIF.Label {
                anchors.centerIn: parent
                text: "Router: Reports"
                color: UIF.Theme.textPrimary
                font.pixelSize: 13
            }
        }
    }

    Component {
        id: routeSettings
        Rectangle {
            color: Qt.rgba(255 / 255, 69 / 255, 58 / 255, 0.12)
            border.color: UIF.Theme.danger
            border.width: 1
            radius: UIF.Theme.radiusMd
            UIF.Label {
                anchors.centerIn: parent
                text: "Router: Settings"
                color: UIF.Theme.textPrimary
                font.pixelSize: 13
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        clip: true

        Item {
            width: Math.max(root.width - 24, 1040)
            implicitHeight: gallery.implicitHeight + 24

            GridLayout {
                id: gallery
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 12
                columns: width >= 1320 ? 2 : 1
                rowSpacing: 12
                columnSpacing: 12

                UIF.AppCard {
                    title: "Runtime"
                    subtitle: "Backend singletons and monitoring"
                    Layout.fillWidth: true
                    Layout.columnSpan: gallery.columns

                    ColumnLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        UIF.Label {
                            text: "Platform: " + UIF.Platform.os + " / " + UIF.Platform.arch
                            color: UIF.Theme.textPrimary
                            font.pixelSize: 13
                        }

                        UIF.Label {
                            text: "RenderMonitor: active=" + UIF.RenderMonitor.active
                                + " fps=" + Number(UIF.RenderMonitor.fps).toFixed(1)
                                + " frameMs=" + Number(UIF.RenderMonitor.lastFrameMs).toFixed(2)
                            color: UIF.Theme.textSecondary
                            font.pixelSize: 12
                        }

                        UIF.Label {
                            text: "PageMonitor: current=" + UIF.PageMonitor.current
                                + " count=" + UIF.PageMonitor.count
                            color: UIF.Theme.textSecondary
                            font.pixelSize: 12
                        }

                        RowLayout {
                            spacing: 8

                            UIF.LabelButton {
                                text: "Open Alert"
                                tone: UIF.AbstractButton.Accent
                                onClicked: root.alertOpen = true
                            }

                            UIF.LabelButton {
                                text: "Stop RenderMonitor"
                                tone: UIF.AbstractButton.Default
                                onClicked: UIF.RenderMonitor.stop()
                            }

                            UIF.LabelButton {
                                text: "Start RenderMonitor"
                                tone: UIF.AbstractButton.Default
                                onClicked: UIF.RenderMonitor.start()
                            }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Buttons"
                    subtitle: "4 types x 5 states (20 cases)"
                    Layout.fillWidth: true
                    Layout.columnSpan: gallery.columns

                    GridLayout {
                        columns: 4
                        rowSpacing: 10
                        columnSpacing: 24
                        Layout.fillWidth: true

                        UIF.LabelButton { text: "Button"; tone: UIF.AbstractButton.Accent }
                        UIF.IconButton { tone: UIF.AbstractButton.Accent }
                        UIF.LabelMenuButton { text: "Open"; tone: UIF.AbstractButton.Accent }
                        UIF.IconMenuButton { tone: UIF.AbstractButton.Accent }

                        UIF.LabelButton { text: "Button"; tone: UIF.AbstractButton.Default }
                        UIF.IconButton { tone: UIF.AbstractButton.Default }
                        UIF.LabelMenuButton { text: "Open"; tone: UIF.AbstractButton.Default }
                        UIF.IconMenuButton { tone: UIF.AbstractButton.Default }

                        UIF.LabelButton { text: "Button"; tone: UIF.AbstractButton.Borderless }
                        UIF.IconButton { tone: UIF.AbstractButton.Borderless }
                        UIF.LabelMenuButton { text: "Open"; tone: UIF.AbstractButton.Borderless }
                        UIF.IconMenuButton { tone: UIF.AbstractButton.Borderless }

                        UIF.LabelButton { text: "Button"; tone: UIF.AbstractButton.Destructive }
                        UIF.IconButton { tone: UIF.AbstractButton.Destructive }
                        UIF.LabelMenuButton { text: "Open"; tone: UIF.AbstractButton.Destructive }
                        UIF.IconMenuButton { tone: UIF.AbstractButton.Destructive }

                        UIF.LabelButton { text: "Button"; tone: UIF.AbstractButton.Disabled }
                        UIF.IconButton { tone: UIF.AbstractButton.Disabled }
                        UIF.LabelMenuButton { text: "Open"; tone: UIF.AbstractButton.Disabled }
                        UIF.IconMenuButton { tone: UIF.AbstractButton.Disabled }
                    }
                }

                UIF.AppCard {
                    title: "Input Fields"
                    subtitle: "5 types x 4 states (20 cases)"
                    Layout.fillWidth: true
                    Layout.columnSpan: gallery.columns

                    GridLayout {
                        columns: 5
                        rowSpacing: 8
                        columnSpacing: 10
                        Layout.fillWidth: true

                        UIF.Label {
                            text: "Type"
                            color: UIF.Theme.textOctonary
                            font.pixelSize: 12
                        }
                        UIF.Label {
                            text: "Empty"
                            color: UIF.Theme.textOctonary
                            font.pixelSize: 12
                        }
                        UIF.Label {
                            text: "Filled"
                            color: UIF.Theme.textOctonary
                            font.pixelSize: 12
                        }
                        UIF.Label {
                            text: "ReadOnly"
                            color: UIF.Theme.textOctonary
                            font.pixelSize: 12
                        }
                        UIF.Label {
                            text: "Disabled"
                            color: UIF.Theme.textOctonary
                            font.pixelSize: 12
                        }

                        UIF.Label { text: "Text"; color: UIF.Theme.textPrimary; font.pixelSize: 12 }
                        UIF.InputField { Layout.preferredWidth: 206; placeholderText: "Placeholder" }
                        UIF.InputField { Layout.preferredWidth: 206; text: "Typed value" }
                        UIF.InputField { Layout.preferredWidth: 206; text: "Typed value"; readOnly: true }
                        UIF.InputField { Layout.preferredWidth: 206; placeholderText: "Placeholder"; enabled: false }

                        UIF.Label { text: "Search"; color: UIF.Theme.textPrimary; font.pixelSize: 12 }
                        UIF.InputField {
                            Layout.preferredWidth: 206
                            placeholderText: "Search"
                            leadingItems: Item {
                                width: 16
                                height: 16

                                Canvas {
                                    anchors.fill: parent
                                    antialiasing: true
                                    onPaint: {
                                        const ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.beginPath()
                                        ctx.arc(6.5, 6.5, 4.0, 0, Math.PI * 2, false)
                                        ctx.lineWidth = 1.5
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()

                                        ctx.beginPath()
                                        ctx.moveTo(9.8, 9.8)
                                        ctx.lineTo(13.2, 13.2)
                                        ctx.lineWidth = 1.5
                                        ctx.lineCap = "round"
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()
                                    }
                                }
                            }
                        }
                        UIF.InputField {
                            Layout.preferredWidth: 206
                            text: "network logs"
                            leadingItems: Item {
                                width: 16
                                height: 16

                                Canvas {
                                    anchors.fill: parent
                                    antialiasing: true
                                    onPaint: {
                                        const ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.beginPath()
                                        ctx.arc(6.5, 6.5, 4.0, 0, Math.PI * 2, false)
                                        ctx.lineWidth = 1.5
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()

                                        ctx.beginPath()
                                        ctx.moveTo(9.8, 9.8)
                                        ctx.lineTo(13.2, 13.2)
                                        ctx.lineWidth = 1.5
                                        ctx.lineCap = "round"
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()
                                    }
                                }
                            }
                        }
                        UIF.InputField {
                            Layout.preferredWidth: 206
                            text: "network logs"
                            readOnly: true
                            leadingItems: Item {
                                width: 16
                                height: 16

                                Canvas {
                                    anchors.fill: parent
                                    antialiasing: true
                                    onPaint: {
                                        const ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.beginPath()
                                        ctx.arc(6.5, 6.5, 4.0, 0, Math.PI * 2, false)
                                        ctx.lineWidth = 1.5
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()

                                        ctx.beginPath()
                                        ctx.moveTo(9.8, 9.8)
                                        ctx.lineTo(13.2, 13.2)
                                        ctx.lineWidth = 1.5
                                        ctx.lineCap = "round"
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()
                                    }
                                }
                            }
                        }
                        UIF.InputField {
                            Layout.preferredWidth: 206
                            placeholderText: "Search"
                            enabled: false
                            leadingItems: Item {
                                width: 16
                                height: 16

                                Canvas {
                                    anchors.fill: parent
                                    antialiasing: true
                                    onPaint: {
                                        const ctx = getContext("2d")
                                        ctx.clearRect(0, 0, width, height)
                                        ctx.beginPath()
                                        ctx.arc(6.5, 6.5, 4.0, 0, Math.PI * 2, false)
                                        ctx.lineWidth = 1.5
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()

                                        ctx.beginPath()
                                        ctx.moveTo(9.8, 9.8)
                                        ctx.lineTo(13.2, 13.2)
                                        ctx.lineWidth = 1.5
                                        ctx.lineCap = "round"
                                        ctx.strokeStyle = UIF.Theme.textOctonary
                                        ctx.stroke()
                                    }
                                }
                            }
                        }

                        UIF.Label { text: "Password"; color: UIF.Theme.textPrimary; font.pixelSize: 12 }
                        UIF.InputField { Layout.preferredWidth: 206; placeholderText: "Password"; echoMode: TextInput.Password }
                        UIF.InputField { Layout.preferredWidth: 206; text: "password123"; echoMode: TextInput.Password }
                        UIF.InputField { Layout.preferredWidth: 206; text: "password123"; echoMode: TextInput.Password; readOnly: true }
                        UIF.InputField { Layout.preferredWidth: 206; placeholderText: "Password"; echoMode: TextInput.Password; enabled: false }

                        UIF.Label { text: "URL"; color: UIF.Theme.textPrimary; font.pixelSize: 12 }
                        UIF.InputField { Layout.preferredWidth: 206; placeholderText: "https://example.com"; inputMethodHints: Qt.ImhUrlCharactersOnly }
                        UIF.InputField { Layout.preferredWidth: 206; text: "https://api.local/v1"; inputMethodHints: Qt.ImhUrlCharactersOnly }
                        UIF.InputField { Layout.preferredWidth: 206; text: "https://api.local/v1"; inputMethodHints: Qt.ImhUrlCharactersOnly; readOnly: true }
                        UIF.InputField { Layout.preferredWidth: 206; placeholderText: "https://example.com"; inputMethodHints: Qt.ImhUrlCharactersOnly; enabled: false }

                        UIF.Label { text: "Numeric"; color: UIF.Theme.textPrimary; font.pixelSize: 12 }
                        UIF.InputField { Layout.preferredWidth: 206; placeholderText: "0"; inputMethodHints: Qt.ImhDigitsOnly }
                        UIF.InputField { Layout.preferredWidth: 206; text: "1024"; inputMethodHints: Qt.ImhDigitsOnly }
                        UIF.InputField { Layout.preferredWidth: 206; text: "1024"; inputMethodHints: Qt.ImhDigitsOnly; readOnly: true }
                        UIF.InputField { Layout.preferredWidth: 206; placeholderText: "0"; inputMethodHints: Qt.ImhDigitsOnly; enabled: false }
                    }
                }

                UIF.AppCard {
                    title: "Check Controls"
                    subtitle: "CheckBox, RadioButton, ToggleSwitch"
                    Layout.fillWidth: true

                    ColumnLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        RowLayout {
                            spacing: 10
                            UIF.CheckBox { text: "Check On"; checked: true }
                            UIF.CheckBox { text: "Check Off"; checked: false }
                            UIF.CheckBox { text: "Check Disabled"; checked: true; enabled: false }
                        }

                        RowLayout {
                            spacing: 10
                            UIF.RadioButton { checked: true; enabled: true }
                            UIF.RadioButton { checked: false; enabled: true }
                            UIF.RadioButton { checked: true; enabled: false }
                            UIF.RadioButton { checked: false; enabled: false }
                            UIF.RadioButton { text: "Radio Label"; checked: true }
                        }

                        RowLayout {
                            spacing: 10
                            UIF.ToggleSwitch { checked: true }
                            UIF.ToggleSwitch { checked: false }
                            UIF.ToggleSwitch { checked: true; enabled: false }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Layout Primitives"
                    subtitle: "VStack, HStack, ZStack, Spacer"
                    Layout.fillWidth: true

                    ColumnLayout {
                        spacing: 10
                        Layout.fillWidth: true

                        UIF.VStack {
                            spacing: 6
                            alignmentName: "leading"
                            Layout.fillWidth: true
                            Rectangle { width: 110; height: 24; radius: 6; color: UIF.Theme.surfaceAlt }
                            Rectangle { width: 140; height: 24; radius: 6; color: UIF.Theme.surfaceSolid }
                        }

                        UIF.HStack {
                            spacing: 6
                            alignmentName: "center"
                            Layout.fillWidth: true
                            Rectangle { width: 80; height: 22; radius: 6; color: UIF.Theme.surfaceAlt }
                            UIF.Spacer { minLength: 24 }
                            Rectangle { width: 80; height: 22; radius: 6; color: UIF.Theme.accent }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 120
                            radius: UIF.Theme.radiusMd
                            color: Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.03)
                            border.color: UIF.Theme.surfaceAlt
                            border.width: 1

                            UIF.ZStack {
                                anchors.fill: parent
                                alignmentName: "center"
                                Rectangle { width: 80; height: 80; radius: 8; color: Qt.rgba(0 / 255, 122 / 255, 255 / 255, 0.25) }
                                Rectangle { width: 52; height: 52; radius: 8; color: Qt.rgba(255 / 255, 69 / 255, 58 / 255, 0.35) }
                            }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Navigation"
                    subtitle: "PageRouter, Link, NavigationLink, LinkWrapper"
                    Layout.fillWidth: true
                    Layout.columnSpan: gallery.columns

                    ColumnLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 160
                            radius: UIF.Theme.radiusMd
                            color: Qt.rgba(255 / 255, 255 / 255, 255 / 255, 0.03)
                            border.color: UIF.Theme.surfaceAlt
                            border.width: 1

                            UIF.PageRouter {
                                id: demoRouter
                                anchors.fill: parent
                                anchors.margins: 8
                                routes: [
                                    { path: "/overview", component: routeOverview },
                                    { path: "/reports", component: routeReports },
                                    { path: "/settings", component: routeSettings }
                                ]
                                initialPath: "/overview"
                            }
                        }

                        RowLayout {
                            spacing: 10

                            UIF.NavigationLink {
                                text: "Overview"
                                to: "/overview"
                                router: demoRouter
                            }

                            UIF.Link {
                                text: "Reports"
                                href: "/reports"
                                router: demoRouter
                            }

                            UIF.LinkWrapper {
                                router: demoRouter
                                href: "/settings"
                                Rectangle {
                                    width: 130
                                    height: 30
                                    radius: 6
                                    color: UIF.Theme.surfaceSolid
                                    border.color: UIF.Theme.surfaceAlt
                                    border.width: 1
                                    UIF.Label {
                                        anchors.centerIn: parent
                                        text: "Settings (wrap)"
                                        color: UIF.Theme.textPrimary
                                        font.pixelSize: 12
                                    }
                                }
                            }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Header"
                    subtitle: "AppHeader action slot"
                    Layout.fillWidth: true
                    Layout.preferredHeight: 96

                    UIF.AppHeader {
                        anchors.fill: parent
                        title: "Header Preview"
                        subtitle: "Action slot + menu button"
                        menuVisible: true
                        onMenuClicked: UIF.Debug.log("Header", "menu-clicked")

                        UIF.LabelButton {
                            text: "Action"
                            tone: UIF.AbstractButton.Borderless
                            onClicked: UIF.Debug.log("Header", "action-clicked")
                        }
                    }
                }

                UIF.AppCard {
                    title: "Scaffold"
                    subtitle: "Embedded AppScaffold preview"
                    Layout.fillWidth: true
                    Layout.columnSpan: gallery.columns
                    Layout.preferredHeight: 420

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: UIF.Theme.radiusMd
                        border.color: UIF.Theme.surfaceAlt
                        border.width: 1
                        color: "transparent"
                        clip: true

                        UIF.AppScaffold {
                            anchors.fill: parent
                            headerTitle: "Scaffold Preview"
                            headerSubtitle: "Navigation + content"
                            navModel: [
                                { label: "Overview", icon: "◉", badge: "4" },
                                { label: "Reports", icon: "▣", badge: "2" },
                                { label: "Settings", icon: "⚙", badge: "1" }
                            ]
                            navTitle: "Preview"

                            ColumnLayout {
                                anchors.fill: parent
                                spacing: 8

                                UIF.Label {
                                    text: "Scaffold content slot"
                                    color: UIF.Theme.textPrimary
                                    font.pixelSize: 13
                                }

                                UIF.HStack {
                                    spacing: 8
                                    Rectangle { width: 90; height: 28; radius: 6; color: UIF.Theme.accent }
                                    Rectangle { width: 90; height: 28; radius: 6; color: UIF.Theme.surfaceSolid }
                                }
                            }
                        }
                    }
                }

                UIF.AppCard {
                    title: "Event Listener"
                    subtitle: "EventListener trigger handling"
                    Layout.fillWidth: true

                    ColumnLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        Rectangle {
                            id: listenerSurface
                            Layout.fillWidth: true
                            Layout.preferredHeight: 72
                            radius: UIF.Theme.radiusMd
                            color: UIF.Theme.surfaceSolid
                            border.color: UIF.Theme.surfaceAlt
                            border.width: 1

                            UIF.Label {
                                anchors.centerIn: parent
                                text: "Click here (" + root.eventClickCount + ")"
                                color: UIF.Theme.textPrimary
                                font.pixelSize: 13
                            }

                            UIF.EventListener {
                                trigger: "clicked"
                                action: function(mouse) {
                                    root.eventClickCount += 1
                                    root.eventLastTrigger = "clicked @" + mouse.x + "," + mouse.y
                                }
                            }
                        }

                        UIF.Label {
                            text: "Last trigger: " + root.eventLastTrigger
                            color: UIF.Theme.textSecondary
                            font.pixelSize: 12
                        }
                    }
                }
            }
        }
    }

    QtObject {
        Component.onCompleted: UIF.Debug.log("Main", "created")
    }
}

// API usage (external):
// import UITestFW 1.0
// Main { visible: true }
