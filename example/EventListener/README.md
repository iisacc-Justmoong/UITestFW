# EventListener Examples

This folder shows **multiple ways** to use `EventListener` in QML. These examples are not built; they
are intended as reference snippets.

> Note: component name is `EventListener` (spelled as in code).

---

## Plain-language explanation (non-developers)

Think of `EventListener` as a tiny “ear” you can place inside any UI element.
When the element is clicked, hovered, or a key is pressed, the ear hears it
and runs a simple action (like showing a message).

This lets designers attach behavior without changing the original component.

---

## 1) Basic click handler on Label

```qml
UIF.Label {
    text: "Click me"
    UIF.EventListener {
        trigger: "clicked"
        action: () => console.log("Label clicked")
    }
}
```

---

## 2) Hover state tracking

```qml
Rectangle {
    width: 120; height: 40; color: "#333"
    UIF.EventListener {
        trigger: "hoverChanged"
        action: (e) => console.log("hover:", e.containsMouse)
    }
}
```

---

## 3) Press / Release

```qml
UIF.Label {
    text: "Hold"
    UIF.EventListener {
        trigger: "pressed"
        action: () => console.log("pressed")
    }
    UIF.EventListener {
        trigger: "released"
        action: () => console.log("released")
    }
}
```

---

## 4) Custom payload

```qml
UIF.Label {
    text: "Payload"
    UIF.EventListener {
        trigger: "clicked"
        payload: { source: "payload-example", value: 42 }
        action: (data) => console.log(data.source, data.value)
    }
}
```

---

## 5) Right-click only

```qml
UIF.Label {
    text: "Right click"
    UIF.EventListener {
        trigger: "clicked"
        acceptedButtons: Qt.RightButton
        action: () => console.log("right click")
    }
}
```

---

## 6) Keyboard trigger (focusable parent)

```qml
TextInput {
    id: input
    focus: true

    UIF.EventListener {
        trigger: "keyPressed"
        action: (event) => {
            if (event.key === Qt.Key_Return)
                console.log("enter")
        }
    }
}
```

---

## 7) Wrap any component with multiple listeners

```qml
Rectangle {
    width: 180; height: 60; color: "#222"

    UIF.EventListener {
        trigger: "entered"
        action: () => console.log("hover enter")
    }

    UIF.EventListener {
        trigger: "exited"
        action: () => console.log("hover exit")
    }

    UIF.EventListener {
        trigger: "clicked"
        action: () => console.log("clicked")
    }
}
```

---

## 8) Reusable handler function

```qml
function onAction(tag) {
    console.log("action:", tag)
}

UIF.Label {
    text: "Reusable"
    UIF.EventListener {
        trigger: "clicked"
        action: () => onAction("label")
    }
}
```
