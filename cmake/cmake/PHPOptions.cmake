option(DEBUG "Whether to include debugging symbols" OFF)

option(SHORT_TAGS "Whether to enable the short-form <? start tag by default" ON)

option(ZTS "Enable thread safety" OFF)

option(RTLD_NOW "Whether to dlopen extensions with RTLD_NOW instead of RTLD_LAZY" OFF)

option(IPV6 "Whether to enable IPv6 support" ON)

option(DTRACE "Whether to enable DTrace support" OFF)

option(VALGRIND "Whether to enable the valgring support" OFF)

# Zend options
option(GCC_GLOBAL_REGS "Whether to enable GCC global register variables" ON)

option(ZEND_SIGNALS "Whether to enable Zend signal handling" ON)

if(DEBUG)
  set(ZEND_DEBUG 1)
else()
  set(ZEND_DEBUG 0)
endif()

if(SHORT_TAGS)
  set(DEFAULT_SHORT_OPEN_TAG "1")
else()
  set(DEFAULT_SHORT_OPEN_TAG "0")
endif()

if(ZTS)
  set(ZTS 1 CACHE BOOL "Whether thread safety is enabled" FORCE)
endif()

if(RTLD_NOW)
  set(PHP_USE_RTLD_NOW 1 CACHE INTERNAL "Use dlopen with RTLD_NOW instead of RTLD_LAZY")
endif()
