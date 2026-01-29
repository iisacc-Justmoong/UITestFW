import QtQuick
import QtQuick.Controls
import UIFramework 1.0 as UIF

ApplicationWindow {
    id: root
    visible: true
    width: 480
    height: 240
    title: "Example: ViewModel Registry"

    property var vm: UIF.ViewModels.get("Example")

    Column {
        anchors.centerIn: parent
        spacing: 12

        Text {
            text: vm ? ("Status: " + vm.status) : "ViewModel not registered"
        }

        Button {
            text: "Toggle Status"
            enabled: vm !== null
            onClicked: vm.simulateWork()
        }
    }
}
