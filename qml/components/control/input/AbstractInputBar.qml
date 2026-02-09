import QtQuick
import UIFramework 1.0

FocusScope {
    id: control

    property alias text: inputField.text
    property alias placeholderText: placeholderLabel.text
    property alias readOnly: inputField.readOnly
    property alias echoMode: inputField.echoMode
    property alias validator: inputField.validator
    property alias maximumLength: inputField.maximumLength
    property alias inputMethodHints: inputField.inputMethodHints
    property alias selectByMouse: inputField.selectByMouse
    property alias cursorPosition: inputField.cursorPosition

    property int fieldMinHeight: 36
    property int insetHorizontal: 12
    property int insetVertical: 8
    property int sideSpacing: 8

    property int cornerRadius: Theme.radiusMd
    property int borderWidth: 1

    property color textColor: Theme.textPrimary
    property color textColorDisabled: Theme.textTertiary
    property color placeholderColor: Theme.textTertiary
    property color placeholderColorDisabled: Theme.textOctonary

    property color backgroundColor: Theme.subSurface
    property color backgroundColorFocused: Theme.surfaceSolid
    property color backgroundColorDisabled: Theme.surfaceAlt

    property color borderColor: Theme.surfaceAlt
    property color borderColorFocused: Theme.accent
    property color borderColorDisabled: Theme.surfaceAlt

    property alias leadingItems: leadingSlot.data
    property alias trailingItems: trailingSlot.data

    readonly property real leadingWidth: leadingHost.visible ? leadingSlot.childrenRect.width : 0
    readonly property real trailingWidth: trailingHost.visible ? trailingSlot.childrenRect.width : 0
    readonly property int leftInset: insetHorizontal + leadingWidth + (leadingWidth > 0 ? sideSpacing : 0)
    readonly property int rightInset: insetHorizontal + trailingWidth + (trailingWidth > 0 ? sideSpacing : 0)
    readonly property bool focused: activeFocus || inputField.activeFocus

    signal accepted(string text)
    signal textEdited(string text)

    function forceInputFocus() {
        inputField.forceActiveFocus()
    }

    implicitHeight: Math.max(fieldMinHeight, inputField.implicitHeight + insetVertical * 2)
    implicitWidth: Math.max(180, inputField.implicitWidth + leftInset + rightInset)
    activeFocusOnTab: true

    Rectangle {
        id: backgroundRect
        anchors.fill: parent
        radius: control.cornerRadius
        color: !control.enabled
            ? control.backgroundColorDisabled
            : control.focused
                ? control.backgroundColorFocused
                : control.backgroundColor
        border.width: control.borderWidth
        border.color: !control.enabled
            ? control.borderColorDisabled
            : control.focused
                ? control.borderColorFocused
                : control.borderColor

        Item {
            id: leadingHost
            anchors.left: parent.left
            anchors.leftMargin: control.insetHorizontal
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: leadingSlot.childrenRect.width
            implicitHeight: leadingSlot.childrenRect.height
            visible: leadingSlot.children.length > 0

            Item {
                id: leadingSlot
                anchors.centerIn: parent
            }
        }

        Item {
            id: trailingHost
            anchors.right: parent.right
            anchors.rightMargin: control.insetHorizontal
            anchors.verticalCenter: parent.verticalCenter
            implicitWidth: trailingSlot.childrenRect.width
            implicitHeight: trailingSlot.childrenRect.height
            visible: trailingSlot.children.length > 0

            Item {
                id: trailingSlot
                anchors.centerIn: parent
            }
        }
    }

    TextInput {
        id: inputField
        anchors.fill: parent
        anchors.leftMargin: control.leftInset
        anchors.rightMargin: control.rightInset
        anchors.topMargin: control.insetVertical
        anchors.bottomMargin: control.insetVertical
        color: control.enabled ? control.textColor : control.textColorDisabled
        selectionColor: Theme.accent
        selectedTextColor: Theme.textPrimary
        font.family: Theme.fontBody
        font.pixelSize: Theme.textBody
        activeFocusOnTab: true
        clip: true
        selectByMouse: true
        onTextEdited: control.textEdited(text)
        Keys.onReturnPressed: control.accepted(text)
        Keys.onEnterPressed: control.accepted(text)
    }

    Text {
        id: placeholderLabel
        anchors.left: inputField.left
        anchors.right: inputField.right
        anchors.verticalCenter: inputField.verticalCenter
        color: control.enabled ? control.placeholderColor : control.placeholderColorDisabled
        font.family: inputField.font.family
        font.pixelSize: inputField.font.pixelSize
        elide: Text.ElideRight
        visible: inputField.text.length === 0 && inputField.preeditText.length === 0
        verticalAlignment: Text.AlignVCenter
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        cursorShape: Qt.IBeamCursor
        onPressed: function(mouse) {
            control.forceInputFocus()
            mouse.accepted = false
        }
    }

    QtObject {
        Component.onCompleted: Debug.log("AbstractInputBar", "created")
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.AbstractInputBar { placeholderText: "Search"; leadingItems: Text { text: "⌕" } }
