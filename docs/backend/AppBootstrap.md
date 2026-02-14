# AppBootstrap

Location: `backend/runtime/appbootstrap.h` / `backend/runtime/appbootstrap.cpp`

`AppBootstrap`은 플랫폼별 렌더 백엔드, 렌더 품질 기본값, 폰트/텍스트 폴백을 앱 엔트리포인트에서 일관되게 적용하기 위한 통합 초기화 API이다.

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

- `preApplicationBootstrap`는 `QGuiApplication` 생성 전 호출한다.
- `postApplicationBootstrap`는 `QGuiApplication` 생성 직후 호출한다.
- 루트 `main.cpp`는 이 API를 사용하는 downstream 템플릿이며, 프레임워크 빌드 대상에는 포함되지 않는다.

## Root `main.cpp` template overrides

루트 템플릿 엔트리포인트(`main.cpp`)는 환경변수/CLI로 앱별 설정을 바로 주입할 수 있다.

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

정적 QML 플러그인으로 LVRS를 링크하는 앱은 `LVRS_USE_STATIC_QML_PLUGIN`을 정의해 `Q_IMPORT_PLUGIN(LVRSPlugin)` 경로를 활성화한다.
