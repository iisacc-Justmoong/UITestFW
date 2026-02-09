import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import UIFramework 1.0 as UIF

ApplicationWindow {
    id: root
    visible: true
    width: 520
    height: 520
    title: "EventListener Examples"

    ScrollView {
        anchors.fill: parent

        Item {
            anchors.fill: parent
            anchors.margins: 16

            ColumnLayout {
                anchors.fill: parent
                spacing: 16

                GroupBox {
                    title: "Basic Click"
                    Layout.fillWidth: true
                    contentItem: Loader { source: "BasicClick.qml" }
                }

                GroupBox {
                    title: "Hover Card"
                    Layout.fillWidth: true
                    contentItem: Loader { source: "HoverCard.qml" }
                }

                GroupBox {
                    title: "Press / Release"
                    Layout.fillWidth: true
                    contentItem: Loader { source: "PressRelease.qml" }
                }

                GroupBox {
                    title: "Right Click"
                    Layout.fillWidth: true
                    contentItem: Loader { source: "RightClick.qml" }
                }

                GroupBox {
                    title: "Key Press"
                    Layout.fillWidth: true
                    contentItem: Loader { source: "KeyPress.qml" }
                }

                GroupBox {
                    title: "Multi Trigger"
                    Layout.fillWidth: true
                    contentItem: Loader { source: "MultiTrigger.qml" }
                }
            }
        }
    }
}
