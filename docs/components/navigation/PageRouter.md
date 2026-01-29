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

## Usage
```qml
UIF.PageRouter {
    id: router
    routes: [
        { path: "/", component: homePage },
        { path: "/runs/[id]", component: runPage }
    ]
}
```
