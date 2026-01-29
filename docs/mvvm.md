# MVVM

MVVM flow used in this framework:

1. C++ Model holds state
2. C++ ViewModel wraps Model and exposes QML-facing API
3. ViewModel registered into `ViewModels`
4. QML view fetches by key and binds

See `example/` for a complete reference implementation.
