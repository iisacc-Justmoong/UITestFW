import QtQuick
import LVRS 1.0 as LV

LV.ApplicationWindow {
    id: root
    visible: true
    width: 620
    height: 420
    title: "Example: ViewModel Registry"
    subtitle: "Model -> ViewModel -> LVRS QML"
    navigationEnabled: false

    property string viewId: "ExampleView"
    property var vm: LV.ViewModels.getForView(root.viewId)
    property bool writeEnabled: LV.ViewModels.canWrite(root.viewId)

    Component.onCompleted: {
        LV.ViewModels.bindView(root.viewId, "Example", true)
    }

    Item {
        anchors.fill: parent

        LV.AppCard {
            id: vmCard
            width: Math.min(parent.width - (LV.Theme.gap24 * 2), 420)
            anchors.centerIn: parent
            title: "ViewModel Registry"
            subtitle: "Example key: Example"

            Column {
                width: vmCard.width - (vmCard.cardPadding * 2)
                spacing: LV.Theme.gap12

                LV.Label {
                    width: parent.width
                    style: body
                    wrapMode: Text.WordWrap
                    text: root.vm
                        ? ("Status: " + root.vm.status)
                        : "ViewModel not registered"
                }

                LV.LabelButton {
                    width: parent.width
                    text: "Toggle Status (ownership write)"
                    enabled: root.vm !== null && root.writeEnabled
                    tone: enabled ? LV.AbstractButton.Primary : LV.AbstractButton.Disabled
                    onClicked: {
                        const nextStatus = root.vm.status === "Idle" ? "Working" : "Idle"
                        LV.ViewModels.updateProperty(root.viewId, "status", nextStatus)
                    }
                }

                LV.Label {
                    width: parent.width
                    style: caption
                    color: LV.Theme.textTertiary
                    text: "owner=" + LV.ViewModels.ownerOf("Example")
                }
            }
        }
    }
}
