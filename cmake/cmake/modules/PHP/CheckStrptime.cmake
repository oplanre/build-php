#[=============================================================================[
Check whether the strptime() declaration fails.

Cache variables:

  HAVE_STRPTIME_DECL_FAILS
    Set to 1 if strptime() declaration fails.
]=============================================================================]#

include(CheckCSourceCompiles)
include(CMakePushCheckState)

message(CHECK_START "Checking whether strptime() declaration fails")

cmake_push_check_state(RESET)
  set(CMAKE_REQUIRED_DEFINITIONS -D_GNU_SOURCE)

  if(HAVE_STRPTIME)
    set(CMAKE_REQUIRED_DEFINITIONS "${CMAKE_REQUIRED_DEFINITIONS} -DHAVE_STRPTIME")
  endif()

  check_c_source_compiles("
    #include <time.h>

    int main(void) {
      #ifndef HAVE_STRPTIME
      # error no strptime() on this platform
      #else
      /* use invalid strptime() declaration to see if it fails to compile */
      int strptime(const char *s, const char *format, struct tm *tm);
      #endif

      return 0;
    }
  " HAVE_STRPTIME_DECL)
cmake_pop_check_state()

if(NOT HAVE_STRPTIME_DECL)
  set(
    HAVE_STRPTIME_DECL_FAILS 1
    CACHE INTERNAL "Whether strptime() declaration fails"
  )

  message(CHECK_PASS "yes")
else()
  message(CHECK_FAIL "no")
endif()
