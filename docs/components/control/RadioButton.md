# RadioButton

Location: `qml/components/control/check/RadioButton.qml`

Figma `Radio` 노드(18x18) 기준의 라디오 인디케이터이다. `checked/enabled`와 `state/available`를 함께 지원한다.

## Properties
- `checked` / `state`
- `enabled` / `available`
- `text` (optional)

## Usage
```qml
UIF.RadioButton { text: "Choice A"; checked: true }
```

```qml
UIF.RadioButton { state: true; available: false }
```
