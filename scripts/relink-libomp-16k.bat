@echo off
setlocal EnableExtensions
cd /d "%~dp0.."

if "%ANDROID_NDK_HOME%"=="" (
  echo relink-libomp-16k: ANDROID_NDK_HOME not set; skipping.
  exit /b 0
)

set "JNI_DIR=jniLibs"
if not "%~1"=="" set "JNI_DIR=%~1"

if not exist "%JNI_DIR%" (
  exit /b 0
)

set "PRE=%ANDROID_NDK_HOME%\toolchains\llvm\prebuilt\windows-x86_64"
set "CL=%PRE%\bin\clang.exe"
set "STRIP=%PRE%\bin\llvm-strip.exe"

if not exist "%CL%" (
  echo relink-libomp-16k: clang not found at "%CL%"
  exit /b 1
)

set "SYSROOT=%PRE%\sysroot"
set "RV="
for /d %%D in ("%PRE%\lib\clang\*") do set "RV=%%~nxD"
if "%RV%"=="" (
  echo relink-libomp-16k: no clang resource dir under lib\clang
  exit /b 1
)

set "APP_PLAT=24"

call :relink arm armv7-none-linux-androideabi%APP_PLAT% armeabi-v7a
if errorlevel 1 exit /b 1
call :relink i386 i686-none-linux-android%APP_PLAT% x86
if errorlevel 1 exit /b 1
exit /b 0

:relink
set "NDK_SUB=%~1"
set "TARGET=%~2"
set "ABI_DIR=%~3"
set "OUT=%JNI_DIR%\%ABI_DIR%\libomp.so"
set "LIBOMP=%PRE%\lib\clang\%RV%\lib\linux\%NDK_SUB%\libomp.a"
if not exist "%OUT%" exit /b 0
if not exist "%LIBOMP%" (
  echo relink-libomp-16k: missing "%LIBOMP%"
  exit /b 1
)
echo relink-libomp-16k: %ABI_DIR% (16 KB pages^) -^> libomp.so
"%CL%" -shared -fPIC -target "%TARGET%" --sysroot="%SYSROOT%" ^
  -Wl,-z,max-page-size=16384 -Wl,-soname,libomp.so ^
  -Wl,--build-id=sha1 -Wl,--no-rosegment ^
  -Wl,--whole-archive "%LIBOMP%" -Wl,--no-whole-archive ^
  -fuse-ld=lld ^
  -o "%OUT%.tmp" -ldl -lc -lm
if errorlevel 1 exit /b 1
move /y "%OUT%.tmp" "%OUT%" >nul
if exist "%STRIP%" "%STRIP%" --strip-unneeded "%OUT%"
exit /b 0
