setlocal EnableDelayedExpansion
@echo on

set "CXXFLAGS=%CXXFLAGS% -DH5_BUILT_AS_DYNAMIC_LIB"

set "SKBUILD_CMAKE_ARGS=-DCMAKE_PREFIX_PATH=%LIBRARY_PREFIX%;-DCMAKE_TOOLCHAIN_FILE=%RECIPE_DIR%\impi-toolchain.cmake;-DHDF5_NO_FIND_PACKAGE_CONFIG_FILE=ON;-DHDF5_ROOT=%LIBRARY_PREFIX%"
set PIP_DISABLE_PIP_VERSION_CHECK=1

echo CXXFLAGS=!CXXFLAGS!
echo CMAKE_ARGS=!CMAKE_ARGS!
echo SKBUILD_CMAKE_ARGS=!SKBUILD_CMAKE_ARGS!

%PYTHON% -m pip install -v --no-deps --no-build-isolation ./python --config-settings=cmake.verbose=true
if errorlevel 1 exit 1
