# AppBootstrap

Location: `backend/runtime/appbootstrap.h` / `backend/runtime/appbootstrap.cpp`

`AppBootstrap` is an integrated initialization API that applies platform-specific render backend policy, render-quality defaults, and font/text fallbacks consistently at app entrypoints.

## API

- `lvrs::preApplicationBootstrap(options)`
- `lvrs::postApplicationBootstrap(app, options)`

## Options (`AppBootstrapOptions`)

- `applicationName`
- `quickStyleName`
- `configureRenderQualityDefaults`
- `bootstrapGraphicsBackend`
- `logGraphicsBackend`
- `installBundledFonts`
- `installPretendardFallbacks`
- `enforcePretendardFallback`

## Typical Flow

```cpp
lvrs::AppBootstrapOptions options;
options.applicationName = QStringLiteral("MyApp");
options.quickStyleName = QStringLiteral("Basic");

const lvrs::AppBootstrapState state = lvrs::preApplicationBootstrap(options);
if (!state.ok)
    return -1;

QGuiApplication app(argc, argv);
lvrs::postApplicationBootstrap(app, options);
```

## Notes

- Call `preApplicationBootstrap` before creating `QGuiApplication`.
- Call `postApplicationBootstrap` right after creating `QGuiApplication`.
- Root `main.cpp` is a downstream template that uses this API and is not included in framework build targets.

## Root `main.cpp` template overrides

The root template entrypoint (`main.cpp`) can inject app-specific settings directly through environment variables and CLI arguments.

- CLI:
  - `--module <uri>`
  - `--root <type>`
  - `--app-name <name>`
  - `--style <name>`
- Environment:
  - `LVRS_APP_MODULE_URI`
  - `LVRS_APP_ROOT_OBJECT`
  - `LVRS_APP_NAME`
  - `LVRS_QUICK_STYLE`

Apps linking LVRS as a static QML plugin should define `LVRS_USE_STATIC_QML_PLUGIN` to enable the `Q_IMPORT_PLUGIN(LVRSPlugin)` path.
