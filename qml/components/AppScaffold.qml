import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import UITestFW 1.0

Item {
    id: root

    property string headerTitle: "UITestFW"
    property string headerSubtitle: ""
    property var navModel: ["Overview", "Suites", "Runs", "Devices", "Reports", "Settings"]
    property int navIndex: 0

    property alias headerActions: appHeader.actions

    default property alias content: contentArea.data

    readonly property bool wide: width >= 980

    implicitWidth: 1200
    implicitHeight: 760

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
            menuVisible: !root.wide
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
                visible: root.wide
                width: root.wide ? 220 : 0
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

                    Label {
                        text: "Navigation"
                        color: Theme.textTertiary
                        font.family: Theme.fontBody
                        font.pixelSize: 11
                        font.weight: Font.DemiBold
                        font.letterSpacing: 1.2
                    }

                    Repeater {
                        model: root.navModel

                        delegate: ItemDelegate {
                            width: parent.width
                            text: modelData
                            highlighted: index === root.navIndex
                            padding: 10

                        contentItem: Text {
                            text: control.text
                            color: control.highlighted ? Theme.textPrimary : Theme.textSecondary
                            font.family: Theme.fontBody
                            font.pixelSize: 13
                        }

                        background: Rectangle {
                            radius: Theme.radiusSm
                            color: control.highlighted ? Theme.accentMuted : "transparent"
                            border.color: control.highlighted ? Theme.border : "transparent"
                            border.width: 1
                        }

                            onClicked: root.navIndex = index
                        }
                    }
                }
            }

            Item {
                id: contentWrap
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.right: parent.right
                anchors.left: root.wide ? navRail.right : parent.left
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
        width: 240
        height: root.height
        edge: Qt.LeftEdge
        modal: true
        interactive: !root.wide
        visible: !root.wide

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

            Repeater {
                model: root.navModel

                delegate: ItemDelegate {
                    width: parent.width
                    text: modelData
                    highlighted: index === root.navIndex
                    padding: 10

                    contentItem: Text {
                        text: control.text
                        color: control.highlighted ? Theme.textPrimary : Theme.textSecondary
                        font.family: Theme.fontBody
                        font.pixelSize: 13
                    }

                    background: Rectangle {
                        radius: Theme.radiusSm
                        color: control.highlighted ? Theme.accentMuted : "transparent"
                        border.color: control.highlighted ? Theme.border : "transparent"
                        border.width: 1
                    }

                    onClicked: {
                        root.navIndex = index
                        navDrawer.close()
                    }
                }
            }
        }
    }
}
