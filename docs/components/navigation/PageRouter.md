# PageRouter

Location: `qml/components/navigation/PageRouter.qml`

Stack-based navigation with Svelte-like path syntax and SwiftUI-like stack control.

## Path Syntax
- `/runs/[id]` dynamic segment
- `/logs/[...path]` rest segment

## Stack Control
- `path`: array of paths for stack state
- `push(path)`, `pop()`, `popToRoot()`
- `setRoot(path)`

## Delegation
- `registerAsGlobalNavigator` defaults to `true`.
- When enabled, `Navigator` auto-targets this router.

## MVVM Route Meta
- `viewModelKey` or `modelKey`: ViewModel key to bind.
- `viewId`: optional logical view identifier.
- `writable` or `modelWritable`: whether the view owns write permission.

## Usage
```qml
UIF.PageRouter {
    id: router
    routes: [
        { path: "/", component: homePage, viewModelKey: "Overview", writable: true },
        { path: "/runs/[id]", component: runPage, viewModelKey: "RunDetails" }
    ]
}

UIF.Navigator.go("/runs/42")
```
