# InputMethodGuard

Location: `qml/components/control/util/InputMethodGuard.qml`

`InputMethodGuard` protects text composition state when input-method conditions change (locale switch, IME visibility change, focus loss).

## Why It Exists

Without explicit composition commit, some IME transitions can leave partial preedit text and produce broken syllable composition in downstream text controls.

## Behavior

When a target input control is composing (`inputMethodComposing === true`), guard can call `Qt.inputMethod.commit()` on:

- locale change (`commitOnLocaleChanged`)
- IME hidden (`commitOnVisibilityLost`)
- focus lost (`commitOnFocusLost`)

## Properties

- `target` (required input control)
- `guardEnabled` (default `true`)
- `commitOnLocaleChanged` (default `true`)
- `commitOnVisibilityLost` (default `true`)
- `commitOnFocusLost` (default `true`)
- `logCommitEvents` (optional debug logging)

## Current Adoption

Used by:
- `AbstractInputBar.qml`
- `TextEditor.qml`
- `CodeEditor.qml`

This ensures consistent IME handling across all text-entry surfaces in LVRS.

## Usage

```qml
LV.InputMethodGuard {
    target: editor
    guardEnabled: control.enabled && !control.readOnly
}
```
