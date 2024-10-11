# disable clang availability check
if [[ "$target_platform" =~ "osx" ]]; then
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

if [[ "$target_platform" == "linux-aarch64" || "$target_platform" == "linux-ppc64le" ]]; then
  # travis aarch/ppc builds run out of memory with parallel builds
  export CMAKE_BUILD_PARALLEL_LEVEL=1
fi

# cross-compiled linux produces wrong wheel tags
# causing pip check to fail
if [[ "${target_platform}" == "linux-aarch64" ]]; then
  export _PYTHON_HOST_PLATFORM=linux_aarch64
elif [[ "${target_platform}" == "linux-ppc64le" ]]; then
  export _PYTHON_HOST_PLATFORM=linux_ppc64le
fi

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  # needed for cross-compile openmpi
  export OPAL_CC="$CC"
  export OPAL_PREFIX="$PREFIX"

  # find cross-python
  # specifically Python3_INCLUDE_DIR
  PY_INC=$( "${PYTHON}" -c 'import sysconfig; print(sysconfig.get_path("include"))' )
  export CMAKE_ARGS="${CMAKE_ARGS} -DPython3_INCLUDE_DIR=${PY_INC}"
fi

export CMAKE_GENERATOR=Ninja

$PYTHON -m pip install -vv --no-deps --no-build-isolation ./python
