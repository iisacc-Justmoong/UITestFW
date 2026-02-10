pragma Singleton
import QtQuick
import UIFramework 1.0

QtObject {
    readonly property bool dark: true

    readonly property string fontBody: FontPolicy.resolveFamily(FontPolicy.preferredFamily)
    readonly property string fontDisplay: FontPolicy.resolveFamily(FontPolicy.preferredFamily)

    //Window

    readonly property color window: "#141414"
    readonly property color windowAlt: "#13161c"
    readonly property color subSurface: "#282828"
    readonly property color surfaceSolid: "#38383c"
    readonly property color surfaceAlt: "#44444b"
    readonly property color surfaceGhost: "#08FFFFFF"

    //Text Color (Figma tokens: TitleHeader / Body / Description / Caption / Disabled)

    readonly property color textTokenBase: "#FFFFFF"
    readonly property real textTokenTitleHeaderOpacity: 0.9
    readonly property real textTokenBodyOpacity: 0.8
    readonly property real textTokenDescriptionOpacity: 0.6
    readonly property real textTokenCaptionOpacity: 0.5
    readonly property real textTokenDisabledOpacity: 0.3

    readonly property color textTokenTitleHeader: "#E5FFFFFF"
    readonly property color textTokenBody: "#CCFFFFFF"
    readonly property color textTokenDescription: "#99FFFFFF"
    readonly property color textTokenCaption: "#80FFFFFF"
    readonly property color textTokenDisabled: "#4DFFFFFF"

    readonly property color titleHeaderColor: textTokenTitleHeader
    readonly property color bodyColor: textTokenBody
    readonly property color descriptionColor: textTokenDescription
    readonly property color captionColor: textTokenCaption
    readonly property color disabledColor: textTokenDisabled

    readonly property color textPrimary: titleHeaderColor
    readonly property color textSecondary: bodyColor
    readonly property color textTertiary: descriptionColor
    readonly property color textSeptenary: captionColor
    readonly property color textOctonary: disabledColor

    //Primary

    readonly property color accent: "#0a84ff"
    readonly property color success: "#32d74b"
    readonly property color warning: "#ffd60a"
    readonly property color danger: "#ff453a"
    readonly property color accentTint: "#1F0A84FF"
    readonly property color dangerTint: "#1FFF453A"
    readonly property color accentOverlay: "#400A84FF"
    readonly property color dangerOverlay: "#59FF453A"
    readonly property color overlayBackdrop: "#59000000"
    readonly property color shadowStrong: "#40000000"
    readonly property color strokeSoft: "#D0D7E2"

    //Radius

    readonly property real radiusHairline: 0.5
    readonly property int radiusXs: 2
    readonly property int radiusSm: 4
    readonly property int radiusBase: 6
    readonly property int radiusMd: 8
    readonly property int radiusLg: 12
    readonly property int radiusXl: 16

    //Spacing

    readonly property int gapNone: 0
    readonly property int gap2: 2
    readonly property int gap3: 3
    readonly property int gap4: 4
    readonly property int gap5: 5
    readonly property int gap6: 6
    readonly property int gap7: 7
    readonly property int gap8: 8
    readonly property int gap10: 10
    readonly property int gap12: 12
    readonly property int gap14: 14
    readonly property int gap16: 16
    readonly property int gap18: 18
    readonly property int gap20: 20
    readonly property int gap24: 24

    //Metrics

    readonly property real strokeHairline: 0.5
    readonly property real strokeThin: 1.0
    readonly property real strokeRegular: 1.5

    readonly property int controlHeightSm: 22
    readonly property int controlHeightMd: 36
    readonly property int inputMinWidth: 180
    readonly property int inputWidthMd: 206
    readonly property int buttonMinWidth: 100
    readonly property int dialogMinWidth: 280
    readonly property int dialogMaxWidth: 360
    readonly property int iconSm: 16
    readonly property int controlIndicatorSize: 18
    readonly property int toggleTrackWidth: 38
    readonly property int toggleTransitionDuration: 140
    readonly property int headerMinHeight: 56
    readonly property int headerExtraHeight: 32
    readonly property int scaffoldBlobPrimarySize: 520
    readonly property int scaffoldBlobPrimaryRadius: 260
    readonly property int scaffoldBlobPrimaryRightMargin: -140
    readonly property int scaffoldBlobPrimaryTopMargin: -200
    readonly property int scaffoldBlobSecondaryWidth: 640
    readonly property int scaffoldBlobSecondaryHeight: 380
    readonly property int scaffoldBlobSecondaryRadius: 220
    readonly property int scaffoldBlobSecondaryLeftMargin: -200
    readonly property int scaffoldBlobSecondaryBottomMargin: -180
    readonly property real scaffoldBlobSecondaryOpacity: 0.3

    readonly property int radiusControl: 5

    //TextSize

    readonly property int textTitle: 26
    readonly property int textTitleWeight: Font.Bold
    readonly property string textTitleStyleName: "Bold"
    readonly property int textTitleLineHeight: 26
    readonly property real textTitleLetterSpacing: 0
    readonly property int textTitle2: 22
    readonly property int textTitle2Weight: Font.Bold
    readonly property string textTitle2StyleName: "Bold"
    readonly property int textTitle2LineHeight: 22
    readonly property real textTitle2LetterSpacing: 0
    readonly property int textHeader: 17
    readonly property int textHeaderWeight: Font.DemiBold
    readonly property string textHeaderStyleName: "SemiBold"
    readonly property int textHeaderLineHeight: 17
    readonly property real textHeaderLetterSpacing: 0
    readonly property int textHeader2: 15
    readonly property int textHeader2Weight: Font.DemiBold
    readonly property string textHeader2StyleName: "SemiBold"
    readonly property int textHeader2LineHeight: 15
    readonly property real textHeader2LetterSpacing: 0
    readonly property int textBody: 13
    readonly property int textBodyWeight: Font.Medium
    readonly property string textBodyStyleName: "Medium"
    readonly property int textBodyLineHeight: 13
    readonly property real textBodyLetterSpacing: 0
    readonly property int textDescription: 12
    readonly property int textDescriptionWeight: Font.DemiBold
    readonly property string textDescriptionStyleName: "SemiBold"
    readonly property int textDescriptionLineHeight: 12
    readonly property real textDescriptionLetterSpacing: 0
    readonly property int textCaption: 11
    readonly property int textCaptionWeight: Font.Normal
    readonly property string textCaptionStyleName: "Regular"
    readonly property int textCaptionLineHeight: 11
    readonly property real textCaptionLetterSpacing: 0

    readonly property int textDisabled: textCaption
    readonly property int textDisabledWeight: textCaptionWeight
    readonly property string textDisabledStyleName: textCaptionStyleName
    readonly property int textDisabledLineHeight: textCaptionLineHeight
    readonly property real textDisabledLetterSpacing: textCaptionLetterSpacing

    readonly property int textOverline: textCaption
    readonly property int textOverlineWeight: textCaptionWeight
    readonly property string textOverlineStyleName: textCaptionStyleName
    readonly property int textDisplay: textTitle2
    readonly property int textDisplayWeight: textTitle2Weight
    readonly property string textDisplayStyleName: textTitle2StyleName
    readonly property int textDisplaySm: textHeader
    readonly property int textDisplaySmWeight: textHeaderWeight
    readonly property string textDisplaySmStyleName: textHeaderStyleName
    readonly property int textBodyLg: textHeader2
    readonly property int textBodyLgWeight: textHeader2Weight
    readonly property string textBodyLgStyleName: textHeader2StyleName

    function weightForTextSize(pixelSize) {
        return FontPolicy.weightForTextSize(pixelSize, textBodyWeight)
    }

    function styleNameForTextSize(pixelSize) {
        return FontPolicy.styleNameForTextSize(pixelSize, textBodyStyleName)
    }

    function isThemeTextStyleCompliant(pixelSize, weight, styleName) {
        return FontPolicy.isThemeTextStyleCompliant(pixelSize, weight, styleName)
    }
}


// API usage (external):
// import UIFramework 1.0 as UIF
// Rectangle { color: UIF.Theme.window }
