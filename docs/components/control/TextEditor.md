# TextEditor

Location: `qml/components/control/input/TextEditor.qml`

Multi-line input component. It keeps output behavior consistent by processing content through the same parser/renderer (`TextMarkup`) across input modes.

## Core API
- `text`, `placeholderText`, `readOnly`
- `mode`: `plainTextMode`, `markdownMode`, `richTextMode`
- `enforceModeDefaults`, `wrapMode`, `textFormat`, `tabStopDistance`
- `fontFamily`, `fontPixelSize`, `fontWeight`, `fontStyleName`
- `selectionStart`, `selectionEnd`, `cursorPosition`
- `normalizedInput`, `renderedOutput`, `renderedPlainText`

When `enforceModeDefaults: true`, input `textFormat` is fixed to `PlainText` regardless of mode, while styled rendering remains available through `renderedOutput`.

## Signals
- `textEdited(text)`
- `submitted(text)` (`Ctrl+Enter` or `Cmd+Enter`)

## Utility Methods
- `forceEditorFocus()`
- `insertText(value)`
- `clear()`
- `clearSelection()`
- `undo()`, `redo()`

## Usage
```qml
LV.TextEditor {
    mode: markdownMode
    text: "Hello **bold**"
    onSubmitted: save(text)
}
```

## Practical Examples

### Example 1: Markdown note editor
```qml
import QtQuick
import LVRS 1.0 as LV

LV.TextEditor {
    mode: markdownMode
    placeholderText: "Write release notes..."
    text: "## v1.2.0\n- Added route state tracking"
    onSubmitted: console.log("Saved note:", text)
}
```

### Example 2: Plain text input without preview
```qml
import QtQuick
import LVRS 1.0 as LV

LV.TextEditor {
    mode: plainTextMode
    showRenderedOutput: false
    enforceModeDefaults: true
    placeholderText: "Paste raw logs"
}
```

### Example 3: Editor command buttons
```qml
import QtQuick
import LVRS 1.0 as LV

Column {
    spacing: 8

    LV.TextEditor {
        id: editor
        mode: richTextMode
        text: "Initial content"
    }

    Row {
        spacing: 8
        LV.LabelButton { text: "Insert Date"; onClicked: editor.insertText("\nDate: 2026-02-11") }
        LV.LabelButton { text: "Undo"; onClicked: editor.undo() }
        LV.LabelButton { text: "Redo"; onClicked: editor.redo() }
        LV.LabelButton { text: "Clear"; onClicked: editor.clear() }
    }
}
```
