# cmake toolchain for finding Intel MPI

set(_LIBRARY_PREFIX "$ENV{LIBRARY_PREFIX}")

set(MPI_C_ADDITIONAL_INCLUDE_DIRS
    "${_LIBRARY_PREFIX}/include"
    CACHE STRING "MPI C additional include directories" FORCE
)
set(MPI_CXX_ADDITIONAL_INCLUDE_DIRS
    "${_LIBRARY_PREFIX}/include"
    CACHE STRING "MPI CXX additional include directories" FORCE
)

set(MPI_C_LIB_NAMES
    "IMPI"
    CACHE STRING "MPI C lib name" FORCE
)
set(MPI_CXX_LIB_NAMES
    "IMPI"
    CACHE STRING "MPI CXX lib name" FORCE
)

set(MPI_IMPI_LIBRARY
    "${_LIBRARY_PREFIX}/lib/impi.lib"
    CACHE STRING "MPI C/CXX libraries" FORCE
)

set(MPI_ASSUME_NO_BUILTIN_MPI
    TRUE
    CACHE BOOL "" FORCE
)

set(MPI_C_COMPILER
    "${_LIBRARY_PREFIX}/mpicc.bat"
    CACHE STRING "MPI C Compiler" FORCE
)
set(MPI_CXX_COMPILER
    "${_LIBRARY_PREFIX}/mpicxx.bat"
    CACHE STRING "MPI C Compiler" FORCE
)
