setlocal EnableDelayedExpansion
@echo on

ffcx cpp/test/poisson.py -o cpp/test
if errorlevel 1 exit 1

cmake %CMAKE_ARGS% ^
  --debug-output --debug-trycompile ^
  -D CMAKE_TOOLCHAIN_FILE=%RECIPE_DIR%\impi-toolchain.cmake ^
  -D CMAKE_BUILD_TYPE=Developer ^
  -B build-test/ ^
  -S cpp/test/
if errorlevel 1 (
  dir build-test
  dir build-test\CMakeFiles
  type build-test\CMakeFiles\CMakeConfigureLog.yaml

  exit 1
)

cmake --build build-test --verbose
if errorlevel 1 exit 1

cd build-test
ctest -V --output-on-failure -R unittests
if errorlevel 1 exit 1

mpiexec -n 2 ctest -V --output-on-failure -R unittests
if errorlevel 1 exit 1
