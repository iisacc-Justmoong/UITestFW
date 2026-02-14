#!/bin/zsh
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build-codex"

cmake -S "$ROOT_DIR" -B "$BUILD_DIR" -DLVRS_BUILD_EXAMPLES=ON
cmake --build "$BUILD_DIR" --target LVRSExampleVisualCatalog

BIN_PATH="$(find "$BUILD_DIR" -type f -name LVRSExampleVisualCatalog -perm -111 | head -n 1)"
if [[ -z "${BIN_PATH}" ]]; then
    echo "LVRSExampleVisualCatalog binary not found under $BUILD_DIR" >&2
    exit 1
fi

exec "$BIN_PATH"
