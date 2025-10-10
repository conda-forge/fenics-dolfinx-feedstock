# disable clang availability check
if [[ "$target_platform" =~ "osx" ]]; then
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  CMAKE_ARGS="${CMAKE_ARGS} -DDOLFINX_SKIP_BUILD_TESTS=1"
  # needed for cross-compile openmpi
  export OPAL_CC="$CC"
  export OPAL_PREFIX="$PREFIX"
fi

export CMAKE_GENERATOR=Ninja

cmake \
  ${CMAKE_ARGS} \
  -DDOLFINX_BASIX_PYTHON=OFF \
  -DDOLFINX_UFCX_PYTHON=OFF \
  -DDOLFINX_ENABLE_ADIOS2=ON \
  -DDOLFINX_ENABLE_KAHIP=ON \
  -DDOLFINX_ENABLE_PETSC=ON \
  -DDOLFINX_ENABLE_SLEPC=ON \
  -DDOLFINX_ENABLE_PARMETIS=ON \
  -DDOLFINX_ENABLE_SCOTCH=ON \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -B build \
  cpp

cmake --build build --parallel "${CPU_COUNT}" --verbose
cmake --install build
