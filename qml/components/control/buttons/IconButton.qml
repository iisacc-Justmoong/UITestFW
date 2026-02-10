import QtQuick
import QtQuick.Layouts
import UIFramework 1.0

AbstractButton {
    id: control

    tone: AbstractButton.Accent
    readonly property url iconSourceDefault: "qrc:/qt/qml/UIFramework/resources/iconset/view-more-symbolic-default.svg"
    readonly property url iconSourceBorderless: "qrc:/qt/qml/UIFramework/resources/iconset/view-more-symbolic-borderless.svg"
    readonly property url iconSourceDisabled: "qrc:/qt/qml/UIFramework/resources/iconset/view-more-symbolic-disabled.svg"
    readonly property url toneIconSource: !control.effectiveEnabled
        ? control.iconSourceDisabled
        : control.tone === AbstractButton.Borderless
            ? control.iconSourceBorderless
            : control.iconSourceDefault

    property url url: ""
    property alias iconSource: control.url
    property string iconGlyph: ""
    property int iconSize: Theme.iconSm
    readonly property url resolvedIconSource: control.url.toString().length > 0
        ? control.url
        : control.toneIconSource
    readonly property int iconRevision: SvgManager.revision
    readonly property string renderedIconSource: {
        control.iconRevision
        return SvgManager.icon(
                    control.resolvedIconSource.toString(),
                    control.iconSize)
    }

    horizontalPadding: Theme.gap7
    verticalPadding: Theme.gap7
    spacing: Theme.gapNone
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
        spacing: control.text.length > 0 ? Theme.gap4 : Theme.gapNone
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

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

        Label {
            style: body
            text: control.text
            color: control.effectiveEnabled ? control.textColor : control.textColorDisabled
            elide: Text.ElideRight
            visible: control.text.length > 0
            Layout.alignment: Qt.AlignVCenter
        }
    }
    QtObject {
        Component.onCompleted: Debug.log("IconButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.IconButton { tone: UIF.AbstractButton.Accent; url: "qrc:/qt/qml/UIFramework/resources/iconset/view-more-symbolic-default.svg" }
