#!/usr/bin/env bash
# Rebuild libomp.so from NDK's libomp.a with 16 KB ELF LOAD alignment.
# Required for armeabi-v7a / x86: the NDK prebuilt libomp.so uses 4 KB (0x1000)
# while arm64-v8a / x86_64 prebuilts are already 0x4000.
#
# Usage (from repo root):
#   scripts/relink-libomp-16k.sh [jniLibs_dir]
# Env: ANDROID_NDK_HOME or NDK

set -euo pipefail

ROOT="$(cd "$(dirname "${0}")/.." && pwd)"
JNI_DIR="${1:-${ROOT}/jniLibs}"
NDK="${ANDROID_NDK_HOME:-${NDK:-}}"

if [[ ! -d "$JNI_DIR" ]]; then
  exit 0
fi
if [[ -z "$NDK" || ! -d "$NDK/toolchains/llvm/prebuilt" ]]; then
  echo "relink-libomp-16k: ANDROID_NDK_HOME not set or invalid; skipping." >&2
  exit 0
fi

discover_pre() {
  local d
  for d in "$NDK/toolchains/llvm/prebuilt/"*; do
    if [[ -x "$d/bin/clang" ]]; then
      echo "$d"
      return 0
    fi
  done
  return 1
}

PRE="$(discover_pre)" || {
  echo "relink-libomp-16k: no usable clang under $NDK/toolchains/llvm/prebuilt" >&2
  exit 1
}
CL="${PRE}/bin/clang"
STRIP="${PRE}/bin/llvm-strip"

if [[ ! -x "$CL" ]]; then
  echo "relink-libomp-16k: missing clang at $CL" >&2
  exit 1
fi

SYSROOT="${PRE}/sysroot"
shopt -s nullglob
CLANG_LIB=( "${PRE}/lib/clang"/* )
if [[ ${#CLANG_LIB[@]} -eq 0 ]]; then
  echo "relink-libomp-16k: no toolchain clang resource dir" >&2
  exit 1
fi
RV="$(basename "${CLANG_LIB[0]}")"

app_plat="24"
if [[ -f "$ROOT/Application.mk" ]]; then
  app_plat="$(grep -E '^[[:space:]]*APP_PLATFORM[[:space:]]*:=' "$ROOT/Application.mk" | head -1 | sed -E 's/.*android-//;s/[[:space:]]*$//')"
  [[ -z "$app_plat" ]] && app_plat="24"
fi

relink_one() {
  local ndk_clang_subdir="$1"  # arm | i386
  local target="$2"
  local abi_dir="$3"
  local out="${JNI_DIR}/${abi_dir}/libomp.so"
  local libomp_a="${PRE}/lib/clang/${RV}/lib/linux/${ndk_clang_subdir}/libomp.a"

  [[ -f "$out" ]] || return 0
  [[ -f "$libomp_a" ]] || {
    echo "relink-libomp-16k: missing $libomp_a" >&2
    return 1
  }

  echo "relink-libomp-16k: ${abi_dir} (16 KB pages) -> $(basename "$out")"
  local tmp="${out}.tmp"
  "$CL" -shared -fPIC -target "${target}" --sysroot="${SYSROOT}" \
    -Wl,-z,max-page-size=16384 -Wl,-soname,libomp.so \
    -Wl,--build-id=sha1 -Wl,--no-rosegment \
    -Wl,--whole-archive "${libomp_a}" -Wl,--no-whole-archive \
    -fuse-ld=lld \
    -o "${tmp}" -ldl -lc -lm
  mv -f "${tmp}" "${out}"
  if [[ -x "$STRIP" ]]; then
    "$STRIP" --strip-unneeded "${out}"
  fi
}

relink_one arm "armv7-none-linux-androideabi${app_plat}" armeabi-v7a
relink_one i386 "i686-none-linux-android${app_plat}" x86

exit 0
