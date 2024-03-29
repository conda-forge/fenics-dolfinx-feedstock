set -ex

pip check

# disable clang availability check
if [[ "$target_platform" == "osx-64" ]]; then
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
export OMPI_MCA_rmaps_base_oversubscribe=1
export OMPI_MCA_plm=isolated
export OMPI_MCA_btl=tcp,self
export OMPI_MCA_btl_vader_single_copy_mechanism=none

pytest -vs test_dolfinx.py

cd python/demo
pytest -vs -k demo_poisson test.py
