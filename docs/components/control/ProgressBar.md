# ProgressBar

Location: `qml/components/control/display/ProgressBar.qml`

`ProgressBar` is a lightweight value-range visualizer used in dashboards and runtime cards.

## Size Presets

- `large`
- `regular`

## Core API

- `startValue`
- `endValue`
- `currentValue`
- `trackColor`
- `fillColor`
- `cornerRadius`

`progress` is normalized internally and clamped to `[0, 1]`.

## Usage

```qml
LV.ProgressBar {
    width: 200
    size: regular
    startValue: 0
    endValue: 100
    currentValue: 72
}
```
