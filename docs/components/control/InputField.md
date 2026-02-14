# InputField

Location: `qml/components/control/input/InputField.qml`

`InputField` is the single-line text input built on `AbstractInputBar`.

## Modes

- `defaultMode`
- `searchMode`

Search mode enables the leading magnifier icon path and keeps clear-button behavior.

## Behavior

- Clear-button appears when text exists and field is editable.
- Cursor uses a custom blinking delegate.
- IME composition safety is inherited from `AbstractInputBar` through `InputMethodGuard`.

## Size Contract

- Implicit width: `Theme.inputWidthMd`
- Height profile based on compact control metrics (`Theme.controlHeightSm`)
- Controlled insets and corner radius for dense form layouts.

## Usage

```qml
LV.InputField {
    mode: searchMode
    placeholderText: "Search"
}
```
