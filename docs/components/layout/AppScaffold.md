# AppScaffold

Location: `qml/components/layout/AppScaffold.qml`

Main layout scaffold: header, nav rail/drawer, and content area.

## Navigation Integration
- `pageRouter`: if set and `navModel` items include `path`, clicking updates router.

## Usage
```qml
UIF.AppScaffold {
    headerTitle: "App"
    navModel: [{ label: "Overview", path: "/" }]
}
```
