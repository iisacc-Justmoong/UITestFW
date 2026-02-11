# ViewModels

Location: `backend/state/viewmodelregistry.h` / `backend/state/viewmodelregistry.cpp`

Registry and MVVM ownership hub for ViewModel instances.

## Methods
- `get(key)`
- `set(key, object)`
- `remove(key)`
- `clear()`
- `bindView(viewId, key, writable)` binds a view to a ViewModel key.
- `getForView(viewId)` resolves the bound ViewModel for a view.
- `keyForView(viewId)` returns bound key.
- `claimOwnership(viewId, key)` / `releaseOwnership(viewId, key)` controls write ownership.
- `canWrite(viewId, key)` checks write permission.
- `updateProperty(viewId, property, value)` writes model data with ownership validation.
- `readProperty(viewId, property)` reads model data from the bound ViewModel.

## Usage
```qml
Component.onCompleted: UIF.ViewModels.bindView("OverviewView", "Main", true)
property var vm: UIF.ViewModels.getForView("OverviewView")
UIF.ViewModels.updateProperty("OverviewView", "status", "Working")
```
