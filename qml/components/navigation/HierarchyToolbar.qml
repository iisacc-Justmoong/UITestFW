import QtQuick
import QtQuick.Layouts
import LVRS 1.0

Item {
    id: control

    property int horizontalPadding: Theme.gap8
    property int verticalPadding: Theme.gap2
    property int spacing: Theme.gapNone
    property color backgroundColor: Theme.subSurface
    property real backgroundOpacity: 0.88

    property var activeButton: null
    property int activeButtonId: -1

    signal activeChanged(var button, int buttonId, int index)

    default property alias buttons: buttonsRow.data

    function collectButtons() {
        const result = []
        for (let i = 0; i < buttonsRow.children.length; i++) {
            const child = buttonsRow.children[i]
            if (child && child.__isToolbarButton === true)
                result.push(child)
        }
        return result
    }

    function indexOfButton(button) {
        const buttons = collectButtons()
        for (let i = 0; i < buttons.length; i++) {
            if (buttons[i] === button)
                return i
        }
        return -1
    }

    function resolveById(buttonId) {
        const buttons = collectButtons()
        for (let i = 0; i < buttons.length; i++) {
            const button = buttons[i]
            if (button && button.buttonId === buttonId)
                return button
        }
        return null
    }

    function firstEnabledButton() {
        const buttons = collectButtons()
        for (let i = 0; i < buttons.length; i++) {
            const button = buttons[i]
            if (button && button.enabled)
                return button
        }
        return buttons.length > 0 ? buttons[0] : null
    }

    function registerButton(button) {
        if (!button)
            return
        if (button.toolbar !== control)
            button.toolbar = control
        normalizeActiveButton()
    }

    function requestActivate(button) {
        if (!button || !button.enabled)
            return
        if (button.toolbar !== control)
            button.toolbar = control
        if (activeButton === button)
            return
        activeButton = button
        activeButtonId = button.buttonId
        activeChanged(button, activeButtonId, indexOfButton(button))
    }

    function normalizeActiveButton() {
        const buttons = collectButtons()
        if (buttons.length === 0) {
            activeButton = null
            activeButtonId = -1
            return
        }

        for (let i = 0; i < buttons.length; i++) {
            const button = buttons[i]
            if (button && button.toolbar !== control)
                button.toolbar = control
        }

        let targetButton = activeButton
        if (activeButtonId >= 0) {
            const byId = resolveById(activeButtonId)
            if (byId)
                targetButton = byId
        }
        if (!targetButton || buttons.indexOf(targetButton) === -1 || !targetButton.enabled)
            targetButton = firstEnabledButton()

        if (activeButton !== targetButton) {
            activeButton = targetButton
            activeButtonId = targetButton ? targetButton.buttonId : -1
        }
    }

    onActiveButtonIdChanged: Qt.callLater(normalizeActiveButton)

    implicitWidth: rowContainer.implicitWidth + (horizontalPadding * 2)
    implicitHeight: rowContainer.implicitHeight + (verticalPadding * 2)

    Rectangle {
        anchors.fill: parent
        color: control.backgroundColor
        opacity: control.backgroundOpacity
    }

    RowLayout {
        id: rowContainer
        anchors.fill: parent
        anchors.leftMargin: control.horizontalPadding
        anchors.rightMargin: control.horizontalPadding
        anchors.topMargin: control.verticalPadding
        anchors.bottomMargin: control.verticalPadding
        spacing: control.spacing

        Row {
            id: buttonsRow
            spacing: control.spacing
        }
    }

    Connections {
        target: buttonsRow
        function onChildrenChanged() {
            Qt.callLater(control.normalizeActiveButton)
        }
    }

    QtObject {
        Component.onCompleted: {
            control.normalizeActiveButton()
            Debug.log("HierarchyToolbar", "created")
        }
    }
}

// API usage (external):
// import LVRS 1.0 as UIF
// UIF.HierarchyToolbar { UIF.ToolbarButton { buttonId: 1 } UIF.ToolbarButton { buttonId: 2 } }
