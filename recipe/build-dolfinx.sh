# disable clang availability check
if [[ "$target_platform" == "osx-64" ]]; then
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

if [[ "$target_platform" == "linux-aarch64" || "$target_platform" == "linux-ppc64le" ]]; then
  # travis aarch/ppc builds run out of memory with parallel builds
  export CMAKE_BUILD_PARALLEL_LEVEL=1
fi

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  # needed for cross-compile openmpi
  export OPAL_CC="$CC"
  export OPAL_PREFIX="$PREFIX"
fi

$PYTHON -m pip install -vv --no-deps ./python
