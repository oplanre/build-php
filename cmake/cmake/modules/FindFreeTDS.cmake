#[=============================================================================[
Find the FreeTDS set of libraries.
https://www.freetds.org/

Module defines the following IMPORTED targets:

  FreeTDS::FreeTDS
    The FreeTDS library, if found.

Result variables:

  FreeTDS_FOUND
    Set to 1 if FreeTDS has been found.
  FreeTDS_INCLUDE_DIRS
    A list of include directories for using FreeTDS set of libraries.
  FreeTDS_LIBRARIES
    A list of libraries for linking when using FreeTDS library.

Hints:

  The FreeTDS_ROOT variable adds search path for finding the FreeTDS on custom
  locations.
#]=============================================================================]

include(CheckLibraryExists)
include(FindPackageHandleStandardArgs)

find_path(FreeTDS_INCLUDE_DIRS sybdb.h PATH_SUFFIXES freetds)

find_library(FreeTDS_LIBRARIES NAMES sybdb DOC "The FreeTDS library")

# If there is dnet_stub library.
find_library(_dnet_stub_library NAMES dnet_stub DOC "The dnet_stub library")

if(_dnet_stub_library)
  check_library_exists(${_dnet_stub_library} dnet_addr "" _have_dnet_addr)
endif()

if(_have_dnet_addr)
  list(APPEND FreeTDS_LIBRARIES ${_dnet_stub_library})
endif()

# Sanity check.
check_library_exists(${FreeTDS_LIBRARIES} dbsqlexec "" _have_dbsqlexec)

mark_as_advanced(FreeTDS_LIBRARIES FreeTDS_INCLUDE_DIRS)

find_package_handle_standard_args(
  FreeTDS
  REQUIRED_VARS FreeTDS_LIBRARIES FreeTDS_INCLUDE_DIRS _have_dbsqlexec
)

if(FreeTDS_FOUND AND NOT TARGET FreeTDS::FreeTDS)
  add_library(FreeTDS::FreeTDS INTERFACE IMPORTED)

  set_target_properties(FreeTDS::FreeTDS PROPERTIES
    INTERFACE_LINK_LIBRARIES "${FreeTDS_LIBRARIES}"
    INTERFACE_INCLUDE_DIRECTORIES "${FreeTDS_INCLUDE_DIRS}"
  )
endif()
