import QtQuick
import QtQuick.Layouts
import UIFramework 1.0

AbstractButton {
    id: control

    checkable: true
    tone: AbstractButton.Borderless

    property int boxSize: Theme.controlIndicatorSize
    property color checkColor: Theme.textPrimary
    property color checkedColor: Theme.accent
    property color uncheckedColor: "transparent"
    property color disabledCheckedColor: Theme.surfaceAlt
    property color disabledUncheckedColor: "transparent"
    property color boxBorderColor: Theme.surfaceAlt
    property color boxBorderColorDisabled: Theme.surfaceAlt
    property color checkMarkColorDisabled: Theme.textTertiary
    property int checkMarkStrokeWidth: Theme.gap2

    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0
    spacing: Theme.gapNone
    borderWidth: 0
    backgroundColor: "transparent"
    backgroundColorHover: "transparent"
    backgroundColorPressed: "transparent"
    backgroundColorDisabled: "transparent"
    implicitHeight: contentItem.implicitHeight
    implicitWidth: contentItem.implicitWidth

    background: Item { }

    contentItem: RowLayout {
        spacing: control.text.length > 0 ? Theme.gap8 : Theme.gapNone
        Layout.alignment: Qt.AlignVCenter

        Rectangle {
            width: control.boxSize
            height: control.boxSize
            radius: Theme.radiusSm
            color: control.enabled
                ? (control.checked ? control.checkedColor : control.uncheckedColor)
                : (control.checked ? control.disabledCheckedColor : control.disabledUncheckedColor)
            border.color: control.enabled ? control.boxBorderColor : control.boxBorderColorDisabled
            border.width: Theme.strokeThin
            antialiasing: true

            Canvas {
                id: checkmarkCanvas
                anchors.fill: parent
                visible: control.checked
                antialiasing: true

                onPaint: {
                    const ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)
                    if (!control.checked)
                        return

                    ctx.beginPath()
                    ctx.moveTo(width * 0.22, height * 0.55)
                    ctx.lineTo(width * 0.42, height * 0.74)
                    ctx.lineTo(width * 0.78, height * 0.30)
                    ctx.lineWidth = control.checkMarkStrokeWidth
                    ctx.lineCap = "round"
                    ctx.lineJoin = "round"
                    ctx.strokeStyle = control.enabled ? control.checkColor : control.checkMarkColorDisabled
                    ctx.stroke()
                }
            }
        }

        Text {
            text: control.text
            color: control.enabled ? Theme.textPrimary : Theme.textTertiary
            font.family: Theme.fontBody
            font.pixelSize: Theme.textDescription
            font.weight: Theme.textDescriptionWeight
            visible: control.text.length > 0
            Layout.alignment: Qt.AlignVCenter
        }
    }

    onCheckedChanged: checkmarkCanvas.requestPaint()
    onEnabledChanged: checkmarkCanvas.requestPaint()
    onCheckColorChanged: checkmarkCanvas.requestPaint()
    onCheckMarkColorDisabledChanged: checkmarkCanvas.requestPaint()
    QtObject {
        Component.onCompleted: Debug.log("CheckBox", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.CheckBox { text: "Remember me"; checked: true }
