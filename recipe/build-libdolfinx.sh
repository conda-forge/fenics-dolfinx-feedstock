# disable clang availability check
if [[ "$target_platform" == "osx-64" ]]; then
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

if [[ "${CONDA_BUILD_CROSS_COMPILATION:-0}" == "1" ]]; then
  CMAKE_ARGS="${CMAKE_ARGS} -DDOLFINX_SKIP_BUILD_TESTS=1"
  # needed for cross-compile openmpi
  export OPAL_CC="$CC"
  export OPAL_PREFIX="$PREFIX"
fi

# FindHDF5 via h5cc interrogation gets invalid paths, preventing any builds against hdf5
# inject simple hdf5-config.cmake so hdf5 can be found
# remove when updating to hdf5 1.14.1
echo "creating $PREFIX/lib/cmake/hdf5/hdf5-config.cmake"
mkdir -p $PREFIX/lib/cmake/hdf5
cat $RECIPE_DIR/hdf5-config.cmake \
  | sed "s@xxPREFIXxx@${PREFIX}@g" \
  | sed "s@xxVERSIONxx@${hdf5}@g" \
  | sed "s@xxSHLIB_EXTxx@${SHLIB_EXT}@g" \
  > $PREFIX/lib/cmake/hdf5/hdf5-config.cmake

cmake \
  ${CMAKE_ARGS} \
  -DDOLFINX_UFCX_PYTHON=OFF \
  -DDOLFINX_ENABLE_KAHIP=ON \
  -DCMAKE_INSTALL_PREFIX=$PREFIX \
  -B build \
  cpp

cmake --build build --parallel "${CPU_COUNT}"
cmake --install build
