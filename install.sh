#!/usr/bin/env sh
set -eu

# LVRS unified installer.
# Installs to a user-writable home directory prefix on all platforms.

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
PROJECT_ROOT="$SCRIPT_DIR"
BUILD_DIR="${PROJECT_ROOT}/build-install"

if [ "${HOME:-}" ]; then
    HOME_DIR="$HOME"
elif [ "${USERPROFILE:-}" ]; then
    HOME_DIR="$USERPROFILE"
else
    echo "HOME/USERPROFILE environment variable is required." >&2
    exit 1
fi

INSTALL_PREFIX="${HOME_DIR}/.local/LVRS"
BUILD_TYPE="${CMAKE_BUILD_TYPE:-Release}"
SOURCE_INSTALL_DIR="${INSTALL_PREFIX}/src/LVRS"

if ! command -v cmake >/dev/null 2>&1; then
    echo "cmake is required but not found in PATH." >&2
    exit 1
fi

echo "[LVRS] Project root : ${PROJECT_ROOT}"
echo "[LVRS] Build dir    : ${BUILD_DIR}"
echo "[LVRS] Install dir  : ${INSTALL_PREFIX}"
echo "[LVRS] Source dir   : ${SOURCE_INSTALL_DIR}"
echo "[LVRS] Build type   : ${BUILD_TYPE}"

# CMake cache can pin absolute source paths; reset stale cache after project rename/move.
if [ -f "${BUILD_DIR}/CMakeCache.txt" ]; then
    cmake -E rm -f "${BUILD_DIR}/CMakeCache.txt"
fi
if [ -d "${BUILD_DIR}/CMakeFiles" ]; then
    cmake -E rm -rf "${BUILD_DIR}/CMakeFiles"
fi

cmake -S "${PROJECT_ROOT}" -B "${BUILD_DIR}" \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" \
    -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
    -DLVRS_BUILD_EXAMPLES=OFF \
    -DLVRS_BUILD_TESTS=OFF

cmake --build "${BUILD_DIR}" --config "${BUILD_TYPE}"
cmake --install "${BUILD_DIR}" --config "${BUILD_TYPE}"

echo "[LVRS] Installing source snapshot..."
cmake -E rm -rf "${SOURCE_INSTALL_DIR}"
cmake -E make_directory "${SOURCE_INSTALL_DIR}"

# Copy project root files (CMakeLists, headers, docs, etc.).
for entry in "${PROJECT_ROOT}"/*; do
    if [ -f "${entry}" ]; then
        cmake -E copy "${entry}" "${SOURCE_INSTALL_DIR}/"
    fi
done

# Copy source directories while skipping generated/build folders.
for entry in "${PROJECT_ROOT}"/*; do
    [ -d "${entry}" ] || continue
    name=$(basename "${entry}")
    case "${name}" in
        .git|build|build-*|cmake-build-*|.idea|.vscode)
            continue
            ;;
    esac
    cmake -E copy_directory "${entry}" "${SOURCE_INSTALL_DIR}/${name}"
done

if command -v git >/dev/null 2>&1 && git -C "${PROJECT_ROOT}" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    SOURCE_REVISION=$(git -C "${PROJECT_ROOT}" rev-parse HEAD 2>/dev/null || echo unknown)
else
    SOURCE_REVISION="unknown"
fi

{
    echo "LVRS source snapshot"
    echo "project_root=${PROJECT_ROOT}"
    echo "source_revision=${SOURCE_REVISION}"
    echo "installed_at=$(date '+%Y-%m-%d %H:%M:%S %z')"
} > "${SOURCE_INSTALL_DIR}/INSTALL_SOURCE_INFO.txt"

echo "[LVRS] Install completed."
echo "[LVRS] CMake package prefix: ${INSTALL_PREFIX}"
echo "[LVRS] Use with: -DCMAKE_PREFIX_PATH=${INSTALL_PREFIX}"
echo "[LVRS] Source snapshot: ${SOURCE_INSTALL_DIR}"
