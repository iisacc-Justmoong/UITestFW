# Typing Practice Example

LVRS 컴포넌트만 사용해 구성한 타자 연습 예제이다.

## Run

From repository root:

```bash
cmake -S . -B build-codex -DLVRS_BUILD_EXAMPLES=ON
cmake --build build-codex --target LVRSExampleTypingPractice
./build-codex/example/TypingPractice/LVRSExampleTypingPractice
```

macOS Finder에서는 `example/run-typing-practice.command`를 클릭해 실행할 수 있다.
