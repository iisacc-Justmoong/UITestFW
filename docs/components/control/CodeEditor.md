# CodeEditor

Location: `qml/components/control/input/CodeEditor.qml`

`CodeEditor` is a snippet-oriented editor specialized for code-style input (`PlainText + NoWrap`).

## Core API

- `text`, `placeholderText`, `readOnly`
- `snippetTitle`, `snippetLanguage`, `showSnippetHeader`
- `fieldMinHeight`, `headerHeight`, `insetHorizontal`, `insetVertical`

## Behavior

- Uses internal `Flickable` for horizontal and vertical scrolling.
- Keeps outer component height stable while content grows.
- Emits `submitted(text)` on `Ctrl+Enter` or `Cmd+Enter`.

## IME and Text Integrity

Like `TextEditor`, `CodeEditor` includes:
- `InputMethodGuard` for composition commit on IME transitions.
- `font.preferShaping: true` for safer shaping path.

## Wheel Isolation

`WheelScrollGuard` is applied to prevent outer container scrolling while cursor is over editor region.

## Usage

```qml
LV.CodeEditor {
    snippetTitle: "main.cpp"
    snippetLanguage: "C++"
    text: "int main() { return 0; }"
}
```
