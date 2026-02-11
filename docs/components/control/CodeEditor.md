# CodeEditor

Location: `qml/components/control/input/CodeEditor.qml`

Multi-line input component specialized for editing code snippets. It is separated from `TextEditor` as a dedicated editing area and defaults to `PlainText + NoWrap`.

## Core API
- `text`, `placeholderText`, `readOnly`
- `snippetTitle`, `snippetLanguage`, `showSnippetHeader`
- `tabStopDistance`, `selectionStart`, `selectionEnd`, `cursorPosition`
- `fontFamily`, `fontPixelSize`, `fontWeight`, `fontStyleName`

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
LV.CodeEditor {
    snippetTitle: "index.ts"
    snippetLanguage: "TypeScript"
    text: "const ready = true"
}
```

## Practical Examples

### Example 1: Editable snippet with submit shortcut
```qml
import QtQuick
import LVRS 1.0 as LV

LV.CodeEditor {
    snippetTitle: "main.ts"
    snippetLanguage: "TypeScript"
    text: "export const ready = true"
    onSubmitted: console.log("Submitted code:", text)
}
```

### Example 2: Read-only viewer for generated code
```qml
import QtQuick
import LVRS 1.0 as LV

LV.CodeEditor {
    snippetTitle: "Generated JSON"
    showSnippetHeader: true
    readOnly: true
    text: "{\n  \"status\": \"ok\"\n}"
}
```

### Example 3: Editor toolbar using utility methods
```qml
import QtQuick
import LVRS 1.0 as LV

Column {
    spacing: 8

    LV.CodeEditor {
        id: editor
        snippetTitle: "script.sh"
        snippetLanguage: "Shell"
    }

    Row {
        spacing: 8
        LV.LabelButton { text: "Insert"; onClicked: editor.insertText("echo hello\n") }
        LV.LabelButton { text: "Undo"; onClicked: editor.undo() }
        LV.LabelButton { text: "Redo"; onClicked: editor.redo() }
        LV.LabelButton { text: "Clear"; onClicked: editor.clear() }
    }
}
```
