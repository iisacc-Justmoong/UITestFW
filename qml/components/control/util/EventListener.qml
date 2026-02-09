import QtQuick

Item {
    id: root

    // Supported triggers: clicked, pressed, released, entered, exited, hoverChanged, keyPressed, keyReleased
    property string trigger: "clicked"
    property var action: null
    property var payload: ({})
    property bool enabled: true
    property int acceptedButtons: Qt.LeftButton

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
