#[=============================================================================[
Project-wide configuration checks.
#]=============================================================================]

# Include required modules.
include(CheckIncludeFile)
include(CheckIncludeFiles)
include(CheckLibraryExists)
include(CheckStructHasMember)
include(CheckSymbolExists)
include(CheckTypeSize)
include(CMakePushCheckState)

# Check whether the system byte ordering is bigendian.
if(CMAKE_C_BYTE_ORDER STREQUAL "BIG_ENDIAN")
  set(WORDS_BIGENDIAN 1)
endif()

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
check_include_file(linux/filter.h HAVE_LINUX_FILTER_H)
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

if(HAVE_SYS_SOCKET_H)
  # Darwin, OpenBSD and similar systems require sys/socket.h to be included with
  # the net/if.h header.
  check_include_files("sys/socket.h;net/if.h" HAVE_NET_IF_H)
else()
  check_include_file(net/if.h HAVE_NET_IF_H)
endif()

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
check_include_file(unix.h HAVE_UNIX_H)
check_include_file(utime.h HAVE_UTIME_H)

# Intel Intrinsics headers.
check_include_file(tmmintrin.h HAVE_TMMINTRIN_H)
check_include_file(nmmintrin.h HAVE_NMMINTRIN_H)
check_include_file(wmmintrin.h HAVE_WMMINTRIN_H)
check_include_file(immintrin.h HAVE_IMMINTRIN_H)

check_struct_has_member("struct tm" tm_gmtoff time.h HAVE_STRUCT_TM_TM_GMTOFF)
check_struct_has_member("struct tm" tm_zone time.h HAVE_STRUCT_TM_TM_ZONE)
check_struct_has_member("struct stat" st_blksize sys/stat.h HAVE_STRUCT_STAT_ST_BLKSIZE)
check_struct_has_member("struct stat" st_blocks sys/stat.h HAVE_STRUCT_STAT_ST_BLOCKS)
check_struct_has_member("struct stat" st_rdev sys/stat.h HAVE_STRUCT_STAT_ST_RDEV)

# Check for missing declarations of reentrant functions.
include(PHP/CheckMissingTimeR)

# Check size of symbols - these are defined elsewhere than stdio.h.
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

# Check stdint types.
check_type_size("short" SIZEOF_SHORT)
if(NOT SIZEOF_SHORT)
  message(FATAL_ERROR "Cannot determine size of short.")
endif()

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

cmake_push_check_state(RESET)
  if(HAVE_SYS_SOCKET_H)
    set(CMAKE_EXTRA_INCLUDE_FILES sys/socket.h)
  endif()
  check_type_size("socklen_t" SIZEOF_SOCKLEN_T)
  if(HAVE_SIZEOF_SOCKLEN_T)
    set(HAVE_SOCKLEN_T 1 CACHE INTERNAL "Define to 1 if the system has the type `socklen_t'.")
  endif()
cmake_pop_check_state()

# Check fopencookie.
include(PHP/CheckFopencookie)

# Check for broken getcwd().
include(PHP/CheckBrokenGetCwd)

# Check for broken gcc optimize-strlen.
include(PHP/CheckBrokenGccStrlenOpt)

# Check for missing fclose declaration.
include(PHP/CheckMissingFcloseDeclaration)

# Check struct flock.
include(PHP/CheckStructFlock)

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

# Check AVX512.
include(PHP/CheckAVX512)

# Check AVX512 VBMI.
include(PHP/CheckAVX512VBMI)

# Check prctl.
include(PHP/CheckPrctl)

# Check procctl.
include(PHP/CheckProcctl)

# Check for __alignof__.
include(PHP/CheckAlignof)

# Checks for sockaddr_storage and sockaddr.sa_len.
include(PHP/CheckSockaddr)

# Check functions and symbols.
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

# Check for strerror_r, and if its a POSIX-compatible or a GNU specific version.
include(PHP/CheckStrerrorR)

# Check getaddrinfo().
include(PHP/CheckGetaddrinfo)

# Check copy_file_range().
include(PHP/CheckCopyFileRange)

# Check for asm goto.
include(PHP/CheckAsmGoto)

check_symbol_exists(strlcat "string.h" HAVE_STRLCAT)
check_symbol_exists(strlcpy "string.h" HAVE_STRLCPY)
check_symbol_exists(explicit_bzero "string.h" HAVE_EXPLICIT_BZERO)

# Check type of reentrant time-related functions.
include(PHP/CheckTimeR)

# Check whether writing to stdout works.
include(PHP/CheckWriteStdout)

# Check for required libraries.
check_symbol_exists(dlopen "dlfcn.h" HAVE_LIBDL)

# TODO: Use CMAKE_DL_LIBS.
if(NOT HAVE_LIBDL)
  check_library_exists(dl dlopen "" HAVE_LIBDL)

  if(HAVE_LIBDL)
    set(EXTRA_LIBS ${EXTRA_LIBS} dl)
  endif()

  if(NOT HAVE_LIBDL)
    check_library_exists(root dlopen "" HAVE_LIBDL)

    if(HAVE_LIBDL)
      set(EXTRA_LIBS ${EXTRA_LIBS} root)
    endif()
  endif()
endif()

# Check for required libraries.
check_library_exists(m sin "" HAVE_LIB_M)

if(HAVE_LIB_M)
  set(EXTRA_LIBS ${EXTRA_LIBS} m)
endif()

if(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "riscv64.*")
  find_package(ATOMIC)

  if(ATOMIC_FOUND AND ATOMIC_LIBRARIES)
    list(APPEND EXTRA_LIBS ${ATOMIC_LIBRARIES})
  endif()
endif()

# Check for IPv6 support.
if(PHP_IPV6)
  include(PHP/CheckIPv6)
endif()

# Check for aarch64 CRC32 API.
include(PHP/CheckAarch64CRC32)

# Check DTrace.
include(PHP/CheckDTrace)

# Check POSIX Threads flags.
if(PHP_ZTS)
  string(TOLOWER "${CMAKE_HOST_SYSTEM}" host_os)
  if(${host_os} MATCHES ".*solaris.*")
    set(EXTRA_DEFINITIONS ${EXTRA_DEFINITIONS} -D_POSIX_PTHREAD_SEMANTICS -D_REENTRANT)
  elseif(${host_os} MATCHES ".*freebsd.*")
    set(EXTRA_DEFINITIONS ${EXTRA_DEFINITIONS} -D_REENTRANT -D_THREAD_SAFE)
  elseif(${host_os} MATCHES ".*linux.*")
    set(EXTRA_DEFINITIONS ${EXTRA_DEFINITIONS} -D_REENTRANT)
  elseif(${host_os} MATCHES ".*aix.*")
    set(EXTRA_DEFINITIONS ${EXTRA_DEFINITIONS} -D_THREAD_SAFE)
  elseif(${host_os} MATCHES ".*irix.*")
    set(EXTRA_DEFINITIONS ${EXTRA_DEFINITIONS} -D_POSIX_THREAD_SAFE_FUNCTIONS)
  elseif(${host_os} MATCHES ".*hpux.*")
    set(EXTRA_DEFINITIONS ${EXTRA_DEFINITIONS} -D_REENTRANT)
  elseif(${host_os} MATCHES ".*sco.*")
    set(EXTRA_DEFINITIONS ${EXTRA_DEFINITIONS} -D_REENTRANT)
  endif()
endif()

# TODO: Check if further adjustment are needed here.
if(HAVE_ALLOCA_H)
  check_symbol_exists(alloca "alloca.h" HAVE_ALLOCA)
else()
  check_symbol_exists(alloca "stdlib.h;malloc.h" HAVE_ALLOCA)
endif()

check_symbol_exists(socket "sys/socket.h" HAVE_SOCKET)
if(NOT HAVE_SOCKET)
  set(LIBRARIES_TO_CHECK socket network)

  foreach(library ${LIBRARIES_TO_CHECK})
    check_library_exists(${library} socket "" HAVE_SOCKET)

    if(HAVE_SOCKET)
      list(APPEND EXTRA_LIBS ${library})
      break()
    endif()
  endforeach()
endif()

check_symbol_exists(socketpair "sys/socket.h" HAVE_SOCKETPAIR)
if(NOT HAVE_SOCKETPAIR)
  set(LIBRARIES_TO_CHECK socket network)

  foreach(library ${LIBRARIES_TO_CHECK})
    check_library_exists(${library} socket "" HAVE_SOCKETPAIR)

    if(HAVE_SOCKETPAIR)
      list(APPEND EXTRA_LIBS ${library})
      break()
    endif()
  endforeach()
endif()

check_symbol_exists(gethostname "unistd.h" HAVE_GETHOSTNAME)
if(NOT HAVE_GETHOSTNAME)
  set(LIBRARIES_TO_CHECK nsl network)

  foreach(library ${LIBRARIES_TO_CHECK})
    check_library_exists(${library} gethostname "" HAVE_GETHOSTNAME)

    if(HAVE_GETHOSTNAME)
      list(APPEND EXTRA_LIBS ${library})
      break()
    endif()
  endforeach()
endif()

# TODO: Fix this better.
check_symbol_exists(gethostbyaddr "netdb.h;sys/socket.h" HAVE_GETHOSTBYADDR)
if(NOT HAVE_GETHOSTBYADDR)
  set(LIBRARIES_TO_CHECK nsl network)

  foreach(library ${LIBRARIES_TO_CHECK})
    check_library_exists(${library} gethostbyaddr "" HAVE_GETHOSTBYADDR)

    if(HAVE_GETHOSTBYADDR)
      list(APPEND EXTRA_LIBS ${library})
      break()
    endif()
  endforeach()
endif()

check_symbol_exists(openpty "pty.h" HAVE_OPENPTY)
if(NOT HAVE_OPENPTY)
  set(LIBRARIES_TO_CHECK util bsd)

  foreach(library ${LIBRARIES_TO_CHECK})
    check_library_exists(${library} openpty "" HAVE_OPENPTY)

    if(HAVE_OPENPTY)
      list(APPEND EXTRA_LIBS ${library})
      break()
    endif()
  endforeach()
endif()

check_symbol_exists(inet_aton "sys/socket.h;netinet/in.h;arpa/inet.h" HAVE_INET_ATON)
if(NOT HAVE_INET_ATON)
  set(LIBRARIES_TO_CHECK resolv bind)

  foreach(library ${LIBRARIES_TO_CHECK})
    check_library_exists(${library} inet_aton "" HAVE_INET_ATON)

    if(HAVE_INET_ATON)
      list(APPEND EXTRA_LIBS ${library})
      break()
    endif()
  endforeach()
endif()

# Check target attribute.
string(TOLOWER "${CMAKE_HOST_SYSTEM}" host_os)
if(NOT ${host_os} MATCHES ".*android.*|.*uclibc.*|.*musl.*|.*freebsd.*|.*openbsd.*")
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
