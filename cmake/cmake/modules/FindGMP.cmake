#[=============================================================================[
Find the GMP library.
https://gmplib.org/

Module defines the following IMPORTED target:

  GMP::GMP
    The GMP library, if found.

If GMP library is found, the following variables are set:

  GMP_FOUND
    Set to 1 if GMP library is found.
  GMP_INCLUDE_DIRS
    A list of include directories for using GMP library.
  GMP_LIBRARIES
    A list of libraries for using GMP library.
  GMP_VERSION
    Version string of found GMP library.
#]=============================================================================]

include(FindPackageHandleStandardArgs)

find_package(PkgConfig QUIET)

if(PKG_CONFIG_FOUND)
  if(GMP_FIND_VERSION)
    set(_pkg_module_spec "gmp>=${GMP_FIND_VERSION}")
  else()
    set(_pkg_module_spec "gmp")
  endif()

  pkg_search_module(GMP QUIET "${_pkg_module_spec}")

  unset(_pkg_module_spec)
endif()

find_package_handle_standard_args(
  GMP
  REQUIRED_VARS GMP_LIBRARIES
  VERSION_VAR GMP_VERSION
  REASON_FAILURE_MESSAGE "GMP not found. Please install GMP library (libgmp)."
)

if(GMP_FOUND AND NOT TARGET GMP::GMP)
  add_library(GMP::GMP INTERFACE IMPORTED)

  set_target_properties(GMP::GMP PROPERTIES
    INTERFACE_LINK_LIBRARIES "${GMP_LIBRARIES}"
    INTERFACE_INCLUDE_DIRECTORIES "${GMP_INCLUDE_DIRS}"
  )
endif()
