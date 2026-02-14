# TextEditor

Location: `qml/components/control/input/TextEditor.qml`

`TextEditor` is the multi-line editor component for plain text, markdown, and rich-text preview workflows.

## Core API

- `text`, `placeholderText`, `readOnly`
- `mode`: `plainTextMode`, `markdownMode`, `richTextMode`
- `editorHeight` (fixed editor viewport height input)
- `fieldMinHeight` (minimum floor)
- `showRenderedOutput`, `outputMinHeight`
- `enforceModeDefaults`, `wrapMode`, `textFormat`

## Layout Contract

The edit area uses a fixed-height viewport (`resolvedEditorHeight`) while preserving responsive width.
Content scrolls internally through `Flickable`, preventing parent layout drift during heavy text input.

## IME and Composition Handling

`TextEditor` integrates `InputMethodGuard` and sets `font.preferShaping: true`.
This combination reduces composition breakage when input method/locale state changes mid-entry.

## Nested Scroll Isolation

`WheelScrollGuard` is attached to the editor viewport so wheel events inside editor area do not leak into outer scroll pages.

## Signals and Methods

Signals:
- `textEdited(text)`
- `submitted(text)` (`Ctrl+Enter` / `Cmd+Enter`)

Methods:
- `forceEditorFocus()`, `insertText(value)`, `clear()`, `undo()`, `redo()`

## Usage

```qml
LV.TextEditor {
    mode: markdownMode
    editorHeight: 220
    showRenderedOutput: true
    onSubmitted: save(text)
}
```
