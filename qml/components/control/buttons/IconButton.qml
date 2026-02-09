import QtQuick
import QtQuick.Layouts
import UIFramework 1.0

AbstractButton {
    id: control

    tone: AbstractButton.Accent
    readonly property url iconSourceDefault: Qt.resolvedUrl("assets/view-more-symbolic-default.svg")
    readonly property url iconSourceBorderless: Qt.resolvedUrl("assets/view-more-symbolic-borderless.svg")
    readonly property url iconSourceDisabled: Qt.resolvedUrl("assets/view-more-symbolic-disabled.svg")
    readonly property url toneIconSource: !control.effectiveEnabled
        ? control.iconSourceDisabled
        : control.tone === AbstractButton.Borderless
            ? control.iconSourceBorderless
            : control.iconSourceDefault

    property url url: ""
    property alias iconSource: control.url
    property string iconGlyph: ""
    property int iconSize: 16
    readonly property url resolvedIconSource: control.url.toString().length > 0
        ? control.url
        : control.toneIconSource
    readonly property string renderedIconSource: SvgManager.icon(
                                                     control.resolvedIconSource.toString(),
                                                     control.iconSize)

    horizontalPadding: 7
    verticalPadding: 7
    spacing: 0
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
        spacing: control.text.length > 0 ? 4 : 0
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

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

        Text {
            text: control.text
            color: control.effectiveEnabled ? control.textColor : control.textColorDisabled
            font.family: "Pretendard"
            font.pixelSize: 13
            font.weight: Font.Normal
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
// UIF.IconButton { tone: UIF.AbstractButton.Accent; url: "qrc:/qt/qml/UIFramework/qml/components/control/buttons/assets/view-more-symbolic-default.svg" }
