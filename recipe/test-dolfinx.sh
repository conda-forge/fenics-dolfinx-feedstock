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

pushd python/demo
pytest -vs -k demo_poisson test.py
popd

pushd python/test

export PYTEST_ADDOPTS="${PYTEST_ADDOPTS:-} -v --maxfail 3 --durations 30"

# skip the slowest tests that aren't relevant to whether it was built right
export PYTEST_ADDOPTS="${PYTEST_ADDOPTS} --ignore unit/fem/test_dof_permuting.py --ignore unit/fem/test_element_integrals.py"

# run tests for n=1
pytest
# run tests for n=2
mpiexec -n 2 pytest
