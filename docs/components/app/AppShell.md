# AppShell

Location: `qml/AppShell.qml`

Wrapper that combines `ApplicationWindow` + `AppScaffold` conveniences.

## Properties
- `title`, `subtitle`
- `navItems` (string or object list)
- `navIndex`, `navigationEnabled`, `navTitle`, `navTitleVisible`, `navWidth`, `navDrawerWidth`
- `navDelegate`, `navHeader`, `navFooter`
- `headerActions` (alias)

## Signals
- `navActivated(index, item)`

## Usage
```qml
UIF.AppShell {
    title: "UITestFW"
    navItems: ["Overview", "Runs"]
    onNavActivated: (idx, item) => console.log(idx, item)
}
```
