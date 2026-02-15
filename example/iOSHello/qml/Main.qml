import QtQuick
import QtQuick.Layouts
import LVRS 1.0 as LV

LV.ApplicationWindow {
    id: root

    visible: true
    width: 780
    height: 540
    title: "iOS Hello"
    subtitle: "LVRS Example"
    navigationEnabled: false

    LV.AppCard {
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.82, 560)
        title: "iOS Demo"
        subtitle: "Hello World!"

        ColumnLayout {
            width: parent.width - (LV.Theme.gap24 * 2)
            spacing: LV.Theme.gap8

            LV.Label {
                Layout.fillWidth: true
                style: header
                text: "Hello World!"
            }

            LV.Label {
                Layout.fillWidth: true
                style: body
                wrapMode: Text.WordWrap
                text: "This app verifies LVRS iOS bootstrap and simulator install flow."
            }
        }
    }
}
