import QtQuick
import UIFramework 1.0

Item {
    id: root

    // Supported triggers: clicked, pressed, released, entered, exited, hoverChanged, keyPressed, keyReleased, globalPressed, globalContextRequested
    property string trigger: "clicked"
    property var action: null
    property var payload: ({})
    property bool enabled: true
    property int acceptedButtons: Qt.LeftButton
    property bool macControlClickAsRight: true
    property int contextDedupMs: 180
    property real contextDedupTolerancePx: 2.0
    property double lastContextTimestamp: -1
    property real lastContextX: -1
    property real lastContextY: -1

    anchors.fill: parent
    visible: true
    opacity: 0.0
    focus: root.enabled && root.isKeyTrigger(root.trigger)
    activeFocusOnTab: root.isKeyTrigger(root.trigger)

    function isPointerTrigger(name) {
        return name === "clicked" || name === "pressed" || name === "released"
            || name === "entered" || name === "exited" || name === "hoverChanged"
    }

    function isKeyTrigger(name) {
        return name === "keyPressed" || name === "keyReleased"
    }

    function isGlobalPointerTrigger(name) {
        return name === "globalPressed" || name === "globalContextRequested"
    }

    function isContextGesture(buttons, modifiers) {
        const isRightButton = (buttons & Qt.RightButton) === Qt.RightButton
        const isMacControlClick = macControlClickAsRight
            && (buttons & Qt.LeftButton) === Qt.LeftButton
            && (modifiers & Qt.ControlModifier) === Qt.ControlModifier
        return isRightButton || isMacControlClick
    }

    function globalMousePayload(x, y, buttons, modifiers) {
        return {
            x: x,
            y: y,
            globalX: x,
            globalY: y,
            buttons: buttons,
            modifiers: modifiers,
            isGlobal: true
        }
    }

    function isDuplicateContextEvent(x, y, nowMs) {
        if (lastContextTimestamp < 0)
            return false
        if ((nowMs - lastContextTimestamp) > contextDedupMs)
            return false
        return Math.abs(lastContextX - x) <= contextDedupTolerancePx
            && Math.abs(lastContextY - y) <= contextDedupTolerancePx
    }

    function fireGlobalContext(x, y, buttons, modifiers, reason, source) {
        const nowMs = Date.now()
        if (root.isDuplicateContextEvent(x, y, nowMs))
            return
        root.lastContextTimestamp = nowMs
        root.lastContextX = x
        root.lastContextY = y
        const data = root.globalMousePayload(x, y, buttons, modifiers)
        data.reason = reason
        data.source = source
        root.fire(data)
    }

    function ensureKeyFocus() {
        if (root.enabled && root.isKeyTrigger(root.trigger))
            root.forceActiveFocus()
    }

    function fire(eventData) {
        if (!root.enabled || !root.action)
            return
        root.action(eventData !== undefined ? eventData : root.payload)
    }

    onTriggerChanged: root.ensureKeyFocus()
    onEnabledChanged: root.ensureKeyFocus()
    Component.onCompleted: root.ensureKeyFocus()

    Connections {
        target: RuntimeEvents
        enabled: root.enabled && root.isGlobalPointerTrigger(root.trigger)
        function onMousePressed(x, y, buttons, modifiers) {
            if (root.trigger === "globalPressed") {
                root.fire(root.globalMousePayload(x, y, buttons, modifiers))
                return
            }
            if (root.trigger !== "globalContextRequested")
                return
            if (!root.isContextGesture(buttons, modifiers))
                return
            root.fireGlobalContext(x, y, buttons, modifiers, -1, "mouse")
        }

        function onContextRequested(x, y, modifiers, reason) {
            if (root.trigger !== "globalContextRequested")
                return
            const inferredButtons = reason === 0 ? Qt.RightButton : Qt.NoButton
            root.fireGlobalContext(x, y, inferredButtons, modifiers, reason, "context")
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: root.enabled && root.isPointerTrigger(root.trigger)
        hoverEnabled: root.trigger === "entered" || root.trigger === "exited" || root.trigger === "hoverChanged"
        acceptedButtons: root.acceptedButtons
        propagateComposedEvents: true

        onClicked: {
            if (root.trigger === "clicked")
                root.fire(mouse)
        }
        onPressed: {
            if (root.trigger === "pressed")
                root.fire(mouse)
        }
        onReleased: {
            if (root.trigger === "released")
                root.fire(mouse)
        }
        onEntered: {
            if (root.trigger === "entered")
                root.fire()
        }
        onExited: {
            if (root.trigger === "exited")
                root.fire()
        }
        onContainsMouseChanged: {
            if (root.trigger === "hoverChanged")
                root.fire({ containsMouse: containsMouse })
        }
    }

    Keys.onPressed: function(event) {
        if (root.enabled && root.trigger === "keyPressed")
            root.fire(event)
    }
    Keys.onReleased: function(event) {
        if (root.enabled && root.trigger === "keyReleased")
            root.fire(event)
    }
}

// API usage (external):
// import UIFramework 1.0 as UIF
// UIF.Label { UIF.EventListener { trigger: "clicked"; action: () => console.log("click") } }
