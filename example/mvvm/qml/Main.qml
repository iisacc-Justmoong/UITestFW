import QtQuick
import LVRS 1.0 as UIF

UIF.ApplicationWindow {
    id: root
    visible: true
    width: 620
    height: 420
    title: "Example: ViewModel Registry"
    subtitle: "Model -> ViewModel -> LVRS QML"
    navigationEnabled: false

    property string viewId: "ExampleView"
    property var vm: UIF.ViewModels.getForView(root.viewId)
    property bool writeEnabled: UIF.ViewModels.canWrite(root.viewId)

    Component.onCompleted: {
        UIF.ViewModels.bindView(root.viewId, "Example", true)
    }

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
                    text: "Toggle Status (ownership write)"
                    enabled: root.vm !== null && root.writeEnabled
                    tone: enabled ? UIF.AbstractButton.Primary : UIF.AbstractButton.Disabled
                    onClicked: {
                        const nextStatus = root.vm.status === "Idle" ? "Working" : "Idle"
                        UIF.ViewModels.updateProperty(root.viewId, "status", nextStatus)
                    }
                }

                UIF.Label {
                    width: parent.width
                    style: caption
                    color: UIF.Theme.textTertiary
                    text: "owner=" + UIF.ViewModels.ownerOf("Example")
                }
            }
        }
    }
}
