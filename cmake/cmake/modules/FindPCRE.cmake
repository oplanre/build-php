#[=============================================================================[
Find the PCRE library.

Module defines the following IMPORTED targets:

  PCRE::PCRE
    The PCRE library, if found.

Result variables:

  PCRE_FOUND
    Set to 1 if PCRE library is found.
  PCRE_INCLUDE_DIRS
    A list of include directories for using PCRE library.
  PCRE_LIBRARIES
    A list of libraries for using PCRE library.
  PCRE_VERSION
    Version string of found PCRE library.
#]=============================================================================]

include(FeatureSummary)
include(FindPackageHandleStandardArgs)

set_package_properties(PCRE PROPERTIES
  URL "https://www.pcre.org/"
  DESCRIPTION "Perl compatible regular expressions library"
)

find_package(PkgConfig QUIET REQUIRED)

if(PKG_CONFIG_FOUND)
  if(PCRE_FIND_VERSION)
    set(_pkg_module_spec "libpcre2-8>=${PCRE_FIND_VERSION}")
  else()
    set(_pkg_module_spec "libpcre2-8")
  endif()

  pkg_search_module(PCRE QUIET "${_pkg_module_spec}")

  unset(_pkg_module_spec)
endif()

find_package_handle_standard_args(
  PCRE
  REQUIRED_VARS PCRE_LIBRARIES
  VERSION_VAR PCRE_VERSION
  REASON_FAILURE_MESSAGE "PCRE not found. Please install PCRE library (libpcre2)."
)

if(PCRE_FOUND AND NOT TARGET PCRE::PCRE)
  add_library(PCRE::PCRE INTERFACE IMPORTED)

  set_target_properties(PCRE::PCRE PROPERTIES
    INTERFACE_LINK_LIBRARIES "${PCRE_LIBRARIES}"
    INTERFACE_INCLUDE_DIRECTORIES "${PCRE_INCLUDE_DIRS}"
  )
endif()
