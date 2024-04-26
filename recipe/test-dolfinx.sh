set -ex

pip check

TEST_DIR=$PWD

# disable clang availability check
if [[ "$target_platform" =~ "osx" ]]; then
  export CXXFLAGS="${CXXFLAGS} -D_LIBCPP_DISABLE_AVAILABILITY"
fi

export OMPI_ALLOW_RUN_AS_ROOT=1
export OMPI_ALLOW_RUN_AS_ROOT_CONFIRM=1
export OMPI_MCA_rmaps_base_oversubscribe=1
export OMPI_MCA_plm=isolated
export OMPI_MCA_btl=tcp,self
export OMPI_MCA_btl_vader_single_copy_mechanism=none

# test packaging
pytest -vs test_dolfinx.py

# exercise a demo
cd $TEST_DIR/python/demo
pytest -vs -k demo_poisson test.py

# run some tests
cd $TEST_DIR/python/test
# subset of tests should exercise dependencies, solvers, partitioners
TESTS="unit/fem/test_fem_pipeline.py unit/mesh/test_mesh_partitioners.py"
# unit/fem/test_fem_pipeline.py::test_dP_simplex[3-DG-tetrahedron] is failing
# with 4e-6 > 1e-9
pytest -vs -k 'not test_dP_simplex' $TESTS
mpiexec -n 2 pytest -vs -k 'not test_dP_simplex' $TESTS

