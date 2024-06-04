setlocal EnableDelayedExpansion
@echo on

set "CXXFLAGS=%CXXFLAGS% -DH5_BUILT_AS_DYNAMIC_LIB"

cmake ^
  -G Ninja ^
  %CMAKE_ARGS% ^
  -D CMAKE_TOOLCHAIN_FILE=%RECIPE_DIR%\impi-toolchain.cmake ^
  -D HDF5_FIND_DEBUG=ON ^
  -D HDF5_NO_FIND_PACKAGE_CONFIG_FILE=ON ^
  -D HDF5_ROOT=%LIBRARY_PREFIX% ^
  -D DOLFINX_BASIX_PYTHON=OFF ^
  -D DOLFINX_UFCX_PYTHON=OFF ^
  -D DOLFINX_ENABLE_SCOTCH=ON ^
  -D DOLFINX_ENABLE_ADIOS2=OFF ^
  -D DOLFINX_ENABLE_KAHIP=OFF ^
  -D DOLFINX_ENABLE_PETSC=OFF ^
  -D DOLFINX_ENABLE_SLEPC=OFF ^
  -D DOLFINX_ENABLE_PARMETIS=OFF ^
  -B build ^
  cpp
if errorlevel 1 (
  dir build
  dir build\CMakeFiles
  type build\CMakeFiles\CMakeConfigureLog.yaml
  exit 1
)

cmake --build build --parallel "%CPU_COUNT%" --verbose
if errorlevel 1 (
  dir build
  dir build\CMakeFiles
  type build\CMakeFiles\CMakeError.log
  exit 1
)

cmake --install build
if errorlevel 1 exit 1
