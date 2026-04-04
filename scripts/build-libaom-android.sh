#!/usr/bin/env bash
# Build static libaom for each Android ABI (CMake + NDK). Run from repo root:
#   ./scripts/build-libaom-android.sh
# Requires: cmake, ninja, ANDROID_NDK_HOME (or NDK) pointing at NDK r26+.
# Outputs: prebuilt-libaom/<abi>/libaom.a and prebuilt-libaom/include/aom/*.h
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
NDK="${ANDROID_NDK_HOME:-${NDK:-$HOME/Android/Sdk/ndk/29.0.13113456}}"

if [[ ! -f "$NDK/build/cmake/android.toolchain.cmake" ]]; then
  echo "NDK not found at $NDK (set ANDROID_NDK_HOME)" >&2
  exit 1
fi

command -v cmake >/dev/null 2>&1 || { echo "cmake not installed" >&2; exit 1; }
command -v ninja >/dev/null 2>&1 || { echo "ninja not installed" >&2; exit 1; }

if [[ ! -f "$ROOT/libaom/CMakeLists.txt" ]]; then
  echo "Cloning libaom into $ROOT/libaom ..." >&2
  git clone --depth 1 https://aomedia.googlesource.com/aom "$ROOT/libaom"
fi

OUT="$ROOT/prebuilt-libaom"
mkdir -p "$OUT"

aom_cpu_flags() {
  case "${1:?}" in
    armeabi-v7a) echo -DAOM_TARGET_CPU=generic -DENABLE_NEON=1 ;;
    arm64-v8a)   echo -DAOM_TARGET_CPU=generic -DENABLE_NEON=1 ;;
    x86_64)      echo -DAOM_TARGET_CPU=generic ;;
    *) echo "unknown ABI: $1" >&2; exit 1 ;;
  esac
}

build_one() {
  local abi="${1:?}"
  local B="$OUT/_cmake_$abi"
  rm -rf "$B"
  # shellcheck disable=SC2046
  cmake -S "$ROOT/libaom" -B "$B" -G Ninja \
    -DCMAKE_TOOLCHAIN_FILE="$NDK/build/cmake/android.toolchain.cmake" \
    -DANDROID_ABI="$abi" \
    -DANDROID_PLATFORM=android-24 \
    $(aom_cpu_flags "$abi") \
    -DCONFIG_PIC=1 \
    -DBUILD_SHARED_LIBS=OFF \
    -DENABLE_EXAMPLES=OFF \
    -DENABLE_TOOLS=OFF \
    -DENABLE_TESTS=OFF \
    -DENABLE_DOCS=OFF \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$B/prefix"

  cmake --build "$B" -j"$(nproc 2>/dev/null || echo 4)"
  cmake --install "$B"

  mkdir -p "$OUT/$abi"
  cp "$B/prefix/lib/libaom.a" "$OUT/$abi/libaom.a"
  if [[ ! -d "$OUT/include/aom" ]]; then
    mkdir -p "$OUT/include"
    cp -R "$B/prefix/include/"* "$OUT/include/"
  fi
  echo "  -> $OUT/$abi/libaom.a"
}

for abi in arm64-v8a armeabi-v7a x86_64; do
  echo "Building libaom for $abi ..."
  build_one "$abi"
done

rm -rf "$OUT"/_cmake_*
echo "Done. Link with ndk-build (libaom prebuilt module). Headers: $OUT/include"
