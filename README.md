
# Android ImageMagick 7.1.2-22

Fork maintained at **[codewithtamim/Android-ImageMagick7](https://github.com/codewithtamim/Android-ImageMagick7)**.  
Upstream base: **[MolotovCherry/Android-ImageMagick7](https://github.com/MolotovCherry/Android-ImageMagick7)** (wiki, history, and general Android ImageMagick guidance still apply there).

This is a fully featured ImageMagick 7 build for Android. Libraries are pinned to known-good versions with delegates enabled for typical image conversion workloads.

It can be configured to build as a static binary, as shared libraries, or both (see `Application.mk`).

MagickWand is enabled for the `magick` CLI-style binary; Magick++ can be toggled there as well.

## What this fork adds (vs upstream)

- **HEIC / HEIF** via **libheif** (vendored) and **libde265** for HEVC decode, wired into ImageMagick as `MAGICKCORE_HEIC_DELEGATE` (`make/libheif.mk`, `make/libde265.mk`, `Android.mk`).
- **AVIF** (read/write) through the same **HEIC coder** in ImageMagick: libheif’s AV1 path using **libaom**; static `libaom.a` per ABI is produced under `prebuilt-libaom/` by the script below (archives are **gitignored**, not committed).
- **`scripts/build-libaom-android.sh`**: writes `prebuilt-libaom/<abi>/libaom.a` + `prebuilt-libaom/include/` using **CMake**, **Ninja**, and **ANDROID_NDK_HOME**. Run before `ndk-build` locally; GitHub Actions runs it per ABI first. Pass ABI names for a subset (e.g. `./scripts/build-libaom-android.sh x86_64`).
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

**Bundled / linked for HEIC+AVIF:** libde265, libheif (static), libaom (static per ABI, from `build-libaom-android.sh`, not stored in Git).

**Support libraries (as upstream):** libicu4c, libiconv, libltdl (e.g. for OpenCL), etc.

## Android support

**Requires API ≥ 24 (Nougat+)** for the default `APP_PLATFORM`.

## Building

1. Install the **Android NDK** (r26+ tested; **r29** used in recent builds).
2. **Generate libaom prebuilts** (needs CMake + Ninja on `PATH`, e.g. from Android SDK `cmake/<ver>/bin`). Required for the default **HEIC/AVIF** stack; the `libaom.a` files are **gitignored** and not shipped in the repo.

   ```bash
   export ANDROID_NDK_HOME=/path/to/ndk
   ./scripts/build-libaom-android.sh
   ```

   This clones **`libaom/`** (gitignored) if missing and writes `prebuilt-libaom/<abi>/libaom.a` plus `prebuilt-libaom/include/`.

3. **ndk-build** from the repo root (same pattern as upstream wiki):

   ```bash
   ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk NDK_OUT=./build/ NDK_LIBS_OUT=./jniLibs
   ```

   With **OpenMP** enabled (default), the NDK’s **`libomp.so` for 32-bit ABIs** (`armeabi-v7a`, `x86`) ships with **4 KB** ELF alignment. Rebuild it from the NDK’s `libomp.a` for **16 KB** compatibility:

   ```bash
   ./scripts/relink-libomp-16k.sh
   ```

   (`build-release.bat` / `build-debug.bat` run `scripts\relink-libomp-16k.bat` after `ndk-build` on Windows when `ANDROID_NDK_HOME` is set. **arm64-v8a** / **x86_64** NDK `libomp.so` is already 16 KB–aligned; the script only touches ABIs where `jniLibs/<abi>/libomp.so` exists.)

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
