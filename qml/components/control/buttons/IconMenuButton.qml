import QtQuick
import QtQuick.Layouts
import UIFramework 1.0

AbstractButton {
    id: control

    tone: AbstractButton.Accent
    readonly property string iconNameDefault: "view-more-symbolic-default"
    readonly property string iconNameBorderless: "view-more-symbolic-borderless"
    readonly property string iconNameDisabled: "view-more-symbolic-disabled"
    readonly property url iconSourceDefault: Theme.iconPath(control.iconNameDefault)
    readonly property url iconSourceBorderless: Theme.iconPath(control.iconNameBorderless)
    readonly property url iconSourceDisabled: Theme.iconPath(control.iconNameDisabled)

    property url url: ""
    property alias iconSource: control.url
    property string iconName: ""
    property string iconGlyph: ""
    property int iconSize: Theme.iconSm
    readonly property string resolvedIconName: {
        const explicitIconName = control.iconName === undefined || control.iconName === null
            ? ""
            : String(control.iconName).trim()
        if (explicitIconName.length > 0)
            return explicitIconName
        const groupedIconName = control.icon && control.icon.name !== undefined && control.icon.name !== null
            ? String(control.icon.name).trim()
            : ""
        if (groupedIconName.length > 0)
            return groupedIconName
        return ""
    }
    readonly property url resolvedIconSource: control.url.toString().length > 0
        ? control.url
        : control.resolvedIconName.length > 0
            ? Theme.iconPath(control.resolvedIconName)
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

    horizontalPadding: Theme.gap7
    verticalPadding: Theme.gap7
    spacing: Theme.gap4
    cornerRadius: Theme.radiusMd
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
        spacing: Theme.gap4
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

        Label {
            style: body
            visible: control.iconGlyph.length > 0
            text: control.iconGlyph
            color: control.effectiveEnabled ? control.textColor : control.textColorDisabled
            font.pixelSize: control.iconSize
            font.weight: Font.Normal
            lineHeight: control.iconSize
            lineHeightMode: Text.FixedHeight
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
// UIF.IconMenuButton { tone: UIF.AbstractButton.Default; iconName: "view-more-symbolic-default" }
