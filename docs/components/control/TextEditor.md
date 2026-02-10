# TextEditor

Location: `qml/components/control/input/TextEditor.qml`

멀티라인 입력 컴포넌트이다. 입력 모드와 무관하게 동일한 문자열 파서/렌더러(`TextMarkup`)를 거쳐 일관된 결과를 제공한다.

## Core API
- `text`, `placeholderText`, `readOnly`
- `mode`: `plainTextMode`, `markdownMode`, `richTextMode`
- `enforceModeDefaults`, `wrapMode`, `textFormat`, `tabStopDistance`
- `fontFamily`, `fontPixelSize`, `fontWeight`, `fontStyleName`
- `selectionStart`, `selectionEnd`, `cursorPosition`
- `normalizedInput`, `renderedOutput`, `renderedPlainText`

`enforceModeDefaults: true`일 때 입력 `textFormat`은 모드와 무관하게 `PlainText`로 고정되며, 스타일 렌더링은 `renderedOutput`을 통해 일관되게 제공된다.

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
UIF.TextEditor {
    mode: markdownMode
    text: "Hello **bold**"
    onSubmitted: save(text)
}
```
