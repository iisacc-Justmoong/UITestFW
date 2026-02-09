import QtQuick
import QtQuick.Layouts
import UIFramework 1.0

AbstractButton {
    id: control

    tone: AbstractButton.Accent
    readonly property url iconSourceDefault: "qrc:/qt/qml/UIFramework/resources/iconset/view-more-symbolic-default.svg"
    readonly property url iconSourceBorderless: "qrc:/qt/qml/UIFramework/resources/iconset/view-more-symbolic-borderless.svg"
    readonly property url iconSourceDisabled: "qrc:/qt/qml/UIFramework/resources/iconset/view-more-symbolic-disabled.svg"

    property url url: ""
    property alias iconSource: control.url
    property string iconGlyph: ""
    property int iconSize: 16
    readonly property url resolvedIconSource: control.url.toString().length > 0
        ? control.url
        : !control.effectiveEnabled
            ? control.iconSourceDisabled
            : control.tone === AbstractButton.Borderless
                ? control.iconSourceBorderless
                : control.iconSourceDefault
    readonly property int iconRevision: SvgManager.revision
    readonly property string renderedIconSource: {
        control.iconRevision
        return SvgManager.icon(
                    control.resolvedIconSource.toString(),
                    control.iconSize)
    }
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

        Image {
            visible: control.iconGlyph.length === 0
            source: control.renderedIconSource
            sourceSize.width: control.iconSize
            sourceSize.height: control.iconSize
            width: control.iconSize
            height: control.iconSize
            fillMode: Image.PreserveAspectFit
            smooth: true
            Layout.preferredWidth: control.iconSize
            Layout.preferredHeight: control.iconSize
            Layout.minimumWidth: control.iconSize
            Layout.minimumHeight: control.iconSize
            Layout.maximumWidth: control.iconSize
            Layout.maximumHeight: control.iconSize
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            visible: control.iconGlyph.length > 0
            text: control.iconGlyph
            color: control.effectiveEnabled ? control.textColor : control.textColorDisabled
            font.family: Theme.fontBody
            font.pixelSize: control.iconSize
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
        Component.onCompleted: Debug.log("IconMenuButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.IconMenuButton { tone: UIF.AbstractButton.Default; url: "qrc:/qt/qml/UIFramework/resources/iconset/view-more-symbolic-default.svg" }
