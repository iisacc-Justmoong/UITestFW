# Android Hello Example

Minimal LVRS Hello World example intended for Android bootstrap verification.

## Build Android bootstrap target

From repository root:

```bash
cmake -S . -B build-proof -DLVRS_BUILD_EXAMPLES=ON
cmake --build build-proof --target bootstrap_LVRSExampleAndroidHello_android
```

If Android SDK/NDK and adb are configured, LVRS will build and deploy to an attached emulator or device.
