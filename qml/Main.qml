import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import UITestFW 1.0
import "components"

ApplicationWindow {
    id: root

    visible: true
    width: 1200
    height: 760
    title: "UITestFW"
    color: Theme.window

    property bool ready: false

    Component.onCompleted: ready = true

    AppScaffold {
        id: scaffold
        anchors.fill: parent
        headerTitle: "UITestFW"
        headerSubtitle: "Qt Quick UI shell for test automation"
        navModel: ["Overview", "Suites", "Runs", "Devices", "Reports", "Settings"]

        content: [
            ColumnLayout {
                anchors.fill: parent
                spacing: 24

                Rectangle {
                    id: hero
                    Layout.fillWidth: true
                    Layout.preferredHeight: 180
                    radius: Theme.radiusXl
                    border.color: Theme.border
                    border.width: 1

                    gradient: Gradient {
                        GradientStop { position: 0.0; color: Theme.accentMuted }
                        GradientStop { position: 1.0; color: Theme.surfaceAlt }
                    }

                    opacity: root.ready ? 1 : 0
                    scale: root.ready ? 1 : 0.98

                    Behavior on opacity {
                        NumberAnimation { duration: 420; easing.type: Easing.OutCubic }
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 420; easing.type: Easing.OutCubic }
                    }

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 24
                        spacing: 20

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 10

                            Label {
                                text: "UI Test Lab"
                                color: Theme.textPrimary
                                font.family: Theme.fontDisplay
                                font.pixelSize: 26
                                font.weight: Font.DemiBold
                            }

                            Label {
                                text: "Track suites, run devices, and capture evidence with a QML-first shell."
                                color: Theme.textSecondary
                                font.family: Theme.fontBody
                                font.pixelSize: 13
                                wrapMode: Text.WordWrap
                                Layout.maximumWidth: 520
                            }

                            RowLayout {
                                spacing: 12

                                Button {
                                    text: "New suite"
                                    padding: 12

                                    contentItem: Text {
                                        text: control.text
                                        color: Theme.onAccent
                                        font.family: Theme.fontBody
                                        font.pixelSize: 12
                                        font.weight: Font.DemiBold
                                    }

                                    background: Rectangle {
                                        radius: Theme.radiusMd
                                        color: control.down ? Theme.accentMuted : Theme.accent
                                    }
                                }

                                Button {
                                    text: "Open runner"
                                    padding: 12

                                    contentItem: Text {
                                        text: control.text
                                        color: Theme.textPrimary
                                        font.family: Theme.fontBody
                                        font.pixelSize: 12
                                        font.weight: Font.DemiBold
                                    }

                                    background: Rectangle {
                                        radius: Theme.radiusMd
                                        color: control.down ? Theme.surfaceAlt : "transparent"
                                        border.color: Theme.border
                                        border.width: 1
                                    }
                                }
                            }
                        }

                        Rectangle {
                            width: 120
                            height: 120
                            radius: 60
                            color: Theme.surfaceAlt
                            border.color: Theme.border
                            border.width: 1

                            Column {
                                anchors.centerIn: parent
                                spacing: 6

                                Label {
                                    text: "QML"
                                    color: Theme.textPrimary
                                    font.family: Theme.fontDisplay
                                    font.pixelSize: 20
                                    font.weight: Font.DemiBold
                                    horizontalAlignment: Text.AlignHCenter
                                }

                                Rectangle {
                                    width: 56
                                    height: 6
                                    radius: 3
                                    color: Theme.accent
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }
                            }
                        }
                    }
                }

                GridLayout {
                    id: statsGrid
                    columns: root.width >= 1200 ? 3 : root.width >= 900 ? 2 : 1
                    columnSpacing: 18
                    rowSpacing: 18
                    Layout.fillWidth: true

                    Repeater {
                        model: [
                            { title: "Suites", subtitle: "Active catalogs", value: "12", detail: "4 running" },
                            { title: "Devices", subtitle: "Available now", value: "18", detail: "3 offline" },
                            { title: "Runs", subtitle: "Last 24 hours", value: "46", detail: "+12%" }
                        ]

                        delegate: AppCard {
                            title: modelData.title
                            subtitle: modelData.subtitle
                            Layout.fillWidth: true
                            Layout.preferredHeight: 150

                            opacity: 0

                            SequentialAnimation on opacity {
                                running: root.ready
                                PauseAnimation { duration: index * 80 }
                                NumberAnimation { to: 1; duration: 360; easing.type: Easing.OutCubic }
                            }

                            content: [
                                RowLayout {
                                    spacing: 8
                                    Layout.fillWidth: true

                                    Label {
                                        text: modelData.value
                                        color: Theme.textPrimary
                                        font.family: Theme.fontDisplay
                                        font.pixelSize: 28
                                        font.weight: Font.DemiBold
                                    }

                                    Item { Layout.fillWidth: true }

                                    Rectangle {
                                        width: 64
                                        height: 6
                                        radius: 3
                                        color: Theme.borderSoft

                                        Rectangle {
                                            width: parent.width * 0.7
                                            height: parent.height
                                            radius: 3
                                            color: Theme.accent
                                        }
                                    }
                                },

                                Label {
                                    text: modelData.detail
                                    color: Theme.textSecondary
                                    font.family: Theme.fontBody
                                    font.pixelSize: 12
                                }
                            ]
                        }
                    }
                }

                GridLayout {
                    id: detailGrid
                    columns: root.width >= 1200 ? 2 : 1
                    columnSpacing: 18
                    rowSpacing: 18
                    Layout.fillWidth: true

                    AppCard {
                        title: "Recent runs"
                        subtitle: "Last 3 executions"
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220

                        opacity: 0

                        SequentialAnimation on opacity {
                            running: root.ready
                            PauseAnimation { duration: 120 }
                            NumberAnimation { to: 1; duration: 420; easing.type: Easing.OutCubic }
                        }

                        content: [
                            ColumnLayout {
                                spacing: 10
                                Layout.fillWidth: true

                                Repeater {
                                    model: [
                                        { name: "Login smoke", status: "Running", time: "02:14" },
                                        { name: "Checkout flow", status: "Queued", time: "00:47" },
                                        { name: "Search variants", status: "Passed", time: "00:19" }
                                    ]

                                    delegate: RowLayout {
                                        spacing: 10
                                        Layout.fillWidth: true

                                        Rectangle {
                                            width: 8
                                            height: 8
                                            radius: 4
                                            color: modelData.status === "Passed" ? Theme.success : modelData.status === "Running" ? Theme.accent : Theme.warning
                                        }

                                        Label {
                                            text: modelData.name
                                            color: Theme.textPrimary
                                            font.family: Theme.fontBody
                                            font.pixelSize: 13
                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }

                                        Label {
                                            text: modelData.time
                                            color: Theme.textTertiary
                                            font.family: Theme.fontBody
                                            font.pixelSize: 12
                                        }
                                    }
                                }
                            }
                        ]
                    }

                    AppCard {
                        title: "Device pool"
                        subtitle: "Live capacity"
                        Layout.fillWidth: true
                        Layout.preferredHeight: 220

                        opacity: 0

                        SequentialAnimation on opacity {
                            running: root.ready
                            PauseAnimation { duration: 180 }
                            NumberAnimation { to: 1; duration: 420; easing.type: Easing.OutCubic }
                        }

                        content: [
                            ColumnLayout {
                                spacing: 12
                                Layout.fillWidth: true

                                RowLayout {
                                    spacing: 8
                                    Layout.fillWidth: true

                                Label {
                                    text: "Pixel 8"
                                    color: Theme.textPrimary
                                    font.family: Theme.fontBody
                                    font.pixelSize: 13
                                    Layout.fillWidth: true
                                }

                                Label {
                                    text: "6 slots"
                                    color: Theme.textTertiary
                                    font.family: Theme.fontBody
                                    font.pixelSize: 12
                                }
                                }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 6
                                radius: 3
                                color: Theme.borderSoft

                                Rectangle {
                                    width: parent.width * 0.65
                                    height: parent.height
                                    radius: 3
                                    color: Theme.success
                                }
                            }

                                RowLayout {
                                    spacing: 8
                                    Layout.fillWidth: true

                                Label {
                                    text: "iPhone 15"
                                    color: Theme.textPrimary
                                    font.family: Theme.fontBody
                                    font.pixelSize: 13
                                    Layout.fillWidth: true
                                }

                                Label {
                                    text: "4 slots"
                                    color: Theme.textTertiary
                                    font.family: Theme.fontBody
                                    font.pixelSize: 12
                                }
                                }

                            Rectangle {
                                Layout.fillWidth: true
                                height: 6
                                radius: 3
                                color: Theme.borderSoft

                                Rectangle {
                                    width: parent.width * 0.4
                                    height: parent.height
                                    radius: 3
                                    color: Theme.accent
                                }
                            }
                            }
                        ]
                    }
                }

                Item { Layout.fillHeight: true }
            }
        ]
    }
}
