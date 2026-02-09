import QtQuick
import UIFramework 1.0

AbstractInputBar {
    id: control

    property alias placeholder: control.placeholderText
    property bool clearButtonVisible: true
    property color clearIconBackgroundColor: Theme.textTertiary
    property color clearIconBackgroundColorDisabled: Theme.textOctonary
    property color clearIconForegroundColor: Theme.subSurface

    readonly property bool showClearButton: clearButtonVisible
        && enabled
        && !readOnly
        && text.length > 0

    implicitWidth: 206
    fieldMinHeight: 22
    insetHorizontal: 7
    insetVertical: 3
    sideSpacing: 5
    cornerRadius: 5
    borderWidth: 0

    textColor: Theme.textPrimary
    textColorDisabled: Theme.textOctonary
    placeholderColor: Theme.textPrimary
    placeholderColorDisabled: Theme.textPrimary
    placeholderOpacity: 0.33

    backgroundColor: Theme.subSurface
    backgroundColorFocused: Theme.subSurface
    backgroundColorDisabled: Theme.subSurface

    borderColor: "transparent"
    borderColorFocused: "transparent"
    borderColorDisabled: "transparent"

    selectionColor: Theme.accent
    selectedTextColor: Theme.textPrimary

    cursorDelegate: Rectangle {
        id: cursorHandle
        width: 1
        height: 16
        radius: 0.5
        color: Theme.textTertiary
        visible: control.focused && control.enabled && !control.readOnly
        opacity: visible ? 1.0 : 0.0

        SequentialAnimation {
            running: cursorHandle.visible
            loops: Animation.Infinite

            NumberAnimation {
                target: cursorHandle
                property: "opacity"
                to: 1.0
                duration: 520
            }

            NumberAnimation {
                target: cursorHandle
                property: "opacity"
                to: 0.0
                duration: 520
            }
        }

        onVisibleChanged: opacity = visible ? 1.0 : 0.0
    }

    trailingItems: Item {
        id: clearButton
        width: control.showClearButton ? 16 : 0
        height: 16
        visible: width > 0

        Canvas {
            id: clearIcon
            anchors.fill: parent
            antialiasing: true

            onPaint: {
                const ctx = getContext("2d")
                ctx.clearRect(0, 0, width, height)
                if (!control.showClearButton)
                    return

                const backgroundColor = control.enabled
                    ? control.clearIconBackgroundColor
                    : control.clearIconBackgroundColorDisabled

                ctx.beginPath()
                ctx.arc(width * 0.5, height * 0.5, 7, 0, Math.PI * 2, false)
                ctx.fillStyle = backgroundColor
                ctx.fill()

                ctx.beginPath()
                ctx.moveTo(5.0, 5.0)
                ctx.lineTo(11.0, 11.0)
                ctx.moveTo(11.0, 5.0)
                ctx.lineTo(5.0, 11.0)
                ctx.lineWidth = 1.4
                ctx.lineCap = "round"
                ctx.strokeStyle = control.clearIconForegroundColor
                ctx.stroke()
            }
        }

        MouseArea {
            anchors.fill: parent
            enabled: control.showClearButton
            acceptedButtons: Qt.LeftButton
            onClicked: {
                control.text = ""
                control.forceInputFocus()
            }
        }
    }

    onShowClearButtonChanged: clearIcon.requestPaint()
    onEnabledChanged: clearIcon.requestPaint()
    onClearIconBackgroundColorChanged: clearIcon.requestPaint()
    onClearIconBackgroundColorDisabledChanged: clearIcon.requestPaint()
    onClearIconForegroundColorChanged: clearIcon.requestPaint()

    QtObject {
        Component.onCompleted: Debug.log("InputField", "created")
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.InputField { placeholderText: "Placeholder" }
