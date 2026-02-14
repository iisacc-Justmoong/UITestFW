# Debug Output Schema

Location: `backend/runtime/debuglogger.h`, `backend/runtime/debuglogger.cpp`, `backend/runtime/runtimeevents.h`, `backend/runtime/runtimeevents.cpp`, `backend/io/backend.h`, `backend/io/backend.cpp`, `example/VisualCatalog/qml/Main.qml`, `qml/components/control/util/EventListener.qml`

본 문서는 LVRS 데모 앱에서 실제로 출력되고 표시되는 디버그/런타임 이벤트 정보를 스키마 기준으로 정리한 문서이다. 목적은 다른 개발자가 로그 라인, 런타임 이벤트, QML 모니터 화면 간의 대응 관계를 즉시 추적할 수 있도록 하는 것이다.

## 1. 출력 채널

- Stdout 텍스트 로그: `LV.Debug`가 `printEntryToStdout()`를 통해 출력한다.
- Stdout JSON 로그: `LV.Debug.jsonOutput == true`일 때 `[DEBUG-ENTRY] { ... }` 형식으로 추가 출력한다.
- Debug 메모리 버퍼: `LV.Debug.entries()/filteredEntries()/summary()`로 접근한다.
- RuntimeEvents 버퍼: `LV.RuntimeEvents.recentEvents()`로 접근한다.
- Backend 훅 버퍼: `LV.Backend.hookedUserEvents()`로 접근한다.
- 데모 앱 Event Listener Monitor: `example/VisualCatalog/qml/Main.qml`의 `runtimeConsoleRows`와 `eventMonitorSamplesModel`로 표시한다.

## 2. 현재 기본 출력 정책(Main.qml 부트스트랩)

`Component.onCompleted`와 `debuggerBootstrap()` 기준 기본값은 다음과 같다.

- `LV.Debug.enabled = true` (Stdout 출력 활성화)
- `LV.Debug.verboseOutput = false`
- `LV.Debug.jsonOutput = false`
- `LV.Debug.runtimeEchoEnabled = false`
- `LV.Debug.runtimeEchoMinIntervalMs >= 250`
- `LV.Debug.stdoutMinimumLevel = "WARN"`
- `LV.Debug.stdoutNoiseReductionEnabled = true`
- `LV.Debug.runtimeCaptureEnabled = true`

즉 기본 동작은 경고 중심(`WARN/ERROR`) 출력이며, 고빈도 입력/생명주기 이벤트는 노이즈 필터로 차단된다.

## 3. LV.Debug 엔트리 스키마

`LV.Debug.log/warn/error` 및 `RuntimeEvents.eventRecorded`가 최종적으로 동일한 엔트리 버퍼(`m_entries`)에 적재된다.

### 공통 필드

- `source`: `"logger"` 또는 `"runtime"`
- `level`: `"LOG" | "WARN" | "ERROR" | "RUNTIME"`
- `component`: 예) `"Main"`, `"RenderMonitor"`, `"RuntimeEvents"`
- `event`: 이벤트 이름
- `message`: 화면/stdout 기본 라인 메시지
- `timestampEpochMs`: epoch ms
- `timestamp`: `HH:MM:SS.CS` (소수점 둘째 자리, centisecond)
- `timestampIso`: UTC ISO 문자열
- `sequence`: DebugLogger 내부 시퀀스(1부터 증가)
- `sessionElapsedMs`: Debug 세션 시작 이후 경과 ms
- `processId`
- `threadId`
- `applicationName`
- `applicationVersion`
- `data` (옵션)
- `runtimeEventSequence` (RuntimeEvents 부착 상태일 때)

### runtime 소스 추가 필드

- `uptimeMs`
- `rawEvent` (`RuntimeEvents` 원본 이벤트)

## 4. Stdout 출력 규칙

### 레벨 우선순위

- `ERROR=3`, `WARN=2`, `RUNTIME=1`, `LOG=1`, `NONE=99`
- `shouldOutputLevel(entry.level) >= stdoutMinimumLevel`일 때만 출력

### 노이즈 필터(`stdoutNoiseReductionEnabled=true`)

- `LOG` 레벨의 `created`, `shown`, `hidden`, `destroyed` 차단
- `RenderMonitor.render-stats`(`LOG`) 차단
- `RUNTIME` 레벨의 입력 고빈도 이벤트 차단:
  - `ui-event`, `mouse-move`, `hover-move`, `mouse-wheel`, `mouse-press`, `mouse-release`, `mouse-double-click`
  - `key-press`, `key-release`, `touch-event`, `tablet-event`, `tablet-proximity`, `native-gesture`

### 라인 포맷

- `verboseOutput=false`: `entry.message`만 출력
- `verboseOutput=true`: `[timestamp] [level] #sequence component.event pid=... tid=... runtimeSeq=... data=...`
- `jsonOutput=true`: 위 라인 뒤에 `[DEBUG-ENTRY] {compact-json}` 추가

## 5. RuntimeEvents 원본 이벤트(`eventRecorded`) 스키마

`recordRuntimeEvent()`가 발행하는 공통 필드:

- `sequence`
- `type`
- `timestampEpochMs`
- `uptimeMs`
- `payload` (옵션)

주요 `type`과 `payload` 핵심 키는 다음과 같다.

- `key-press`, `key-release`: `key`, `keyName`, `modifiers`, `autoRepeat`, `text`, `pressedKeys`, `pressedKeyCodes`, `activeModifierNames`
- `mouse-move`, `hover-move`: `x`, `y`, `buttons`, `pressedMouseButtons`, `modifiers`, `mouseButtonPressed`, `pointerUi`, `pointerObjectName`, `pointerClassName`, `pointerPath`
- `mouse-press`, `mouse-release`, `mouse-double-click`: 위 키 + `button`, `lastMousePressEpochMs`/`lastMouseReleaseEpochMs`, elapsed 필드
- `mouse-wheel`: 위 키 + `angleDeltaX/Y`, `pixelDeltaX/Y`, `phase`, `inverted`
- `touch-event`: `phase`, `pointCount`, `points[]`, `pointerUi`
- `tablet-event`: `phase`, `pressure`, `rotation`, `xTilt`, `yTilt`, `pointerType` 등
- `tablet-proximity`: `phase`
- `native-gesture`: `gestureType`, `value`, 포인터 정보
- `context-requested`: `x`, `y`, `modifiers`, `buttons`, `reason`, `pointerUi`
- `ui-event`: `eventType`, `objectName`, `className`, `visible`
- `daemon-started`, `daemon-stopped`, `window-attached`, `window-detached`, `counters-reset`

## 6. Runtime 상태 스냅샷 API 출력

### `LV.RuntimeEvents.snapshot()`

- `running`
- 키/마우스/UI 카운터
- `idle`, `idleForMs`
- `pid`, `rssBytes`, `uptimeMs`
- `daemonBootEpochMs`, `eventSequence`, `recentEventCount`
- `lastEvent`
- `input` (`inputState()` 결과)

### `LV.RuntimeEvents.daemonHealth()`

- `running`, `attachedWindow`
- `bootEpochMs`, `eventSequence`
- `recentEventCount`, `recentEventCapacity`
- `idle`, `idleForMs`
- `pid`
- `lastEvent`
- `input`

### `LV.RuntimeEvents.inputState()`

- 포인터 좌표/버튼/버튼명/pressed 여부
- 마지막 press/release 시각 및 elapsed
- `activePressDurationMs`
- `pointerUi` (hit-test 결과)
- `anyKeyPressed`, `pressedKeys`, `pressedKeyCodes`
- `activeModifiers`, `activeModifierNames`
- `lastKey`, `lastKeyText`, `lastKeyModifiers`

## 7. Backend 훅 출력

`LV.Backend.hookUserEvents()`는 RuntimeEvents를 구독해 별도 버퍼를 유지한다.

### `LV.Backend.hookedUserEvents(limit)`

- RuntimeEvents 원본 이벤트 + `hookEpochMs`가 추가된 리스트

### `LV.Backend.hookedUserEventSummary()`

- `hooked`
- `eventCount`
- `capacity`
- `lastEvent`
- `input` (`currentUserInputState()` 결과)
- `typeCounts` (이벤트 타입별 집계)
- `runtimeEventSequence` (런타임 연결 시)

## 8. Main.qml Event Listener Monitor 출력

### 런타임 콘솔 행(`runtimeConsoleRows[]`) 스키마

- `category`: `runtime|input|ui|render|navigation|system`
- `source`
- `type`
- `sequence`
- `timestampEpochMs`
- `uptimeMs`
- `payload`
- `summary` (타입별 요약 문자열)
- `detail` (payload 축약 문자열)

표시 타임스탬프는 `runtimeConsoleTimestamp()` 기준 `HH:MM:SS.mmm` 형식이다.

카테고리 매핑은 `runtimeConsoleCategoryForType()` 기준이다.

- 입력 계열: `key-*`, `mouse-*`, `touch-*`, `tablet-*`, `native-gesture*`, `hover-*`, `context-*`, `global-*` -> `input`
- `ui-event` -> `ui`
- `render-*` -> `render`
- `route-*`, `viewstack-*` -> `navigation`
- `daemon-*`, `window-*`, `catalog-*`, `counters-*` -> `runtime`
- 그 외 -> `system`

### EventListener 샘플(`eventMonitorSamplesModel`) 스키마

- `trigger`
- `source`
- `timestampEpochMs`
- `payload`

샘플은 `eventMonitorMaxSamples`를 초과하면 FIFO로 오래된 항목부터 제거된다.

## 9. EventListener 콜백 payload 스키마

`qml/components/control/util/EventListener.qml` 기준:

- 로컬 포인터 트리거(`clicked|pressed|released`):
  - `x`, `y`, `globalX`, `globalY`, `button`, `buttons`, `modifiers`, `isGlobal=false`
  - `ui`(옵션), `input`
  - `backend`(옵션, `includeBackendSummary=true`)
- 글로벌 트리거(`globalPressed|globalContextRequested`):
  - `x`, `y`, `globalX`, `globalY`, `buttons`, `modifiers`, `isGlobal=true`
  - `ui`(옵션), `input`, `backend`(옵션)
  - context의 경우 `reason`, `source(mouse|context)` 추가
- 키/휠 트리거는 Qt event 객체를 직접 전달한다.

중복 억제:

- 글로벌 프레스 중복 억제: `globalPressDedupMs`(기본 24ms), 좌표 오차 `globalPressDedupTolerancePx`(기본 2px)
- 컨텍스트 중복 억제: `contextDedupMs`(기본 180ms), 좌표 오차 `contextDedupTolerancePx`(기본 2px)

## 10. Render 성능 경보 출력 조건

`evaluateRenderPerformance()`가 주기적으로 검사하여 `LV.Debug`로 출력한다.

- Severe: `lastFrameMs >= 50` 또는 `fps < 18` -> `ERROR render-performance-severe` (최소 1600ms 간격)
- Degraded: `lastFrameMs >= 33` 또는 `fps < 30` -> `WARN render-performance-degraded` (최소 2000ms 간격)
- Recovery: 3초 연속 정상 상태 유지 시 `WARN render-performance-recovered`

공통 payload:

- `fps`
- `lastFrameMs`
- `frameCount`
- `backend` (`LV.RenderQuality.graphicsBackend`)
