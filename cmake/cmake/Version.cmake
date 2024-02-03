#[=============================================================================[
Read the PHP version from the configure.ac file and set PHP version variables.
]=============================================================================]#

include_guard(GLOBAL)

# Set the PHP_VERSION_* variables from configure.ac.
file(READ ${CMAKE_CURRENT_LIST_DIR}/../configure.ac _)
string(REGEX MATCH "AC_INIT\\(\\[PHP\\],\\[([0-9]+\.[0-9]+\.[0-9]+)([^\]]*)" _ "${_}")

set(PHP_VERSION "${CMAKE_MATCH_1}")

set(
  PHP_VERSION_LABEL "${CMAKE_MATCH_2}"
  CACHE STRING "Extra PHP version label suffix, e.g. '-dev', 'rc1', '-acme'"
)

# This is automatically executed with the project(PHP...) invocation.
macro(_php_post_project)
  if(NOT DEFINED PHP_VERSION_ID)
    # Append extra version label suffix to PHP_VERSION.
    string(APPEND PHP_VERSION "${PHP_VERSION_LABEL}")
    message(STATUS "PHP version: ${PHP_VERSION}")

    # Set PHP version ID.
    math(
      EXPR
      PHP_VERSION_ID
      "${PHP_VERSION_MAJOR} * 10000 \
      + ${PHP_VERSION_MINOR} * 100 \
      + ${PHP_VERSION_PATCH}"
    )
    message(STATUS "PHP version ID: ${PHP_VERSION_ID}")

    # Read PHP API version.
    file(READ main/php.h _)
    string(REGEX MATCH "#[ \t]*define[ \t]+PHP_API_VERSION[ \t]+([0-9]+)" _ "${_}")
    message(STATUS "PHP API version: ${CMAKE_MATCH_1}")
  endif()
endmacro()
variable_watch(PHP_HOMEPAGE_URL _php_post_project)
