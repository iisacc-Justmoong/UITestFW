# Debug

Location: `backend/runtime/debuglogger.h` / `backend/runtime/debuglogger.cpp`

`Debug`는 QML/C++ 공용 로거 singleton이며, 메모리 버퍼와 stdout 출력을 함께 제공한다.

핵심 API:

- `log(component, event, data?)`
- `warn(component, event, data?)`
- `error(component, event, data?)`
- `entries(limit?)`, `filteredEntries(limit?)`, `summary()`
- `attachRuntimeEvents()`, `detachRuntimeEvents()`

정확한 출력 스키마와 필드 정의는 다음 문서를 기준으로 확인한다.

- `docs/backend/DebugOutput.md`
