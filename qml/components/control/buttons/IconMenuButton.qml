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
    readonly property string indicatorNameDefault: "pan-down-symbolic-default"
    readonly property string indicatorNameBorderless: "pan-down-symbolic-borderless"
    readonly property string indicatorNameAccent: "pan-down-symbolic-accent"
    readonly property string indicatorNameDisabled: "pan-down-symbolic-disabled"
    readonly property string resolvedIndicatorName: !control.effectiveEnabled
        ? control.indicatorNameDisabled
        : control.tone === AbstractButton.Borderless
            ? control.indicatorNameBorderless
            : control.tone === AbstractButton.Accent || control.tone === AbstractButton.Destructive
                ? control.indicatorNameAccent
                : control.indicatorNameDefault
    readonly property string renderedIndicatorSource: {
        control.iconRevision
        return SvgManager.icon(
                    Theme.iconPath(control.resolvedIndicatorName),
                    Theme.iconSm)
    }

    horizontalPadding: Theme.gap2
    verticalPadding: Theme.gap2
    spacing: Theme.gap4
    cornerRadius: Theme.radiusSm
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

        Image {
            source: control.renderedIndicatorSource
            sourceSize.width: Theme.iconSm
            sourceSize.height: Theme.iconSm
            width: Theme.iconSm
            height: Theme.iconSm
            fillMode: Image.PreserveAspectFit
            smooth: true
            Layout.preferredWidth: Theme.iconSm
            Layout.preferredHeight: Theme.iconSm
            Layout.minimumWidth: Theme.iconSm
            Layout.minimumHeight: Theme.iconSm
            Layout.maximumWidth: Theme.iconSm
            Layout.maximumHeight: Theme.iconSm
            Layout.alignment: Qt.AlignVCenter
        }
    }

    QtObject {
        Component.onCompleted: Debug.log("IconMenuButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.IconMenuButton { tone: UIF.AbstractButton.Default; iconName: "view-more-symbolic-default" }
