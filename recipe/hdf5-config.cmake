set(PN HDF5)
set(_PREFIX "xxPREFIXxx")
set(${PN}_INCLUDE_DIR "${_PREFIX}/include")
set(${PN}_LIBRARY "${_PREFIX}/lib/libhdf5xxSHLIB_EXTxx")
unset(_PREFIX)

set(${PN}_FOUND TRUE)
set(${PN}_VERSION "xxVERSIONxx")
set(${PN}_ENABLE_PARALLEL TRUE)

# this file can be loaded multiple times
if (TARGET hdf5::hdf5)
  return()
endif()

add_library(hdf5::hdf5 SHARED IMPORTED)
set_property(TARGET hdf5::hdf5 PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${${PN}_INCLUDE_DIR}")
set_property(TARGET hdf5::hdf5 PROPERTY IMPORTED_LOCATION "${${PN}_LIBRARY}")
