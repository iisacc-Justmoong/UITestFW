# iOS Hello Example

Minimal LVRS Hello World example intended for iOS bootstrap verification.

## Build iOS bootstrap target

From repository root:

```bash
cmake -S . -B build-proof -DLVRS_BUILD_EXAMPLES=ON
cmake --build build-proof --target bootstrap_LVRSExampleIOSHello_ios
```

If successful, LVRS configures/builds an iOS app bundle and installs it to a booted simulator.
