# CodeEditor

Location: `qml/components/control/input/CodeEditor.qml`

코드 스니펫 편집용 멀티라인 입력 컴포넌트이다. `TextEditor`와 분리된 전용 영역으로 제공되며, 기본 동작은 `PlainText + NoWrap`이다.

## Core API
- `text`, `placeholderText`, `readOnly`
- `snippetTitle`, `snippetLanguage`, `showSnippetHeader`
- `tabStopDistance`, `selectionStart`, `selectionEnd`, `cursorPosition`
- `fontFamily`, `fontPixelSize`, `fontWeight`, `fontStyleName`

## Signals
- `textEdited(text)`
- `submitted(text)` (`Ctrl+Enter` 또는 `Cmd+Enter`)

## Utility Methods
- `forceEditorFocus()`
- `insertText(value)`
- `clear()`
- `clearSelection()`
- `undo()`, `redo()`

## Usage
```qml
UIF.CodeEditor {
    snippetTitle: "index.ts"
    snippetLanguage: "TypeScript"
    text: "const ready = true"
}
```
