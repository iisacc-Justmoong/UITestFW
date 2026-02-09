import QtQuick
import QtQuick.Layouts
import UIFramework 1.0

AbstractButton {
    id: control

    tone: AbstractButton.Accent
    readonly property color indicatorColor: !control.effectiveEnabled
        ? Theme.textOctonary
        : control.tone === AbstractButton.Borderless
            ? Theme.accent
            : control.tone === AbstractButton.Accent || control.tone === AbstractButton.Destructive
                ? Theme.textPrimary
                : Theme.textPrimary

    horizontalPadding: 7
    verticalPadding: 7
    spacing: 4
    cornerRadius: Theme.radiusMd
    borderWidth: 0
    implicitHeight: contentItem.implicitHeight + topPadding + bottomPadding
    implicitWidth: contentItem.implicitWidth + leftPadding + rightPadding

    textColor: control.tone === AbstractButton.Borderless ? Theme.accent : Theme.textPrimary
    textColorDisabled: Theme.textOctonary

    backgroundColor: control.tone === AbstractButton.Accent
        ? Theme.accent
        : control.tone === AbstractButton.Destructive
            ? Theme.danger
            : control.tone === AbstractButton.Borderless
                ? "transparent"
                : Theme.surfaceSolid
    backgroundColorHover: control.backgroundColor
    backgroundColorPressed: control.backgroundColor
    backgroundColorDisabled: Theme.subSurface

    contentItem: RowLayout {
        spacing: 4
        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

        Text {
            text: control.text
            color: control.effectiveEnabled ? control.textColor : control.textColorDisabled
            font.family: Theme.fontBody
            font.pixelSize: 13
            font.weight: Font.Normal
            elide: Text.ElideRight
            Layout.alignment: Qt.AlignVCenter
        }

        Canvas {
            id: indicatorCanvas
            width: 16
            height: 16
            Layout.preferredWidth: 16
            Layout.preferredHeight: 16
            Layout.minimumWidth: 16
            Layout.minimumHeight: 16
            Layout.maximumWidth: 16
            Layout.maximumHeight: 16
            Layout.alignment: Qt.AlignVCenter
            antialiasing: true

            onPaint: {
                const ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                ctx.beginPath()
                ctx.moveTo(4.5, 6.25)
                ctx.lineTo(8.0, 9.75)
                ctx.lineTo(11.5, 6.25)
                ctx.lineWidth = 1.6
                ctx.lineCap = "round"
                ctx.lineJoin = "round"
                ctx.strokeStyle = control.indicatorColor
                ctx.stroke()
            }
        }
    }

    onIndicatorColorChanged: indicatorCanvas.requestPaint()

    QtObject {
        Component.onCompleted: Debug.log("LabelMenuButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.LabelMenuButton { text: "Open"; tone: UIF.AbstractButton.Default }
