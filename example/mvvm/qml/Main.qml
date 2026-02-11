import QtQuick
import UIFramework 1.0 as UIF

UIF.ApplicationWindow {
    id: root
    visible: true
    width: 620
    height: 420
    title: "Example: ViewModel Registry"
    subtitle: "Model -> ViewModel -> UIFramework QML"
    navigationEnabled: false

    property var vm: UIF.ViewModels.get("Example")

    Item {
        anchors.fill: parent

        UIF.AppCard {
            id: vmCard
            width: Math.min(parent.width - (UIF.Theme.gap24 * 2), 420)
            anchors.centerIn: parent
            title: "ViewModel Registry"
            subtitle: "Example key: Example"

            Column {
                width: vmCard.width - (vmCard.cardPadding * 2)
                spacing: UIF.Theme.gap12

                UIF.Label {
                    width: parent.width
                    style: body
                    wrapMode: Text.WordWrap
                    text: root.vm
                        ? ("Status: " + root.vm.status)
                        : "ViewModel not registered"
                }

                UIF.LabelButton {
                    width: parent.width
                    text: "Toggle Status"
                    enabled: root.vm !== null
                    tone: enabled ? UIF.AbstractButton.Accent : UIF.AbstractButton.Disabled
                    onClicked: root.vm.simulateWork()
                }
            }
        }
    }
}
