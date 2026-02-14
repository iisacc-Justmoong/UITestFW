#!/usr/bin/env sh
set -eu

# LVRS unified installer.
# Goal: after git clone + ./install.sh, downstream projects can use:
#   find_package(LVRS CONFIG REQUIRED)
# without manually adding LVRS to CMAKE_PREFIX_PATH.

usage() {
    cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --prefix <path>      Install prefix (default: ~/.local/LVRS)
  --build-dir <path>   Build directory (default: <repo>/build-install)
  --build-type <type>  CMake build type (default: Release)
  --clean              Remove previous build cache before configure
  --no-source-snapshot Skip source snapshot copy into <prefix>/src/LVRS
  --no-registry        Skip CMake user package registry registration
  -h, --help           Show this help
EOF
}

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
SOURCE_SNAPSHOT=1
REGISTER_CMAKE_REGISTRY=1
CLEAN_BUILD_CACHE=0

while [ "$#" -gt 0 ]; do
    case "$1" in
        --prefix)
            [ "$#" -ge 2 ] || { echo "Missing value for --prefix" >&2; exit 1; }
            INSTALL_PREFIX="$2"
            shift 2
            ;;
        --build-dir)
            [ "$#" -ge 2 ] || { echo "Missing value for --build-dir" >&2; exit 1; }
            BUILD_DIR="$2"
            shift 2
            ;;
        --build-type)
            [ "$#" -ge 2 ] || { echo "Missing value for --build-type" >&2; exit 1; }
            BUILD_TYPE="$2"
            shift 2
            ;;
        --clean)
            CLEAN_BUILD_CACHE=1
            shift
            ;;
        --no-source-snapshot)
            SOURCE_SNAPSHOT=0
            shift
            ;;
        --no-registry)
            REGISTER_CMAKE_REGISTRY=0
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

SOURCE_INSTALL_DIR="${INSTALL_PREFIX}/src/LVRS"
PACKAGE_CONFIG_DIR="${INSTALL_PREFIX}/lib/cmake/LVRS"

if ! command -v cmake >/dev/null 2>&1; then
    echo "cmake is required but not found in PATH." >&2
    exit 1
fi

echo "[LVRS] Project root : ${PROJECT_ROOT}"
echo "[LVRS] Build dir    : ${BUILD_DIR}"
echo "[LVRS] Install dir  : ${INSTALL_PREFIX}"
echo "[LVRS] Build type   : ${BUILD_TYPE}"
echo "[LVRS] Registry     : ${REGISTER_CMAKE_REGISTRY}"
echo "[LVRS] Snapshot     : ${SOURCE_SNAPSHOT}"

if [ "${CLEAN_BUILD_CACHE}" -eq 1 ]; then
    echo "[LVRS] Cleaning previous build cache..."
    if [ -f "${BUILD_DIR}/CMakeCache.txt" ]; then
        cmake -E rm -f "${BUILD_DIR}/CMakeCache.txt"
    fi
    if [ -d "${BUILD_DIR}/CMakeFiles" ]; then
        cmake -E rm -rf "${BUILD_DIR}/CMakeFiles"
    fi
fi

if ! cmake -S "${PROJECT_ROOT}" -B "${BUILD_DIR}" \
    -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}" \
    -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
    -DLVRS_BUILD_SHARED_LIBS=ON \
    -DLVRS_BUILD_EXAMPLES=OFF \
    -DLVRS_BUILD_TESTS=OFF; then
    echo "[LVRS] Configure failed." >&2
    echo "[LVRS] If Qt is not auto-detected, pass your Qt prefix, e.g.:" >&2
    echo "       CMAKE_PREFIX_PATH=/path/to/Qt ./install.sh" >&2
    exit 1
fi

cmake --build "${BUILD_DIR}" --config "${BUILD_TYPE}"
cmake --install "${BUILD_DIR}" --config "${BUILD_TYPE}"

if [ "${SOURCE_SNAPSHOT}" -eq 1 ]; then
    echo "[LVRS] Installing source snapshot..."
    cmake -E rm -rf "${SOURCE_INSTALL_DIR}"
    cmake -E make_directory "${SOURCE_INSTALL_DIR}"

    for entry in "${PROJECT_ROOT}"/*; do
        if [ -f "${entry}" ]; then
            cmake -E copy "${entry}" "${SOURCE_INSTALL_DIR}/"
        fi
    done

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
fi

if [ "${REGISTER_CMAKE_REGISTRY}" -eq 1 ]; then
    if [ "${APPDATA:-}" ]; then
        CMAKE_USER_PACKAGE_DIR="${APPDATA}/CMake/packages/LVRS"
    else
        CMAKE_USER_PACKAGE_DIR="${HOME_DIR}/.cmake/packages/LVRS"
    fi
    cmake -E make_directory "${CMAKE_USER_PACKAGE_DIR}"

    # Remove stale entries that point to old LVRS installs under the same prefix root.
    if [ -d "${CMAKE_USER_PACKAGE_DIR}" ]; then
        for entry in "${CMAKE_USER_PACKAGE_DIR}"/*; do
            [ -f "${entry}" ] || continue
            if grep -Fq "${INSTALL_PREFIX}" "${entry}" 2>/dev/null; then
                cmake -E rm -f "${entry}"
            fi
        done
    fi

    REGISTRY_ENTRY="${CMAKE_USER_PACKAGE_DIR}/$(date +%s)-$$"
    printf '%s\n' "${PACKAGE_CONFIG_DIR}" > "${REGISTRY_ENTRY}"
    echo "[LVRS] Registered CMake package: ${REGISTRY_ENTRY}"
fi

ENV_FILE="${INSTALL_PREFIX}/env.sh"
{
    echo "#!/usr/bin/env sh"
    echo "# LVRS environment helper"
    echo "export CMAKE_PREFIX_PATH=\"${INSTALL_PREFIX}:\${CMAKE_PREFIX_PATH:-}\""
    echo "export QML2_IMPORT_PATH=\"${INSTALL_PREFIX}/lib/qt6/qml:\${QML2_IMPORT_PATH:-}\""
} > "${ENV_FILE}"
chmod +x "${ENV_FILE}"

echo "[LVRS] Install completed."
echo "[LVRS] CMake package dir : ${PACKAGE_CONFIG_DIR}"
echo "[LVRS] Env helper        : ${ENV_FILE}"
echo "[LVRS] Downstream CMake  : find_package(LVRS CONFIG REQUIRED)"
