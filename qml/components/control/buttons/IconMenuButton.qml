import QtQuick
import QtQuick.Layouts
import UIFramework 1.0

AbstractButton {
    id: control

    tone: AbstractButton.Accent
    readonly property url iconSourceDefault: Qt.resolvedUrl("assets/view-more-symbolic-default.svg")
    readonly property url iconSourceBorderless: Qt.resolvedUrl("assets/view-more-symbolic-borderless.svg")
    readonly property url iconSourceDisabled: Qt.resolvedUrl("assets/view-more-symbolic-disabled.svg")
    readonly property url indicatorSourceDefault: Qt.resolvedUrl("assets/pan-down-symbolic-default.svg")
    readonly property url indicatorSourceAccent: Qt.resolvedUrl("assets/pan-down-symbolic-accent.svg")
    readonly property url indicatorSourceBorderless: Qt.resolvedUrl("assets/pan-down-symbolic-borderless.svg")
    readonly property url indicatorSourceDisabled: Qt.resolvedUrl("assets/pan-down-symbolic-disabled.svg")

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
    readonly property string renderedIconSource: SvgManager.icon(
                                                     control.resolvedIconSource.toString(),
                                                     control.iconSize)
    readonly property url resolvedIndicatorSource: !control.effectiveEnabled
        ? control.indicatorSourceDisabled
        : control.tone === AbstractButton.Borderless
            ? control.indicatorSourceBorderless
            : control.tone === AbstractButton.Accent || control.tone === AbstractButton.Destructive
                ? control.indicatorSourceAccent
                : control.indicatorSourceDefault
    readonly property string renderedIndicatorSource: SvgManager.icon(
                                                          control.resolvedIndicatorSource.toString(),
                                                          16)

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
            width: control.iconSize
            height: control.iconSize
            fillMode: Image.PreserveAspectFit
            smooth: true
            Layout.alignment: Qt.AlignVCenter
        }

        Text {
            visible: control.iconGlyph.length > 0
            text: control.iconGlyph
            color: control.effectiveEnabled ? control.textColor : control.textColorDisabled
            font.family: "Pretendard"
            font.pixelSize: control.iconSize
            Layout.alignment: Qt.AlignVCenter
        }

        Image {
            source: control.renderedIndicatorSource
            width: 16
            height: 16
            fillMode: Image.PreserveAspectFit
            smooth: true
            Layout.alignment: Qt.AlignVCenter
        }
    }

    QtObject {
        Component.onCompleted: Debug.log("IconMenuButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.IconMenuButton { tone: UIF.AbstractButton.Default; url: "qrc:/qt/qml/UIFramework/qml/components/control/buttons/assets/view-more-symbolic-default.svg" }
