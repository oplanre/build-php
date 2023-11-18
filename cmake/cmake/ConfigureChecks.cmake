#[=============================================================================[
Project-wide configuration checks.
#]=============================================================================]

# Include required modules.
include(CheckCompilerFlag)
include(CheckIncludeFile)
include(CheckLibraryExists)
include(CheckStructHasMember)
include(CheckSymbolExists)
include(CheckTypeSize)
include(CMakePushCheckState)
include(PHP/SearchLibraries)

################################################################################
# Check headers.
################################################################################

check_include_file(alloca.h HAVE_ALLOCA_H)
check_include_file(arpa/inet.h HAVE_ARPA_INET_H)
check_include_file(arpa/nameser.h HAVE_ARPA_NAMESER_H)
check_include_file(dirent.h HAVE_DIRENT_H)
check_include_file(dlfcn.h HAVE_DLFCN_H)
check_include_file(dns.h HAVE_DNS_H)
check_include_file(fcntl.h HAVE_FCNTL_H)
check_include_file(grp.h HAVE_GRP_H)
check_include_file(ieeefp.h HAVE_IEEEFP_H)
check_include_file(langinfo.h HAVE_LANGINFO_H)
check_include_file(linux/sock_diag.h HAVE_LINUX_SOCK_DIAG_H)
check_include_file(malloc.h HAVE_MALLOC_H)
check_include_file(netinet/in.h HAVE_NETINET_IN_H)
check_include_file(os/signpost.h HAVE_OS_SIGNPOST_H)
check_include_file(poll.h HAVE_POLL_H)
check_include_file(pty.h HAVE_PTY_H)
check_include_file(pwd.h HAVE_PWD_H)
check_include_file(resolv.h HAVE_RESOLV_H)
check_include_file(strings.h HAVE_STRINGS_H)
check_include_file(sys/file.h HAVE_SYS_FILE_H)
check_include_file(sys/ioctl.h HAVE_SYS_IOCTL_H)
check_include_file(sys/ipc.h HAVE_SYS_IPC_H)
check_include_file(sys/loadavg.h HAVE_SYS_LOADAVG_H)
check_include_file(sys/mman.h HAVE_SYS_MMAN_H)
check_include_file(sys/mount.h HAVE_SYS_MOUNT_H)
check_include_file(sys/param.h HAVE_SYS_PARAM_H)
check_include_file(sys/poll.h HAVE_SYS_POLL_H)
check_include_file(sys/procctl.h HAVE_SYS_PROCCTL_H)
check_include_file(sys/resource.h HAVE_SYS_RESOURCE_H)
check_include_file(sys/select.h HAVE_SYS_SELECT_H)
check_include_file(sys/socket.h HAVE_SYS_SOCKET_H)
check_include_file(sys/stat.h HAVE_SYS_STAT_H)
check_include_file(sys/statfs.h HAVE_SYS_STATFS_H)
check_include_file(sys/statvfs.h HAVE_SYS_STATVFS_H)
check_include_file(sys/sysexits.h HAVE_SYS_SYSEXITS_H)
check_include_file(sys/time.h HAVE_SYS_TIME_H)
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
check_include_file(sys/uio.h HAVE_SYS_UIO_H)
check_include_file(sys/utsname.h HAVE_SYS_UTSNAME_H)
check_include_file(sys/vfs.h HAVE_SYS_VFS_H)
check_include_file(sys/wait.h HAVE_SYS_WAIT_H)
check_include_file(sysexits.h HAVE_SYSEXITS_H)
check_include_file(syslog.h HAVE_SYSLOG_H)
check_include_file(unistd.h HAVE_UNISTD_H)
# QNX requires unix.h to allow functions in libunix to work properly.
check_include_file(unix.h HAVE_UNIX_H)
check_include_file(utime.h HAVE_UTIME_H)

# Intel Intrinsics headers.
check_include_file(tmmintrin.h HAVE_TMMINTRIN_H)
check_include_file(nmmintrin.h HAVE_NMMINTRIN_H)
check_include_file(wmmintrin.h HAVE_WMMINTRIN_H)
check_include_file(immintrin.h HAVE_IMMINTRIN_H)

################################################################################
# Check structs.
################################################################################

check_struct_has_member("struct tm" tm_gmtoff time.h HAVE_STRUCT_TM_TM_GMTOFF)
check_struct_has_member("struct tm" tm_zone time.h HAVE_STRUCT_TM_TM_ZONE)
check_struct_has_member("struct stat" st_blksize sys/stat.h HAVE_STRUCT_STAT_ST_BLKSIZE)
check_struct_has_member("struct stat" st_blocks sys/stat.h HAVE_STRUCT_STAT_ST_BLOCKS)
check_struct_has_member("struct stat" st_rdev sys/stat.h HAVE_STRUCT_STAT_ST_RDEV)

# Check struct flock.
include(PHP/CheckStructFlock)

# Check for sockaddr_storage and sockaddr.sa_len.
include(PHP/CheckSockaddr)

################################################################################
# Check types.
################################################################################

# TODO: Should this be removed?
check_type_size("short" SIZEOF_SHORT)

check_type_size("int" SIZEOF_INT)
if(NOT SIZEOF_INT)
  message(FATAL_ERROR "Cannot determine size of int.")
endif()

check_type_size("long" SIZEOF_LONG)
if(NOT SIZEOF_LONG)
  message(FATAL_ERROR "Cannot determine size of long.")
endif()

check_type_size("long long" SIZEOF_LONG_LONG)
if(NOT SIZEOF_LONG_LONG)
  message(FATAL_ERROR "Cannot determine size of long long.")
endif()

check_type_size("size_t" SIZEOF_SIZE_T)
if(NOT HAVE_SIZEOF_SIZE_T)
  message(FATAL_ERROR "Cannot determine size of size_t.")
endif()

check_type_size("off_t" SIZEOF_OFF_T)
if(NOT SIZEOF_OFF_T)
  message(FATAL_ERROR "Cannot determine size of off_t.")
endif()

check_type_size("gid_t" SIZEOF_GID_T)
if(NOT HAVE_SIZEOF_GID_T)
  set(gid_t int CACHE INTERNAL "Define as 'int' if <sys/types.h> doesn't define.")
endif()

check_type_size("uid_t" SIZEOF_UID_T)
if(NOT HAVE_SIZEOF_UID_T)
  set(uid_t int CACHE INTERNAL "Define as 'int' if <sys/types.h> doesn't define.")
endif()

check_type_size("intmax_t" SIZEOF_INTMAX_T)
if(NOT SIZEOF_INTMAX_T)
  set(SIZEOF_INTMAX_T 0 CACHE INTERNAL "Size of intmax_t")
  message(WARNING "Couldn't determine size of intmax_t, setting to 0.")
endif()

check_type_size("ssize_t" SIZEOF_SSIZE_T)
if(NOT SIZEOF_SSIZE_T)
  set(SIZEOF_SSIZE_T 8 CACHE INTERNAL "Size of ssize_t")
  message(WARNING "Couldn't determine size of ssize_t, setting to 8.")
endif()

check_type_size("ptrdiff_t" SIZEOF_PTRDIFF_T)
set(HAVE_PTRDIFF_T 1 CACHE INTERNAL "Whether ptrdiff_t is available")
if(NOT SIZEOF_PTRDIFF_T)
  set(SIZEOF_PTRDIFF_T 8 CACHE INTERNAL "Size of ptrdiff_t")
  message(WARNING "Couldn't determine size of ptrdiff_t, setting to 8.")
endif()

# Check for socklen_t type.
cmake_push_check_state(RESET)
  if(HAVE_SYS_SOCKET_H)
    list(APPEND CMAKE_EXTRA_INCLUDE_FILES sys/socket.h)
  endif()
  check_type_size("socklen_t" SIZEOF_SOCKLEN_T)
  if(HAVE_SIZEOF_SOCKLEN_T)
    set(HAVE_SOCKLEN_T 1 CACHE INTERNAL "Whether the system has the type 'socklen_t'.")
  endif()
cmake_pop_check_state()

################################################################################
# Check builtins.
################################################################################

# Import builtins checker function.
include(PHP/CheckBuiltin)

php_check_builtin(__builtin_clz PHP_HAVE_BUILTIN_CLZ)
php_check_builtin(__builtin_clzl PHP_HAVE_BUILTIN_CLZL)
php_check_builtin(__builtin_clzll PHP_HAVE_BUILTIN_CLZLL)
php_check_builtin(__builtin_cpu_init PHP_HAVE_BUILTIN_CPU_INIT)
php_check_builtin(__builtin_cpu_supports PHP_HAVE_BUILTIN_CPU_SUPPORTS)
php_check_builtin(__builtin_ctzl PHP_HAVE_BUILTIN_CTZL)
php_check_builtin(__builtin_ctzll PHP_HAVE_BUILTIN_CTZLL)
php_check_builtin(__builtin_expect PHP_HAVE_BUILTIN_EXPECT)
php_check_builtin(__builtin_frame_address PHP_HAVE_BUILTIN_FRAME_ADDRESS)
php_check_builtin(__builtin_saddl_overflow PHP_HAVE_BUILTIN_SADDL_OVERFLOW)
php_check_builtin(__builtin_saddll_overflow PHP_HAVE_BUILTIN_SADDLL_OVERFLOW)
php_check_builtin(__builtin_smull_overflow PHP_HAVE_BUILTIN_SMULL_OVERFLOW)
php_check_builtin(__builtin_smulll_overflow PHP_HAVE_BUILTIN_SMULLL_OVERFLOW)
php_check_builtin(__builtin_ssubl_overflow PHP_HAVE_BUILTIN_SSUBL_OVERFLOW)
php_check_builtin(__builtin_ssubll_overflow PHP_HAVE_BUILTIN_SSUBLL_OVERFLOW)
php_check_builtin(__builtin_unreachable PHP_HAVE_BUILTIN_UNREACHABLE)
php_check_builtin(__builtin_usub_overflow PHP_HAVE_BUILTIN_USUB_OVERFLOW)

################################################################################
# Check compiler characteristics.
################################################################################

# Check compiler inline keyword.
include(PHP/CheckInline)

# Check AVX-512.
include(PHP/CheckAVX512)

# Check AVX-512 VBMI.
include(PHP/CheckAVX512VBMI)

# Check for asm goto.
include(PHP/CheckAsmGoto)

################################################################################
# Check functions.
################################################################################

check_symbol_exists(alphasort "dirent.h" HAVE_ALPHASORT)
check_symbol_exists(asctime_r "time.h" HAVE_ASCTIME_R)
check_symbol_exists(chroot "unistd.h" HAVE_CHROOT)
check_symbol_exists(ctime_r "time.h" HAVE_CTIME_R)
check_symbol_exists(explicit_memset "string.h" HAVE_EXPLICIT_MEMSET)
check_symbol_exists(fdatasync "unistd.h" HAVE_FDATASYNC)

set(FLOCK_HEADERS "")

if(HAVE_FCNTL_H)
  list(APPEND FLOCK_HEADERS "fcntl.h")
endif()

if(HAVE_SYS_FILE_H)
  list(APPEND FLOCK_HEADERS "sys/file.h")
endif()

check_symbol_exists(flock "${FLOCK_HEADERS}" HAVE_FLOCK)

check_symbol_exists(ftok "sys/ipc.h" HAVE_FTOK)
check_symbol_exists(funopen "stdio.h" HAVE_FUNOPEN)
check_symbol_exists(gai_strerror "netdb.h" HAVE_GAI_STRERROR)
check_symbol_exists(getcwd "unistd.h" HAVE_GETCWD)
check_symbol_exists(getloadavg "stdlib.h" HAVE_GETLOADAVG)
check_symbol_exists(getlogin "unistd.h" HAVE_GETLOGIN)
check_symbol_exists(getprotobyname "netdb.h" HAVE_GETPROTOBYNAME)
check_symbol_exists(getprotobynumber "netdb.h" HAVE_GETPROTOBYNUMBER)
check_symbol_exists(getservbyname "netdb.h" HAVE_GETSERVBYNAME)
check_symbol_exists(getservbyport "netdb.h" HAVE_GETSERVBYPORT)
check_symbol_exists(getrusage "sys/resource.h" HAVE_GETRUSAGE)
check_symbol_exists(gettimeofday "sys/time.h" HAVE_GETTIMEOFDAY)
check_symbol_exists(gmtime_r "time.h" HAVE_GMTIME_R)
check_symbol_exists(getpwnam_r "pwd.h" HAVE_GETPWNAM_R)
check_symbol_exists(getgrnam_r "grp.h" HAVE_GETGRNAM_R)
check_symbol_exists(getpwuid_r "pwd.h" HAVE_GETPWUID_R)
check_symbol_exists(getwd "unistd.h" HAVE_GETWD)
check_symbol_exists(glob "glob.h" HAVE_GLOB)
check_symbol_exists(inet_ntoa "arpa/inet.h" HAVE_INET_NTOA)
check_symbol_exists(inet_ntop "arpa/inet.h" HAVE_INET_NTOP)
check_symbol_exists(inet_pton "arpa/inet.h" HAVE_INET_PTON)
check_symbol_exists(localtime_r "time.h" HAVE_LOCALTIME_R)
check_symbol_exists(lchown "unistd.h" HAVE_LCHOWN)
check_symbol_exists(memcntl "sys/mman.h" HAVE_MEMCNTL)
check_symbol_exists(memmove "string.h" HAVE_MEMMOVE)
check_symbol_exists(mkstemp "stdlib.h" HAVE_MKSTEMP)
check_symbol_exists(mmap "sys/mman.h" HAVE_MMAP)
check_symbol_exists(nice "unistd.h" HAVE_NICE)
check_symbol_exists(nl_langinfo "langinfo.h" HAVE_NL_LANGINFO)
check_symbol_exists(prctl "sys/prctl.h" HAVE_PRCTL)
check_symbol_exists(procctl "sys/procctl.h" HAVE_PROCCTL)
check_symbol_exists(poll "poll.h" HAVE_POLL)
check_symbol_exists(pthread_jit_write_protect_np "pthread.h" HAVE_PTHREAD_JIT_WRITE_PROTECT_NP)
check_symbol_exists(putenv "stdlib.h" HAVE_PUTENV)
check_symbol_exists(scandir "dirent.h" HAVE_SCANDIR)
check_symbol_exists(setitimer "sys/time.h" HAVE_SETITIMER)
check_symbol_exists(setenv "stdlib.h" HAVE_SETENV)
check_symbol_exists(shutdown "sys/socket.h" HAVE_SHUTDOWN)
check_symbol_exists(sigprocmask "signal.h" HAVE_SIGPROCMASK)
check_symbol_exists(statfs "sys/statfs.h" HAVE_STATFS)
check_symbol_exists(statvfs "sys/statvfs.h" HAVE_STATVFS)
check_symbol_exists(std_syslog "sys/syslog.h" HAVE_STD_SYSLOG)
check_symbol_exists(strcasecmp "strings.h" HAVE_STRCASECMP)
check_symbol_exists(strnlen "string.h" HAVE_STRNLEN)

cmake_push_check_state(RESET)
  set(CMAKE_REQUIRED_DEFINITIONS -D_XOPEN_SOURCE)
  check_symbol_exists(strptime "time.h" HAVE_STRPTIME)
cmake_pop_check_state()

check_symbol_exists(strtok_r "string.h" HAVE_STRTOK_R)
check_symbol_exists(symlink "unistd.h" HAVE_SYMLINK)
check_symbol_exists(tzset "time.h" HAVE_TZSET)
check_symbol_exists(unsetenv "stdlib.h" HAVE_UNSETENV)
check_symbol_exists(usleep "unistd.h" HAVE_USLEEP)
check_symbol_exists(utime "utime.h" HAVE_UTIME)

cmake_push_check_state(RESET)
  set(CMAKE_REQUIRED_DEFINITIONS -D_GNU_SOURCE)
  check_symbol_exists(vasprintf "stdio.h" HAVE_VASPRINTF)
cmake_pop_check_state()

cmake_push_check_state(RESET)
  set(CMAKE_REQUIRED_DEFINITIONS -D_GNU_SOURCE)
  check_symbol_exists(asprintf "stdio.h" HAVE_ASPRINTF)
cmake_pop_check_state()

check_symbol_exists(nanosleep "time.h" HAVE_NANOSLEEP)

cmake_push_check_state(RESET)
  set(CMAKE_REQUIRED_DEFINITIONS -D_GNU_SOURCE)
  check_symbol_exists(memmem "string.h" HAVE_MEMMEM)
cmake_pop_check_state()

cmake_push_check_state(RESET)
  set(CMAKE_REQUIRED_DEFINITIONS -D_GNU_SOURCE)
  check_symbol_exists(memrchr "string.h" HAVE_MEMRCHR)
cmake_pop_check_state()

check_symbol_exists(strlcat "string.h" HAVE_STRLCAT)
check_symbol_exists(strlcpy "string.h" HAVE_STRLCPY)
check_symbol_exists(explicit_bzero "string.h" HAVE_EXPLICIT_BZERO)
# TODO: Remove getopt redundant check or adjust PHP C code to use system getopt.
check_symbol_exists(getopt "unistd.h" HAVE_GETOPT)

# Check for missing declarations of reentrant functions.
include(PHP/CheckMissingTimeR)

# Check fopencookie.
include(PHP/CheckFopencookie)

# Some systems, notably Solaris, cause getcwd() or realpath to fail if a
# component of the path has execute but not read permissions.
message(CHECK_START "Checking for broken getcwd()")
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "SunOS")
  set(HAVE_BROKEN_GETCWD 1 CACHE INTERNAL "Define if system has broken getcwd")
  message(CHECK_PASS "yes")
else()
  message(CHECK_FAIL "no")
endif()

# Check for broken GCC optimize-strlen.
include(PHP/CheckBrokenGccStrlenOpt)
if(HAVE_BROKEN_OPTIMIZE_STRLEN)
  check_compiler_flag(C -fno-optimize-strlen HAVE_FNO_OPTIMIZE_STRLEN_C)
  if(HAVE_FNO_OPTIMIZE_STRLEN_C)
    target_compile_options(php_configuration
      INTERFACE $<$<COMPILE_LANGUAGE:ASM,C>:-fno-optimize-strlen>
    )
  endif()
endif()

# Check for missing fclose declaration.
include(PHP/CheckFclose)

# Check for strerror_r, and if its a POSIX-compatible or a GNU specific version.
include(PHP/CheckStrerrorR)

# Check getaddrinfo().
include(PHP/CheckGetaddrinfo)

# Check copy_file_range().
include(PHP/CheckCopyFileRange)

# Check type of reentrant time-related functions.
include(PHP/CheckTimeR)

# Check whether writing to stdout works.
include(PHP/CheckWrite)

################################################################################
# Miscellaneous checks.
################################################################################

# Checking file descriptor sets.
message(CHECK_START "Checking file descriptor sets size")
if(PHP_FD_SETSIZE GREATER 0)
  message(CHECK_PASS "using FD_SETSIZE=${PHP_FD_SETSIZE}")
  target_compile_definitions(
    php_configuration
    INTERFACE $<$<COMPILE_LANGUAGE:ASM,C,CXX>:FD_SETSIZE=${PHP_FD_SETSIZE}>
  )
elseif(NOT PHP_FD_SETSIZE STREQUAL "" AND NOT PHP_FD_SETSIZE GREATER 0)
  message(FATAL_ERROR "Invalid value PHP_FD_SETSIZE=${PHP_FD_SETSIZE}")
else()
  message(CHECK_PASS "using system default")
endif()

# Check target system byte order.
include(PHP/CheckByteOrder)

# Check for IPv6 support.
if(PHP_IPV6)
  include(PHP/CheckIPv6)
endif()

# Check for aarch64 CRC32 API.
include(PHP/CheckAarch64CRC32)

# Check POSIX Threads flags.
if(PHP_THREAD_SAFETY)
  string(TOLOWER "${CMAKE_HOST_SYSTEM}" host_os)
  if(${host_os} MATCHES ".*solaris.*")
    target_compile_definitions(
      php_configuration
      INTERFACE "$<$<COMPILE_LANGUAGE:ASM,C,CXX>:_POSIX_PTHREAD_SEMANTICS;_REENTRANT>"
    )
  elseif(${host_os} MATCHES ".*freebsd.*")
    target_compile_definitions(
      php_configuration
      INTERFACE "$<$<COMPILE_LANGUAGE:ASM,C,CXX>:_REENTRANT;_THREAD_SAFE>"
    )
  elseif(${host_os} MATCHES ".*linux.*")
    target_compile_definitions(
      php_configuration
      INTERFACE "$<$<COMPILE_LANGUAGE:ASM,C,CXX>:_REENTRANT>"
    )
  elseif(${host_os} MATCHES ".*aix.*")
    target_compile_definitions(
      php_configuration
      INTERFACE "$<$<COMPILE_LANGUAGE:ASM,C,CXX>:_THREAD_SAFE>"
    )
  elseif(${host_os} MATCHES ".*irix.*")
    target_compile_definitions(
      php_configuration
      INTERFACE "$<$<COMPILE_LANGUAGE:ASM,C,CXX>:_POSIX_THREAD_SAFE_FUNCTIONS>"
    )
  elseif(${host_os} MATCHES ".*hpux.*")
    target_compile_definitions(
      php_configuration
      INTERFACE "$<$<COMPILE_LANGUAGE:ASM,C,CXX>:_REENTRANT>"
    )
  elseif(${host_os} MATCHES ".*sco.*")
    target_compile_definitions(
      php_configuration
      INTERFACE "$<$<COMPILE_LANGUAGE:ASM,C,CXX>:_REENTRANT>"
    )
  endif()
endif()

# TODO: Check if further adjustment are needed here.
if(HAVE_ALLOCA_H)
  check_symbol_exists(alloca "alloca.h" HAVE_ALLOCA)
else()
  check_symbol_exists(alloca "stdlib.h;malloc.h" HAVE_ALLOCA)
endif()

# Check for __alignof__ support in the compiler.
message(CHECK_START "Checking whether the compiler supports __alignof__")
check_c_source_compiles("
  int main(void) {
    int align = __alignof__(int);
    return 0;
  }
" HAVE_ALIGNOF)
if(HAVE_ALIGNOF)
  message(CHECK_PASS "yes")
else()
  message(CHECK_FAIL "no")
endif()

# Check for GCC function attributes on all systems except ones without glibc.
# Fix for these systems is already included in GCC 7, but not on GCC 6. At least
# some versions of FreeBSD seem to have buggy ifunc support, see bug #77284.
# Conservatively don't use ifuncs on FreeBSD.
if(NOT CMAKE_HOST_SYSTEM_NAME MATCHES "Android|FreeBSD|OpenBSD"
  AND NOT PHP_STD_LIBRARY MATCHES "^(musl|uclibc)$"
)
  check_c_source_compiles("
    static int bar( void ) __attribute__((target(\"sse2\")));

    int main(void) {
      return 0;
    }
  " HAVE_FUNC_ATTRIBUTE_TARGET)

  check_c_source_compiles("
    int my_foo( void ) { return 0; }
    static int (*resolve_foo(void))(void) { return my_foo; }
    int foo( void ) __attribute__((ifunc(\"resolve_foo\")));

    int main(void) {
      return 0;
    }
  " HAVE_FUNC_ATTRIBUTE_IFUNC)
endif()

include(PHP/CheckGethostbynameR)

# wchar.h is always available as part of C99 standard. The libmagic still
# includes it conditionally.
set(HAVE_WCHAR_H 1 CACHE INTERNAL "Define to 1 if you have the <wchar.h> header file.")

# string.h is always available as part of C89 standard. The opcache/jit/libudis86
# bundled forked code still includes it conditionally.
set(HAVE_STRING_H 1 CACHE INTERNAL "Define to 1 if you have the <string.h> header file.")

# inttypes.h is always available as part of C99 standard. The libmagic still
# includes it conditionally.
set(HAVE_INTTYPES_H 1 CACHE INTERNAL "Define to 1 if you have the <inttypes.h> header file.")

# stdint.h is always available as part of C99 standard. The libmagic,
# ext/date/lib still include it conditionally.
set(HAVE_STDINT_H 1 CACHE INTERNAL "Define to 1 if you have the <stdint.h> header file.")

################################################################################
# Check for required libraries.
################################################################################

check_symbol_exists(dlopen "dlfcn.h" HAVE_LIBDL)

# TODO: Use CMAKE_DL_LIBS.
if(NOT HAVE_LIBDL)
  check_library_exists(dl dlopen "" HAVE_LIBDL)

  if(HAVE_LIBDL)
    target_link_libraries(php_configuration INTERFACE dl)
  endif()

  if(NOT HAVE_LIBDL)
    check_library_exists(root dlopen "" HAVE_LIBDL)

    if(HAVE_LIBDL)
      target_link_libraries(php_configuration INTERFACE root)
    endif()
  endif()
endif()

php_search_libraries(sin "math.h" HAVE_SIN M_LIBRARY LIBRARIES m)

if(M_LIBRARY)
  target_link_libraries(php_configuration INTERFACE ${M_LIBRARY})
endif()

if(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "riscv64.*")
  find_package(Atomic)

  if(Atomic_FOUND AND Atomic_LIBRARIES)
    target_link_libraries(php_configuration INTERFACE ${Atomic_LIBRARIES})
  endif()
endif()

php_search_libraries(
  socket
  "sys/socket.h"
  HAVE_SOCKET
  SOCKET_LIBRARY
  LIBRARIES socket network
)

if(SOCKET_LIBRARY)
  target_link_libraries(php_configuration INTERFACE ${SOCKET_LIBRARY})
endif()

php_search_libraries(
  socketpair
  "sys/socket.h"
  HAVE_SOCKETPAIR
  SOCKETPAIR_LIBRARY
  LIBRARIES socket network
)

if(SOCKETPAIR_LIBRARY)
  target_link_libraries(php_configuration INTERFACE ${SOCKETPAIR_LIBRARY})
endif()

php_search_libraries(
  gethostname
  "unistd.h"
  HAVE_GETHOSTNAME
  GETHOSTNAME_LIBRARY
  LIBRARIES nsl network
)

if(GETHOSTNAME_LIBRARY)
  target_link_libraries(php_configuration INTERFACE ${GETHOSTNAME_LIBRARY})
endif()

php_search_libraries(
  gethostbyaddr
  "netdb.h;sys/socket.h"
  HAVE_GETHOSTBYADDR
  GETHOSTBYADDR_LIBRARY
  LIBRARIES nsl network
)

if(GETHOSTBYADDR_LIBRARY)
  target_link_libraries(php_configuration INTERFACE ${GETHOSTBYADDR_LIBRARY})
endif()

php_search_libraries(
  openpty
  pty.h
  HAVE_OPENPTY
  OPENPTY_LIBRARY
  LIBRARIES util bsd
)

if(OPENPTY_LIBRARY)
  target_link_libraries(php_configuration INTERFACE ${OPENPTY_LIBRARY})
endif()

php_search_libraries(
  inet_aton
  "sys/socket.h;netinet/in.h;arpa/inet.h"
  HAVE_INET_ATON
  INET_ATON_LIBRARY
  LIBRARIES resolv bind
)

if(INET_ATON_LIBRARY)
  target_link_libraries(php_configuration INTERFACE ${INET_ATON_LIBRARY})
endif()

################################################################################
# Build type.
################################################################################

# TODO: Fix this better.
if(CMAKE_BUILD_TYPE STREQUAL "Debug" OR "Debug" IN_LIST CMAKE_CONFIGURATION_TYPES)
  set(PHP_DEBUG TRUE)
endif()

################################################################################
# Compiler options.
################################################################################

target_compile_options(php_configuration
  BEFORE INTERFACE
    "$<$<COMPILE_LANG_AND_ID:ASM,GNU>:-Wall;-Wextra;-Wno-unused-parameter;-Wno-sign-compare>"
    "$<$<COMPILE_LANG_AND_ID:C,GNU>:-Wall;-Wextra;-Wno-unused-parameter;-Wno-sign-compare>"
    "$<$<COMPILE_LANG_AND_ID:CXX,GNU>:-Wall;-Wextra;-Wno-unused-parameter;-Wno-sign-compare>"
)

# Check if compiler supports -Wno-clobbered (only GCC).
check_compiler_flag(C -Wno-clobbered HAVE_WNO_CLOBBERED_C)
if(HAVE_WNO_CLOBBERED_C)
  target_compile_options(php_configuration
    BEFORE INTERFACE "$<$<COMPILE_LANGUAGE:C>:-Wno-clobbered>"
  )
endif()
check_compiler_flag(CXX -Wno-clobbered HAVE_WNO_CLOBBERED_CXX)
if(HAVE_WNO_CLOBBERED_CXX)
  target_compile_options(php_configuration
    BEFORE INTERFACE "$<$<COMPILE_LANGUAGE:CXX>:-Wno-clobbered>"
  )
endif()

# Check for support for implicit fallthrough level 1, also add after previous
# CFLAGS as level 3 is enabled in -Wextra.
check_compiler_flag(C -Wimplicit-fallthrough=1 HAVE_WIMPLICIT_FALLTHROUGH_C)
if(HAVE_WIMPLICIT_FALLTHROUGH_C)
  target_compile_options(php_configuration
    INTERFACE
      "$<$<COMPILE_LANGUAGE:C>:-Wimplicit-fallthrough=1>"
  )
endif()
check_compiler_flag(CXX -Wimplicit-fallthrough=1 HAVE_WIMPLICIT_FALLTHROUGH_CXX)
if(HAVE_WIMPLICIT_FALLTHROUGH_CXX)
  target_compile_options(php_configuration
    INTERFACE
      "$<$<COMPILE_LANGUAGE:CXX>:-Wimplicit-fallthrough=1>"
  )
endif()

check_compiler_flag(C -Wduplicated-cond HAVE_WDUPLICATED_COND_C)
if(HAVE_WDUPLICATED_COND_C)
  target_compile_options(php_configuration
    BEFORE INTERFACE "$<$<COMPILE_LANGUAGE:C>:-Wduplicated-cond>"
  )
endif()
check_compiler_flag(CXX -Wduplicated-cond HAVE_WDUPLICATED_COND_CXX)
if(HAVE_WDUPLICATED_COND_CXX)
  target_compile_options(php_configuration
    BEFORE INTERFACE "$<$<COMPILE_LANGUAGE:CXX>:-Wduplicated-cond>"
  )
endif()

check_compiler_flag(C -Wlogical-op HAVE_WLOGICAL_OP_C)
if(HAVE_WLOGICAL_OP_C)
  target_compile_options(php_configuration
    BEFORE INTERFACE "$<$<COMPILE_LANGUAGE:C>:-Wlogical-op>"
  )
endif()
check_compiler_flag(CXX -Wlogical-op HAVE_WLOGICAL_OP_CXX)
if(HAVE_WLOGICAL_OP_CXX)
  target_compile_options(php_configuration
    BEFORE INTERFACE "$<$<COMPILE_LANGUAGE:CXX>:-Wlogical-op>"
  )
endif()

check_compiler_flag(C -Wformat-truncation HAVE_WFORMAT_TRUNCATION_C)
if(HAVE_WFORMAT_TRUNCATION_C)
  target_compile_options(php_configuration
    BEFORE INTERFACE "$<$<COMPILE_LANGUAGE:C>:-Wformat-truncation>"
  )
endif()
check_compiler_flag(CXX -Wformat-truncation HAVE_WFORMAT_TRUNCATION_CXX)
if(HAVE_WFORMAT_TRUNCATION_CXX)
  target_compile_options(php_configuration
    BEFORE INTERFACE "$<$<COMPILE_LANGUAGE:CXX>:-Wformat-truncation>"
  )
endif()

check_compiler_flag(C -Wstrict-prototypes HAVE_WSTRICT_PROTOTYPES_C)
if(HAVE_WSTRICT_PROTOTYPES_C)
  target_compile_options(php_configuration
    BEFORE INTERFACE "$<$<COMPILE_LANGUAGE:C>:-Wstrict-prototypes>"
  )
endif()
check_compiler_flag(CXX -Wstrict-prototypes HAVE_WSTRICT_PROTOTYPES_CXX)
if(HAVE_WSTRICT_PROTOTYPES_CXX)
  target_compile_options(php_configuration
    BEFORE INTERFACE "$<$<COMPILE_LANGUAGE:CXX>:-Wstrict-prototypes>"
  )
endif()

check_compiler_flag(C -fno-common HAVE_FNO_COMMON_C)
if(HAVE_FNO_COMMON_C)
  target_compile_options(php_configuration
    BEFORE INTERFACE "$<$<COMPILE_LANGUAGE:C>:-fno-common>"
  )
endif()
check_compiler_flag(CXX -fno-common HAVE_FNO_COMMON_CXX)
if(HAVE_FNO_COMMON_C_XX)
  target_compile_options(php_configuration
    BEFORE INTERFACE "$<$<COMPILE_LANGUAGE:CXX>:-fno-common>"
  )
endif()

# Enable -Werror.
if(PHP_WERROR)
  message(
    STATUS
    "Enabling compiler options: Warnings treated as errors (-Werror)"
  )

  set(CMAKE_COMPILE_WARNING_AS_ERROR TRUE)
endif()

if(PHP_MEMORY_SANITIZER AND PHP_ADDRESS_SANITIZER)
  message(
    FATAL_ERROR
    "MemorySanitizer and AddressSanitizer are mutually exclusive"
  )
endif()

# Enable memory sanitizer compiler options.
if(PHP_MEMORY_SANITIZER)
  message(STATUS
    "Enabling compiler options:"
    " -fsanitize=memory"
    " -fsanitize-memory-track-origins"
  )

  cmake_push_check_state(RESET)
    set(CMAKE_REQUIRED_LINK_OPTIONS -fsanitize=memory -fsanitize-memory-track-origins)

    check_compiler_flag(
      C
      "-fsanitize=memory;-fsanitize-memory-track-origins"
      HAVE_MEMORY_SANITIZER_C
    )
    check_compiler_flag(
      CXX
      "-fsanitize=memory;-fsanitize-memory-track-origins"
      HAVE_MEMORY_SANITIZER_CXX
    )
  cmake_pop_check_state()

  if(HAVE_MEMORY_SANITIZER_C AND HAVE_MEMORY_SANITIZER_CXX)
    target_compile_options(php_configuration
      INTERFACE "$<$<COMPILE_LANGUAGE:C,CXX>:-fsanitize=memory;-fsanitize-memory-track-origins>"
    )
    target_link_options(php_configuration
      INTERFACE "$<$<COMPILE_LANGUAGE:C,CXX>:-fsanitize=memory;-fsanitize-memory-track-origins>"
    )
  else()
    message(FATAL_ERROR "MemorySanitizer is not available")
  endif()
endif()

# Enable address sanitizer compiler option.
if(PHP_ADDRESS_SANITIZER)
  message(STATUS "Enabling compiler options: -fsanitize=address")

  cmake_push_check_state(RESET)
    set(CMAKE_REQUIRED_LINK_OPTIONS "-fsanitize=address")

    check_compiler_flag(C "-fsanitize=address" HAVE_ADDRESS_SANITIZER_C)
    check_compiler_flag(CXX "-fsanitize=address" HAVE_ADDRESS_SANITIZER_CXX)
  cmake_pop_check_state()

  if(HAVE_ADDRESS_SANITIZER_C AND HAVE_ADDRESS_SANITIZER_CXX)
    target_compile_options(php_configuration
      INTERFACE "$<$<COMPILE_LANGUAGE:C,CXX>:-fsanitize=address>"
    )

    target_link_options(php_configuration
      INTERFACE "$<$<COMPILE_LANGUAGE:C,CXX>:-fsanitize=address>"
    )

    target_compile_definitions(php_configuration
      INTERFACE $<$<COMPILE_LANGUAGE:ASM,C,CXX>:ZEND_TRACK_ARENA_ALLOC>
    )
  else()
    message(FATAL_ERROR "AddressSanitizer is not available")
  endif()
endif()

# Enable the -fsanitize=undefined compiler option.
if(PHP_UNDEFINED_SANITIZER)
  message(STATUS "Enabling compiler options: -fsanitize=undefined")

  cmake_push_check_state(RESET)
    set(CMAKE_REQUIRED_LINK_OPTIONS "-fsanitize=undefined")

    check_compiler_flag(C "-fsanitize=undefined" HAVE_UNDEFINED_SANITIZER_C)
    check_compiler_flag(CXX "-fsanitize=undefined" HAVE_UNDEFINED_SANITIZER_CXX)
  cmake_pop_check_state()

  if(HAVE_UNDEFINED_SANITIZER_C AND HAVE_UNDEFINED_SANITIZER_CXX)
    target_compile_options(php_configuration
      INTERFACE "$<$<COMPILE_LANGUAGE:C,CXX>:-fsanitize=undefined;-fno-sanitize-recover=undefined>"
    )

    target_link_options(php_configuration
      INTERFACE "$<$<COMPILE_LANGUAGE:C,CXX>:-fsanitize=undefined;-fno-sanitize-recover=undefined>"
    )

    # Disable object-size sanitizer, because it is incompatible with the
    # zend_function union, and this can't be easily fixed.
    cmake_push_check_state(RESET)
      set(CMAKE_REQUIRED_LINK_OPTIONS "-fno-sanitize=object-size")

      check_compiler_flag(C "-fno-sanitize=object-size" HAVE_OBJECT_SIZE_SANITIZER_C)
      check_compiler_flag(CXX "-fno-sanitize=object-size" HAVE_OBJECT_SIZE_SANITIZER_CXX)
    cmake_pop_check_state()

    if(HAVE_OBJECT_SIZE_SANITIZER_C AND HAVE_OBJECT_SIZE_SANITIZER_CXX)
      target_compile_options(php_configuration
        INTERFACE "$<$<COMPILE_LANGUAGE:C,CXX>:-fno-sanitize=object-size>"
      )

      target_link_options(php_configuration
        INTERFACE "$<$<COMPILE_LANGUAGE:C,CXX>:-fno-sanitize=object-size>"
      )
    endif()
  else()
    message(FATAL_ERROR "AddressSanitizer is not available")
  endif()
endif()

if(PHP_MEMORY_SANITIZER OR PHP_ADDRESS_SANITIZER OR PHP_UNDEFINED_SANITIZER)
  target_compile_options(php_configuration
    INTERFACE "$<$<COMPILE_LANGUAGE:C,CXX>:-fno-omit-frame-pointer>"
  )
endif()
