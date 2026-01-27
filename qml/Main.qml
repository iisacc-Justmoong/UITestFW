import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import UIFramework 1.0 as UIF

UIF.AppShell {
    id: root

    visible: true
    width: 1200
    height: 760
    title: "UITestFW"
    subtitle: "Qt Quick UI shell for test automation"
    navItems: ["Overview", "Suites", "Runs", "Devices", "Reports", "Settings"]

    property bool ready: false

    Component.onCompleted: ready = true

    ColumnLayout {
        anchors.fill: parent
        spacing: 24

        Rectangle {
            id: hero
            Layout.fillWidth: true
            Layout.preferredHeight: 180
            radius: UIF.Theme.radiusXl
            border.color: UIF.Theme.border
            border.width: 1

            gradient: Gradient {
                GradientStop { position: 0.0; color: UIF.Theme.accentMuted }
                GradientStop { position: 1.0; color: UIF.Theme.surfaceAlt }
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
                        color: UIF.Theme.textPrimary
                        font.family: UIF.Theme.fontDisplay
                        font.pixelSize: 26
                        font.weight: Font.DemiBold
                    }

                    Label {
                        text: "Track suites, run devices, and capture evidence with a QML-first shell."
                        color: UIF.Theme.textSecondary
                        font.family: UIF.Theme.fontBody
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
                                color: UIF.Theme.onAccent
                                font.family: UIF.Theme.fontBody
                                font.pixelSize: 12
                                font.weight: Font.DemiBold
                            }

                            background: Rectangle {
                                radius: UIF.Theme.radiusMd
                                color: control.down ? UIF.Theme.accentMuted : UIF.Theme.accent
                            }
                        }

                        Button {
                            text: "Open runner"
                            padding: 12

                            contentItem: Text {
                                text: control.text
                                color: UIF.Theme.textPrimary
                                font.family: UIF.Theme.fontBody
                                font.pixelSize: 12
                                font.weight: Font.DemiBold
                            }

                            background: Rectangle {
                                radius: UIF.Theme.radiusMd
                                color: control.down ? UIF.Theme.surfaceAlt : "transparent"
                                border.color: UIF.Theme.border
                                border.width: 1
                            }
                        }
                    }
                }

                Rectangle {
                    width: 120
                    height: 120
                    radius: 60
                    color: UIF.Theme.surfaceAlt
                    border.color: UIF.Theme.border
                    border.width: 1

                    Column {
                        anchors.centerIn: parent
                        spacing: 6

                        Label {
                            text: "QML"
                            color: UIF.Theme.textPrimary
                            font.family: UIF.Theme.fontDisplay
                            font.pixelSize: 20
                            font.weight: Font.DemiBold
                            horizontalAlignment: Text.AlignHCenter
                        }

                        Rectangle {
                            width: 56
                            height: 6
                            radius: 3
                            color: UIF.Theme.accent
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

                delegate: UIF.AppCard {
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

                    RowLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        Label {
                            text: modelData.value
                            color: UIF.Theme.textPrimary
                            font.family: UIF.Theme.fontDisplay
                            font.pixelSize: 28
                            font.weight: Font.DemiBold
                        }

                        Item { Layout.fillWidth: true }

                        Rectangle {
                            width: 64
                            height: 6
                            radius: 3
                            color: UIF.Theme.borderSoft

                            Rectangle {
                                width: parent.width * 0.7
                                height: parent.height
                                radius: 3
                                color: UIF.Theme.accent
                            }
                        }
                    }

                    Label {
                        text: modelData.detail
                        color: UIF.Theme.textSecondary
                        font.family: UIF.Theme.fontBody
                        font.pixelSize: 12
                    }
                }
            }
        }

        GridLayout {
            id: detailGrid
            columns: root.width >= 1200 ? 2 : 1
            columnSpacing: 18
            rowSpacing: 18
            Layout.fillWidth: true

            UIF.AppCard {
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
                                color: modelData.status === "Passed" ? UIF.Theme.success : modelData.status === "Running" ? UIF.Theme.accent : UIF.Theme.warning
                            }

                            Label {
                                text: modelData.name
                                color: UIF.Theme.textPrimary
                                font.family: UIF.Theme.fontBody
                                font.pixelSize: 13
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                            }

                            Label {
                                text: modelData.time
                                color: UIF.Theme.textTertiary
                                font.family: UIF.Theme.fontBody
                                font.pixelSize: 12
                            }
                        }
                    }
                }
            }

            UIF.AppCard {
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

                ColumnLayout {
                    spacing: 12
                    Layout.fillWidth: true

                    RowLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        Label {
                            text: "Pixel 8"
                            color: UIF.Theme.textPrimary
                            font.family: UIF.Theme.fontBody
                            font.pixelSize: 13
                            Layout.fillWidth: true
                        }

                        Label {
                            text: "6 slots"
                            color: UIF.Theme.textTertiary
                            font.family: UIF.Theme.fontBody
                            font.pixelSize: 12
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 6
                        radius: 3
                        color: UIF.Theme.borderSoft

                        Rectangle {
                            width: parent.width * 0.65
                            height: parent.height
                            radius: 3
                            color: UIF.Theme.success
                        }
                    }

                    RowLayout {
                        spacing: 8
                        Layout.fillWidth: true

                        Label {
                            text: "iPhone 15"
                            color: UIF.Theme.textPrimary
                            font.family: UIF.Theme.fontBody
                            font.pixelSize: 13
                            Layout.fillWidth: true
                        }

                        Label {
                            text: "4 slots"
                            color: UIF.Theme.textTertiary
                            font.family: UIF.Theme.fontBody
                            font.pixelSize: 12
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 6
                        radius: 3
                        color: UIF.Theme.borderSoft

                        Rectangle {
                            width: parent.width * 0.4
                            height: parent.height
                            radius: 3
                            color: UIF.Theme.accent
                        }
                    }
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
