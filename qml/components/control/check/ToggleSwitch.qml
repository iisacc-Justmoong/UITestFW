import QtQuick
import QtQuick.Controls as Controls
import UIFramework 1.0

Controls.Switch {
    id: control

    text: ""

    property int trackWidth: 38
    property int trackHeight: 22
    property int trackPadding: 2
    property int knobSize: 18
    property int transitionDuration: 140

    property color onColor: Theme.accent
    property color offColor: Theme.surfaceSolid
    property color disabledTrackColor: Theme.surfaceAlt
    property color trackShadowColor: "#40000000"
    property color knobFillColor: Theme.textPrimary
    property color knobStrokeColor: "#D0D7E2"
    readonly property int knobXOff: trackPadding
    readonly property int knobXOn: Math.max(trackPadding, trackWidth - knobSize - trackPadding)

    spacing: text.length > 0 ? 8 : 0
    leftPadding: 0
    rightPadding: 0
    topPadding: 0
    bottomPadding: 0

    implicitWidth: indicator.implicitWidth
                   + (text.length > 0 ? spacing + contentItem.implicitWidth : 0)
    implicitHeight: Math.max(indicator.implicitHeight, contentItem.implicitHeight)

    indicator: Item {
        implicitWidth: control.trackWidth
        implicitHeight: control.trackHeight

        Rectangle {
            anchors.fill: parent
            anchors.topMargin: 1
            radius: height / 2
            color: control.trackShadowColor
            opacity: 0.3
        }

        Rectangle {
            id: track
            anchors.fill: parent
            radius: height / 2
            color: !control.enabled
                ? control.disabledTrackColor
                : control.checked
                    ? control.onColor
                    : control.offColor
            border.width: 0
            antialiasing: true
        }

        Item {
            id: knob
            width: control.knobSize
            height: control.knobSize
            y: (track.height - height) / 2
            x: control.checked ? control.knobXOn : control.knobXOff

            Behavior on x {
                NumberAnimation {
                    duration: control.transitionDuration
                    easing.type: Easing.OutCubic
                }
            }

            Canvas {
                id: knobCanvas
                anchors.fill: parent
                opacity: control.enabled ? 1.0 : 0.55
                antialiasing: true

                onPaint: {
                    const ctx = getContext("2d")
                    ctx.clearRect(0, 0, width, height)

                    const radius = Math.max(0, Math.min(width, height) * 0.5 - 0.75)
                    ctx.beginPath()
                    ctx.arc(width * 0.5, height * 0.5, radius, 0, Math.PI * 2, false)
                    ctx.fillStyle = control.knobFillColor
                    ctx.fill()
                    ctx.lineWidth = 1.5
                    ctx.strokeStyle = control.knobStrokeColor
                    ctx.stroke()
                }
            }
        }
    }

    onKnobFillColorChanged: knobCanvas.requestPaint()
    onKnobStrokeColorChanged: knobCanvas.requestPaint()

    contentItem: Text {
        text: control.text
        color: control.enabled ? Theme.textPrimary : Theme.textOctonary
        font.family: Theme.fontBody
        font.pixelSize: Theme.textBody
        verticalAlignment: Text.AlignVCenter
        visible: control.text.length > 0
        elide: Text.ElideRight
    }

    QtObject {
        Component.onCompleted: Debug.log("ToggleSwitch", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.ToggleSwitch { checked: true }
