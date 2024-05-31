# cmake toolchain for finding Intel MPI

set(_LIBRARY_PREFIX "$ENV{LIBRARY_PREFIX}")

set(MPI_C_ADDITIONAL_INCLUDE_DIRS
    "${_LIBRARY_PREFIX}/include"
    CACHE STRING "MPI C additional include directories"
)
set(MPI_CXX_ADDITIONAL_INCLUDE_DIRS
    "${_LIBRARY_PREFIX}/include"
    CACHE STRING "MPI CXX additional include directories"
)

set(MPI_C_LIB_NAMES
    "IMPI"
    CACHE STRING "MPI C lib name"
)
set(MPI_CXX_LIB_NAMES
    "IMPI"
    CACHE STRING "MPI CXX lib name"
)
# MPI_{LIB_NAME}_LIBRARY sets path for above
set(MPI_IMPI_LIBRARY
    "${_LIBRARY_PREFIX}/lib/impi.lib"
    CACHE STRING "MPI C/CXX libraries"
)

set(MPI_ASSUME_NO_BUILTIN_MPI
    TRUE
    CACHE BOOL ""
)

set(MPI_C_COMPILER
    "${_LIBRARY_PREFIX}/bin/mpicc.bat"
    CACHE STRING "MPI C Compiler"
)
set(MPI_CXX_COMPILER
    "${_LIBRARY_PREFIX}/bin/mpicxx.bat"
    CACHE STRING "MPI C Compiler"
)
