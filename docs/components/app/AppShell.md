# AppShell

Location: `qml/AppShell.qml`

Compatibility wrapper over `ApplicationWindow`. New code should use `UIF.ApplicationWindow` directly.

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
UIF.ApplicationWindow {
    title: "UIFramework"
    navItems: ["Overview", "Runs"]
    onNavActivated: (idx, item) => console.log(idx, item)
}
```
