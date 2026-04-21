
# Android ImageMagick 7.1.2-21

Fork maintained at **[codewithtamim/Android-ImageMagick7](https://github.com/codewithtamim/Android-ImageMagick7)**.  
Upstream base: **[MolotovCherry/Android-ImageMagick7](https://github.com/MolotovCherry/Android-ImageMagick7)** (wiki, history, and general Android ImageMagick guidance still apply there).

This is a fully featured ImageMagick 7 build for Android. Libraries are pinned to known-good versions with delegates enabled for typical image conversion workloads.

It can be configured to build as a static binary, as shared libraries, or both (see `Application.mk`).

MagickWand is enabled for the `magick` CLI-style binary; Magick++ can be toggled there as well.

## What this fork adds (vs upstream)

- **HEIC / HEIF** via **libheif** (vendored) and **libde265** for HEVC decode, wired into ImageMagick as `MAGICKCORE_HEIC_DELEGATE` (`make/libheif.mk`, `make/libde265.mk`, `Android.mk`).
- **AVIF** (read/write) through the same **HEIC coder** in ImageMagick: libheif’s AV1 path using **libaom**, supplied as **prebuilt static libraries** per ABI under `prebuilt-libaom/` (see below).
- **`scripts/build-libaom-android.sh`**: rebuilds `prebuilt-libaom/<abi>/libaom.a` + headers using **CMake**, **Ninja**, and **ANDROID_NDK_HOME** (optional if you keep the committed prebuilts).
- **`make/libaom.mk`**: imports those prebuilts for `ndk-build`.
- **Linux / NDK `ndk-build` fixes** so the tree builds on bash hosts without Windows-only assumptions, including:
  - **`make/libjpeg-turbo.mk`**: avoid shell glob/`#` issues when generating `jconfig.h` / `jconfigint.h`.
  - **`make/libicu4c.mk`**: same for generated ICU headers.
  - **`make/magick.mk`**: avoid `-L/usr/lib` when `SYSROOT` is empty; link OpenMP/`magick` correctly on AArch64.
  - **`make/libfftw.mk`**: no PowerShell on ARM; **`libfftw-3.3.8/configs/arm/config.h`**: disable NEON for double-precision FFTW on **armeabi-v7a** so symbols match ImageMagick’s `fftw_*` usage.
- **`Application.mk`**: `LIBHEIF_ENABLED`, `APP_ABI` aligned with **arm64-v8a**, **armeabi-v7a**, **x86_64** (no 32-bit x86 in default set).

## Features (typical build)

- OpenMP(3.1) (OpenCL optional via upstream Qualcomm paths)
- HDRI, Q16 quantum depth
- Cipher, DPC

## Delegates and codecs

**ImageMagick delegates (representative):** bzlib, fftw, freetype, **heic** (HEIF/HEIC + AVIF through libheif), jpeg, lcms, lzma, png, tiff, webp, xml, zlib — plus jng as in upstream configs.

**Bundled / linked for HEIC+AVIF:** libde265, libheif (static), libaom (prebuilt static per ABI).

**Support libraries (as upstream):** libicu4c, libiconv, libltdl (e.g. for OpenCL), etc.

## Android support

**Requires API ≥ 24 (Nougat+)** for the default `APP_PLATFORM`.

## Building

1. Install the **Android NDK** (r26+ tested; **r29** used in recent builds).
2. **Optional — refresh libaom prebuilts** (needs CMake + Ninja on `PATH`, e.g. from Android SDK `cmake/<ver>/bin`):

   ```bash
   export ANDROID_NDK_HOME=/path/to/ndk
   ./scripts/build-libaom-android.sh
   ```

   This clones **`libaom/`** (gitignored) if missing and refreshes `prebuilt-libaom/` + `prebuilt-libaom/include/`.

3. **ndk-build** from the repo root (same pattern as upstream wiki):

   ```bash
   ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk NDK_OUT=./build/ NDK_LIBS_OUT=./jniLibs
   ```

Artifacts appear under `jniLibs/<abi>/` (e.g. `magick`, `libc++_shared.so`, `libomp.so` depending on config).

If `prebuilt-libaom/<abi>/libaom.a` is missing, `ndk-build` stops with an error pointing at the script above.

## Binaries and releases

Build artifacts are produced locally (or via your own CI). Upstream publishes [release binaries](https://github.com/MolotovCherry/Android-ImageMagick7/releases) for the **stock** delegate set; this fork’s **HEIC/AVIF** stack requires building here or using outputs from this repository once published.

OpenCL (Qualcomm) setup remains as in [upstream `libopencl`](https://github.com/MolotovCherry/Android-ImageMagick7/tree/master/libopencl/qualcomm/lib).

## Docs and community (upstream)

- [Wiki home](https://github.com/MolotovCherry/Android-ImageMagick7/wiki)  
- [Setup & building](https://github.com/MolotovCherry/Android-ImageMagick7/wiki/Setup--&--building-instructions)  
- [ADB testing](https://github.com/MolotovCherry/Android-ImageMagick7/wiki/Running-from-ADB-(for-testing))  
- [FAQ](https://github.com/MolotovCherry/Android-ImageMagick7/wiki/FAQ)  
- [Discussions](https://github.com/MolotovCherry/Android-ImageMagick7/discussions)

For issues specific to **this fork** (HEIC/AVIF, libaom prebuilts, `ndk-build` on Linux), prefer the **[codewithtamim/Android-ImageMagick7](https://github.com/codewithtamim/Android-ImageMagick7)** issue tracker once published.
