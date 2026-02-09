import QtQuick
import QtQuick.Layouts
import UIFramework 1.0

AbstractButton {
    id: control

    tone: AbstractButton.Accent
    readonly property url indicatorSourceDefault: Qt.resolvedUrl("assets/pan-down-symbolic-default.svg")
    readonly property url indicatorSourceAccent: Qt.resolvedUrl("assets/pan-down-symbolic-accent.svg")
    readonly property url indicatorSourceBorderless: Qt.resolvedUrl("assets/pan-down-symbolic-borderless.svg")
    readonly property url indicatorSourceDisabled: Qt.resolvedUrl("assets/pan-down-symbolic-disabled.svg")
    readonly property url resolvedIndicatorSource: !control.effectiveEnabled
        ? control.indicatorSourceDisabled
        : control.tone === AbstractButton.Borderless
            ? control.indicatorSourceBorderless
            : control.tone === AbstractButton.Accent || control.tone === AbstractButton.Destructive
                ? control.indicatorSourceAccent
                : control.indicatorSourceDefault

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
            font.family: "Pretendard"
            font.pixelSize: 13
            font.weight: Font.Normal
            elide: Text.ElideRight
            Layout.alignment: Qt.AlignVCenter
        }

        Image {
            source: control.resolvedIndicatorSource
            sourceSize.width: 16
            sourceSize.height: 16
            width: 16
            height: 16
            fillMode: Image.PreserveAspectFit
            smooth: true
            Layout.alignment: Qt.AlignVCenter
        }
    }

    QtObject {
        Component.onCompleted: Debug.log("LabelMenuButton", "created")
    }

}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.LabelMenuButton { text: "Open"; tone: UIF.AbstractButton.Default }
