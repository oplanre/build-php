# PHP build system

This repository delves into the heart of the PHP build system and explores how
to build PHP with CMake.

![ElePHPant](docs/elephpant.jpg)

## 1. Index

* [1. Index](#1-index)
* [2. Introduction](#2-introduction)
* [3. PHP directory structure](#3-php-directory-structure)
* [4. PHP extensions](#4-php-extensions)
* [5. Parser and lexer files](#5-parser-and-lexer-files)
* [6. \*nix build system](#6-nix-build-system)
  * [6.1. \*nix build system diagram](#61-nix-build-system-diagram)
  * [6.2. Build requirements](#62-build-requirements)
  * [6.3. The configure command line options](#63-the-configure-command-line-options)
* [7. Windows build system](#7-windows-build-system)
  * [7.1. Windows prerequisites](#71-windows-prerequisites)
* [8. CMake](#8-cmake)
  * [8.1. Installation](#81-installation)
  * [8.2. Why using CMake?](#82-why-using-cmake)
  * [8.3. Directory structure](#83-directory-structure)
  * [8.4. CMake build system diagram](#84-cmake-build-system-diagram)
  * [8.5. CMake usage](#85-cmake-usage)
  * [8.6. CMake minimum version for PHP](#86-cmake-minimum-version-for-php)
  * [8.7. CMake code style](#87-cmake-code-style)
  * [8.8. Command line options](#88-command-line-options)
  * [8.9. CMake presets](#89-cmake-presets)
  * [8.10. CMake generators for building PHP](#810-cmake-generators-for-building-php)
    * [8.10.1. Unix Makefiles (default)](#8101-unix-makefiles-default)
    * [8.10.2. Ninja](#8102-ninja)
* [9. See more](#9-see-more)

## 2. Introduction

In the realm of software development, a build system is a collection of tools
and files that automate the process of compiling, linking, and assembling the
project's source code into its final form, ready to be executed. It helps
developers with repetitive tasks and ensures consistency and correctness in the
build process for various platforms and hardware out there.

There are many well known build systems for C projects out there. From the
veteran GNU Autotools, popular CMake, Ninja, SCons, Meson, to the simplest
manual usage of Make.

PHP build system consist of two parts:

* \*nix build system (Linux, macOS, FreeBSD, OpenBSD, etc.)
* Windows build system

## 3. PHP directory structure

Before we begin, it might be useful to understand directory structure of the PHP
source code. PHP is developed at the
[php-src GitHub repository](https://github.com/php/php-src).

After cloning the repository:

```sh
git clone https://github.com/php/php-src
cd php-src
```

you end up with a large monolithic repository consisting of C source code files,
PHP tests and other files:

```sh
<php-src>/
 ├─ .git/                     # Git configuration and source directory
 ├─ appveyor/                 # Appveyor CI service files
 ├─ benchmark/                # Benchmark some common applications in CI
 ├─ build/                    # *nix build system files
 ├─ docs/                     # PHP internals documentation
 └─ ext/                      # PHP core extensions
    └─ bcmath/
       ├─ libbcmath/          # Forked and maintained in php-src
       ├─ tests/              # *.phpt test files for extension
       └─ ...
    └─ curl/
       ├─ sync-constants.php  # The curl symbols checker
       └─ ...
    └─ date/
       └─ lib/                # Bundled datetime library https://github.com/derickr/timelib
          └─ ...
       └─ ...
    ├─ dl_test/               # Extension for testing dl()
    └─ ffi/
       ├─ ffi_parser.c        # Generated by https://github.com/dstogov/llk
       └─ ...
    └─ fileinfo/
       ├─ libmagic/           # Modified libmagic https://github.com/file/file
       ├─ data_file.c         # Generated by `ext/fileinfo/create_data_file.php`
       ├─ libmagic.patch      # Modifications patch from upstream libmagic
       ├─ magicdata.patch     # Modifications patch from upstream libmagic
       └─ ...
    └─ gd/
       ├─ libgd/              # Bundled and modified GD library https://github.com/libgd/libgd
       └─ ...
    └─ mbstring/
       ├─ libmbfl/            # Forked and maintained in php-src
       ├─ unicode_data.h      # Generated by `ext/mbstring/ucgendat/ucgendat.php`
       └─ ...
    └─ pcre/
       ├─ pcre2lib/           # https://www.pcre.org/
       └─ ...
    ├─ skeleton/              # Skeleton for developing new extensions with `ext/ext_skel.php`
    └─ standard/              # Always enabled core extension
       └─ html_tables/
          ├─ mappings/        # https://www.unicode.org/Public/MAPPINGS/
          └─ ...
       ├─ credits_ext.h       # Generated by `scripts/dev/credits`
       ├─ credits_sapi.h      # Generated by `scripts/dev/credits`
       ├─ html_tables.h       # Generated by `ext/standard/html_tables/html_table_gen.php`
       └─ ...
    └─ tokenizer/
       ├─ tokenizer_data.c    # Generated by `ext/tokenizer/tokenizer_data_gen.sh`
       └─ ...
    └─ zend_test              # For testing internal APIs. Not needed for regular builds.
       └─ ...
    └─ zip/                   # Bundled https://github.com/pierrejoye/php_zip
       └─ ...
    ├─ ...
    └─ ext_skel.php           # Helper script that creates a new PHP extension
 └─ main/                     # Binding that ties extensions, SAPIs, and engine together
    ├─ streams/               # Streams layer subsystem
    └─ ...
 ├─ pear/                     # PEAR installation
 └─ sapi/                     # PHP SAPI modules
    └─ cli/
       ├─ mime_type_map.h     # Generated by `sapi/cli/generate_mime_type_map.php`
       └─ ...
    └─ ...
 ├─ scripts/                  # php-config, phpize and internal development scripts
 ├─ tests/                    # Core features tests
 ├─ travis/                   # Travis CI service files
 ├─ TSRM/                     # Thread safe resource manager
 └─ Zend/                     # Zend engine
    ├─ asm/                   # Bundled from src/asm in https://github.com/boostorg/context
    ├─ Optimizer/             # For faster PHP execution through opcode caching and optimization
    ├─ tests/                 # PHP tests *.phpt files for Zend engine
    ├─ zend_vm_execute.h      # Generated by `Zend/zend_vm_gen.php`
    ├─ zend_vm_opcodes.c      # Generated by `Zend/zend_vm_gen.php`
    ├─ zend_vm_opcodes.h      # Generated by `Zend/zend_vm_gen.php`
    └─ ...
 └─ win32/                    # Windows build system files
    ├─ cp_enc_map.c           # Generated by `win32/cp_enc_map_gen.exe`
    └─ ...
 └─ ...
```

## 4. PHP extensions

PHP has several ways to install PHP extensions:

* Bundled

  This is the default way. Extension is built together with PHP sapi and no
  enabling is needed in the `php.ini` configuration.

* Shared

  This installs the extension as dynamically loadable library. Extension to be
  visible in the PHP sapi (see `php -m`) needs to be also manually enabled in
  the `php.ini` configuration:

  ```ini
  # On *nix systems:
  extension=php_extension_name.so

  # Or on Windows:
  extension=php_extension_name.dll
  ```

The following extensions are always enabled and are part of the overall PHP
engine source code:

* `ext/date`
* `ext/hash`
* `ext/json`
* `ext/random`
* `ext/reflection`
* `ext/pcre`
* `ext/spl`
* `ext/standard`

PHP extensions ecosystem also consists of the [PECL](https://pecl.php.net)
extensions. These can be installed with a separate tool `pecl`:

```sh
pecl install php_extension_name
```

PECL tool is a simple shell script wrapper around the PHP code as part of the
[pear-core](https://github.com/pear/pear-core/blob/master/scripts/pecl.sh)
repository.

## 5. Parser and lexer files

Some source files are generated with 3rd party tools. These include so called
parser and lexer files which are generated with [re2c](https://re2c.org/) and
[bison](https://www.gnu.org/software/bison/).

Parser files are generated from `*.y` source using `bison` tool to C source code
and header files.

Lexer files are generated from `*.l` and `*.re` source files using `re2c` tool
to C source code and header files.

There is a helper shell script available that generates all these files when
developing PHP source, otherwise they are generated upon `make` step based on
the `Makefile.frag` files.

```sh
./scripts/dev/genfiles
```

```sh
<php-src>/
 └─ build/                          # *nix build system files
    ├─ php.m4                       # PHP Autoconf macros (together also with re2c and bison)
    └─ ...
 └─ ext/                            # PHP core extensions
    ├─ ...
    └─ date/
       └─ lib/                      # Bundled datetime library https://github.com/derickr/timelib
          ├─ parse_date.c           # Generated by re2c 0.15.3
          ├─ parse_iso_intervals.c  # Generated by re2c 0.15.3
          └─ ...
       └─ ...
    └─ ffi/
       ├─ ffi_parser.c              # Manually generated by https://github.com/dstogov/llk
       └─ ...
    └─ json/
       ├─ json_parser.tab.c         # Generated with bison
       ├─ json_parser.tab.h         # Generated with bison
       ├─ json_parser.y             # Parser source
       ├─ json_scanner.c            # Generated with re2c
       ├─ json_scanner.re           # Lexer source
       ├─ Makefile.frag             # Makefile fragment
       ├─ php_json_scanner_defs.h   # Generated with re2c
       └─ ...
    └─ pdo/
       ├─ Makefile.frag             # Makefile fragment
       ├─ pdo_sql_parser.c          # Generated with re2c
       ├─ pdo_sql_parser.re         # Source for re2c
       └─ ...
    └─ phar/
       ├─ Makefile.frag             # Makefile fragment
       ├─ phar_path_check.c         # Generated with re2c
       ├─ phar_path_check.re        # Source for re2c
       └─ ...
    └─ standard/
       ├─ Makefile.frag             # Makefile fragment
       ├─ url_scanner_ex.c          # Generated with re2c
       ├─ url_scanner_ex.re         # Source for re2c
       ├─ var_unserializer.c        # Generated with re2c
       ├─ var_unserializer.re       # Source for re2c
       └─ ...
    └─ ...
 └─ sapi/                           # PHP SAPI modules
    └─ phpdbg/
       ├─ phpdbg_lexer.c            # Generated with re2c
       ├─ phpdbg_lexer.l            # Source for re2c
       ├─ phpdbg_parser.c           # Generated with bison
       ├─ phpdbg_parser.h           # Generated with bison
       ├─ phpdbg_parser.y           # Source for bison
       ├─ phpdbg_parser.output      # Generated with bison
       └─ ...
    └─ ...
 └─ scripts/                        # php-config, phpize and internal development scripts
    └─ dev/
       ├─ genfiles                  # Parser and lexer files generator helper
       └─ ...
    └─ ...
 └─ Zend/                           # Zend engine
    ├─ Makefile.frag                # Part of Makefile related to Zend files
    ├─ zend_ini_parser.c            # Generated with bison
    ├─ zend_ini_parser.h            # Generated with bison
    ├─ zend_ini_parser.output       # Generated with bison
    ├─ zend_ini_parser.y            # Parser source
    ├─ zend_ini_scanner.c           # Generated with re2c
    ├─ zend_ini_scanner.l           # Lexer source
    ├─ zend_ini_scanner_defs.h      # Generated with re2c
    ├─ zend_language_parser.c       # Generated with bison
    ├─ zend_language_parser.h       # Generated with bison
    ├─ zend_language_parser.output  # Generated with bison
    ├─ zend_language_parser.y       # Parser source
    ├─ zend_language_scanner_defs.h # Generated with re2c
    ├─ zend_language_scanner.c      # Generated with re2c
    ├─ zend_language_scanner.l      # Lexer source
    └─ ...
 ├─ configure.ac                    # Minimum re2c and bison versions
 └─ ...
```

## 6. \*nix build system

\*nix build system in PHP uses [Autoconf](https://www.gnu.org/software/autoconf/)
to build a `configure` shell script that further creates main `Makefile` to
build sources to executable binaries.

```sh
./buildconf
./configure
make
```

The `buildconf` is a simple shell script wrapper around `autoconf` and
`autoheader` tools that checks required Autoconf version. It creates `configure`
command line script and `main/php_config.h.in` header template.

When running the `./configure`, many checks are done based on the running
system. Things like C headers availability, C symbols, etc.

The `configure` script creates `Makefile` where the `make` command then builds
binary files from C source files. You can optionally pass the `-j` option which
is the number of threads on current system, so it builds faster.

```sh
make -j $(nproc)
```

When compiling is done, you can install the needed files across the \*nix system
with:

```sh
make install
```

PHP \*nix build system is pretty much standard GNU Autotools build system with
few customizations. It doesn't use Automake and it bundles some 3rd party files
for easier installation across various systems out there without requiring
installation dependencies. Autotools is a veteran build system present since
early C/C++ days. It is used for most Linux ecosystem out there and it might
cause issues for C developers today.

Build system is a collection of various files across the php-src repository:

```sh
<php-src>/
 └─ build/                 # *nix build system files
    ├─ ax_*.m4             # https://github.com/autoconf-archive/autoconf-archive
    ├─ config-stubs        # Adds extension and sapi config*.m4 stubs to configure
    ├─ config.guess        # https://git.savannah.gnu.org/cgit/config.git
    ├─ config.sub          # https://git.savannah.gnu.org/cgit/config.git
    ├─ genif.sh            # Generator for the internal_functions* files
    ├─ libtool.m4          # Forked https://git.savannah.gnu.org/cgit/libtool.git
    ├─ ltmain.sh           # Forked https://git.savannah.gnu.org/cgit/libtool.git
    ├─ Makefile.global     # Root Makefile template when configure is run
    ├─ order_by_dep.awk    # Used by genif.sh
    ├─ php.m4              # PHP Autoconf macros
    ├─ pkg.m4              # https://gitlab.freedesktop.org/pkg-config/pkg-config
    ├─ print_include.awk   # Used by genif.sh
    ├─ shtool              # https://www.gnu.org/software/shtool/
    └─ ...
 └─ ext/                   # PHP core extensions
    └─ bcmath/
       ├─ config.m4        # Extension's Autoconf file
       └─ ...
    └─ date/
       ├─ config0.m4       # Suffix 0 is priority which includes the file before other config.m4 extension files
       └─ ...
    └─ mysqlnd/
       ├─ config9.m4       # Suffix 9 priority includes the file after other config.m4 files
       └─ ...
    └─ opcache/            # OPcache extension
       └─ jit/             # OPcache Jit
          ├─ Makefile.frag # Makefile fragment for OPcache Jit
          └─ ...
       ├─ config.m4        # Autoconf file for OPcache extension
       └─ ...
    └─ ...
 └─ main/                  # Binding that ties extensions, SAPIs, Zend engine and TSRM together
    ├─ streams/            # Streams layer subsystem
    ├─ php_version.h       # Generated by release managers using `configure`
    └─ ...
 ├─ pear/                  # PEAR installation
 └─ sapi/                  # PHP SAPI modules
    └─ cli/
       ├─ config.m4        # Autoconf M4 file for CLI sapi
       └─ ...
    └─ ...
 ├─ scripts/               # php-config, phpize and internal development scripts
 └─ TSRM/                  # Thread safe resource manager
    ├─ threads.m4          # Autoconf macros for pthreads
    ├─ tsrm.m4             # Autoconf macros for TSRM directory
    └─ ...
 └─ Zend/                  # Zend engine
    ├─ Makefile.frag       # Makefile fragment for Zend engine
    ├─ Zend.m4             # Autoconf macros for Zend directory
    └─ ...
 ├─ buildconf              # Wrapper for autoconf and autoheader tools
 ├─ configure.ac           # Autoconf main input file for constructing configure script
 └─ ...
```

### 6.1. \*nix build system diagram

![PHP *nix build system using Autotools](docs/autotools.svg)

### 6.2. Build requirements

Before being able to built PHP on Linux and other \*nix systems, there are some
3rd party requirements that need to be installed:

Required:
* autoconf
* make
* bison
* re2c
* gcc
* g++
* libxml

Optional:

* libcapstone (for the OPcache `--with-capstone` option)

### 6.3. The configure command line options

With Autoconf, there are two main types of command line options for the
`configure` script (`--enable-FEATURE` and `--with-PACKAGE`):

* `--enable-FEATURE[=ARG]` and its belonging opposite `--disable-FEATURE`

  `--disable-FEATURE` is the same as `--enable-FEATURE=no`

  These normally don't require 3rd party library or package installed on the
  system. For some extensions, PHP bundles 3rd party dependencies in the
  extension itself. For example, `bcmath`, `gd`, etc.

* `--with-PACKAGE[=ARG]` and its belonging opposite `--without-PACKAGE`

  `--without-PACKAGE` is the same as `--with-PACKAGE=no`

  These require 3rd party package installed on the system. PHP has even some
  libraries bundled in PHP source code. For example, the PCRE library and
  similar.

Others custom options that don't follow this pattern are used for adjusting
specific features during built process.

See `./configure --help` for more info.

This wraps up the \*nix build system using the Autotools.

## 7. Windows build system

Windows build system is a separate collection of
[JScript](https://en.wikipedia.org/wiki/JScript) files and command line scripts.
Some files are manually created unlike with Autoconf. For example, header files.
Similarly to `*.m4` files there are `*.w32` files for each extension and SAPI
module.

```sh
<php-src>/
 └─ ext/                       # PHP core extensions
    └─ bcmath/
       ├─ config.w32           # Extension's Windows build system item file
       └─ ...
    └─ iconv/                  # Iconv extension
       ├─ config.w32           # Extension's Windows build system item file
       ├─ php_iconv.def        # Module-definition file for linker when building DLL
       └─ ...
    └─ opcache/                # OPcache extension
       └─ jit/                 # OPcache Jit
          ├─ Makefile.frag.w32 # Makefile fragment for OPcache Jit
          └─ ...
       ├─ config.w32           # Windows build system script item
       └─ ...
    └─ ...
 └─ main/                      # Binding that ties extensions, SAPIs, and engine together
    ├─ streams/                # Streams layer subsystem
    ├─ php_version.h           # Generated by release managers using `configure`
    └─ ...
 └─ sapi/                      # PHP SAPI modules
    └─ cli/
       ├─ config.w32           # Windows build system item file for CLI sapi
       └─ ...
    └─ ...
 └─ win32/                     # Windows build system and code adjusted for Windows
    └─ build/                  # Windows build system configuration and scripts
       ├─ Makefile             # Windows build system Makefile template
       └─ ...
    └─ ...
 └─ TSRM/                      # Thread safe resource manager
    ├─ config.w32              # Windows build system script item
    └─ ...
 └─ Zend/                      # Zend engine
    ├─ zend_config.w32.h       # Windows configuration header for Zend directory
    └─ ...
 ├─ buildconf.bat              # Windows build system configuration builder
 └─ ...
```

### 7.1. Windows prerequisites

* Windows operating system.
* Visual Studio installed (e.g., Visual Studio 2019 or later).
* Git installed (download from https://git-scm.com/downloads).
* PHP source code downloaded from the PHP website (https://www.php.net/downloads.php).

Documentation to build PHP on Windows is available at [PHP Wiki](https://wiki.php.net/internals/windows/stepbystepbuild_sdk_2).

## 8. CMake

[CMake](https://cmake.org/) is another open-source cross-platform build system
created by Kitware and contributors. This is what this repository is focusing
on.

To learn CMake there is a very good
[documentation](https://cmake.org/cmake/help/latest/index.html) available and a
[tutorial](https://cmake.org/cmake/help/latest/guide/tutorial/index.html) which
is a prerequisite to follow the files in this repository.

### 8.1. Installation

```sh
# Clone this repository
git clone --recurse-submodules --shallow-submodules https://github.com/petk/php-build-system
cd php-build-system

# Patch php-src repository and run CMake commands to build PHP
./init --update --cmake
```

### 8.2. Why using CMake?

It is more developed and more developers are familiar with it. It also makes C
code more attractive to new contributors. Many IDEs provide a good CMake
integration for C/C++ projects.

Many things are very similar to Autoconf, which makes maintaining multiple build
systems simpler.

### 8.3. Directory structure

Directory structure from the CMake perspective looks like this:

```sh
<php-src>/
 └─ TSRM/                 # Thread safe resource manager
    ├─ CMakeLists.txt     # CMake file
    └─ ...
 └─ Zend/                 # Zend engine
    ├─ CMakeLists.txt     #
    └─ ...
 └─ cmake/                # CMake files
    ├─ modules/           # CMake modules
    └─ ...
 └─ ext/                  # PHP core extensions
    └─ bcmath/
       ├─ CMakeLists.txt  # Extension's CMake file
       └─ ...
    └─ date/
       ├─ CMakeLists.txt  # Extension's CMake file
       └─ ...
    └─ ...
 └─ main/                 # Binding that ties extensions, SAPIs, Zend engine and TSRM together
    ├─ streams/           # Streams layer subsystem
    ├─ php_version.h      # Generated by release managers using `configure`
    └─ ...
 ├─ pear/                 # PEAR installation
 └─ sapi/                 # PHP SAPI modules
    └─ cli/
       ├─ CMakeLists.txt  # CMake file
       └─ ...
    └─ ...
 ├─ scripts/              # php-config, phpize and internal development scripts
 ├─ CMakeLists.txt        # Root CMake file
 └─ ...
```

### 8.4. CMake build system diagram

![PHP build system using CMake](docs/cmake.svg)

### 8.5. CMake usage

```sh
cmake .
cmake --build .
```

### 8.6. CMake minimum version for PHP

With CMake the minimum required version is defined in the top project file
`CMakeLists.txt` using the `cmake_minimum_required()`.

Currently the CMake minimum version is set to:

* 3.17 (to have CMAKE_CURRENT_FUNCTION_LIST_DIR available)
* 3.19 (to be able to use CMakePresets.json for sharing build configurations)
* 3.20 (to have CMAKE_C_BYTE_ORDER, otherwise manual check should be done)
* 3.25

### 8.7. CMake code style

This repository is following some best practices from the CMake ecosystem:

* In general the all-lowercase style is preferred.

  ```cmake
  add_library(ctype ctype.c)
  ```

* End commands

  To make the code easier to read, use empty commands for `endif()`,
  `endfunction()`, `endforeach()`, `endmacro()` and `endwhile()`, `else()`, and
  similar end commands. The optional argument in these is legacy CMake and not
  recommended anymore.

  For example, do this:

  ```cmake
  if(FOOVAR)
    some_command(...)
  else()
    another_command(...)
  endif()
  ```

  and not this:

  ```cmake
  if(BARVAR)
    some_other_command(...)
  endif(BARVAR)
  ```

### 8.8. Command line options

List of configure command line options and their CMake alternatives:

| configure                            | CMake                   | Default value/notes |
| ------------------------------------ | ----------------------- | ------------------  |
| `--enable-gcc-global-regs`           | `-DGCC_GLOBAL_REGS`     | `ON`                |
| `--enable-debug`                     | `-DDEBUG`               |                     |
| `--enable-fiber-asm`                 | `-DFIBER_ASM`           |                     |
| `--enable-ipv6`                      | `-DIPV6`                | `ON`                |
|   `--disable-ipv6`                   |   `-DIPV6=OFF`          |                     |
| `--disable-rtld-now`                 | `-DRTLD_NOW=OFF`        | `OFF`               |
|   `--enable-rtld-now`                | `-DRTLD_NOW=ON`         |                     |
| `--enable-short-tags` (default)      | `-DSHORT_TAGS=ON`       | `ON`                |
|   `--disable-short-tags`             | `-DSHORT_TAGS=OFF`      |                     |
| `--disable-zts` (default)            | `-DZTS=OFF`             | `OFF`               |
| `--enable-zts`                       | `-DZTS=ON`              |                     |
| `--enable-zend-signals`              | `-Dzend_signals=ON`     | `ON`                |
| `--disable-dtrace` (default)         | `-DDTRACE=OFF`          | `OFF`               |
| `--enable-dtrace`                    | `-DDTRACE=ON`           |                     |
| **PHP sapi modules**                 |                         |                     |
| `--enable-cli` / `--disable-cli`     | `-Dcli`                 | `ON`                |
| `--disable-cli`                      | `-Dcli=OFF`             |                     |
| **PHP extensions**                   |                         |                     |
| `--disable-bcmath` (default)         | `-Dbcmath=OFF`          | `OFF`               |
| `--enable-bcmath`                    | `-Dbcmath=ON`           |                     |
| `--enable-bcmath=shared`             | `-Dbcmath=shared`       |                     |
| `--enable-calendar`                  | `-Dcalendar=ON`         |                     |
| `--enable-calendar=shared`           | `-Dcalendar=shared`     |                     |
| `--disable-calendar`                 | `-Dcalendar=OFF`        | `OFF`               |
| `--enable-ctype`                     | `-Dctype=ON`            | `ON`                |
| `--enable-ctype=shared`              | `-Dctype=shared`        |                     |
| `--disable-ctype`                    | `-Dctype=OFF`           |                     |
| `--enable-dl-test`                   | `-Ddl_test=ON`          | `OFF`               |
| `--enable-dl-test=shared`            | `-Ddl_test=shared`      |                     |
| `--disable-dl-test`                  | `-Ddl_test=OFF`         |                     |
| `--enable-exif`                      | `-Dexif=ON`             | `OFF`               |
| `--enable-exif=shared`               | `-Dexif=shared`         |                     |
| `--disable-exif`                     | `-Dexif=OFF`            | `OFF`               |
| `--enable-filter` (default)          | `-Dfilter=ON`           | `ON`                |
| `--enable-filter=shared`             | `-Dfilter=shared`       |                     |
| `--disable-filter`                   | `-Dfilter=OFF`          |                     |
| `--without-mhash` (default)          | `-Dmhash=OFF`           | `OFF`               |
| `--with-mhash`                       | `-Dmhash=ON`            |                     |
| `--enable-opcache=shared` (default)  | `-Dopcache=shared`      | `"shared"`          |
| `--enable-opcache`                   | `-Dopcache=ON`          | will be shared      |
| `--disable-opcache`                  | `-Dopcache=OFF`         |                     |
| `--enable-huge-code-pages` (default) | `-Dhuge_code_pages=ON`  | `ON`                |
| `--disable-huge-code-pages`          | `-Dhuge_code_pages=OFF` |                     |
| `--enable-opcache-jit` (default)     | `-Dopcache_jit=ON`      | `ON`                |
| `--disable-opcache-jit`              | `-Dopcache_jit=OFF`     |                     |
| `--without-capstone` (default)       | `-Dcapstone=OFF`        | `OFF`               |
| `--with-capstone`                    | `-Dcapstone=ON`         |                     |
| `--without-external-pcre` (default)  | `-DEXTERNAL_PCRE=OFF`   | `OFF`               |
| `--with-external-pcre`               | `-DEXTERNAL_PCRE=ON`    |                     |
| `--with-pcre-jit` (default)          | `-DPCRE_JIT=ON`         | `ON`                |
| `--without-pcre-jit`                 | `-DPCRE_JIT=OFF`        |                     |
| `--enable-posix`                     | `-Dposix=ON`            | `ON`                |
| `--enable-posix=shared`              | `-Dposix=shared`        |                     |
| `--disable-posix`                    | `-Dposix=OFF`           |                     |
| `--with-external-pcre`               | `-DEXTERNAL_LIBCRYPT`   | `OFF`               |
| `--enable-phar`                      | `-Dphar`                | `ON`                |
| `--disable-shmop` (default)          | `-Dshmop=OFF`           | `OFF`               |
| `--enable-shmop`                     | `-Dshmop=ON`            |                     |
| `--enable-shmop=shared`              | `-Dshmop=shared`        |                     |
| `--disable-sysvmsg` (default)        | `-Dsysvmsg=OFF`         | `OFF`               |
| `--enable-sysvmsg`                   | `-Dsysvmsg=ON`          |                     |
| `--enable-sysvmsg=shared`            | `-Dsysvmsg=shared`      |                     |
| `--disable-sysvsem` (default)        | `-Dsysvsem=OFF`         | `OFF`               |
| `--enable-sysvsem`                   | `-Dsysvsem=ON`          |                     |
| `--enable-sysvsem=shared`            | `-Dsysvsem=shared`      |                     |
| `--disable-sysvshm` (default)        | `-Dsysvshm=OFF`         | `OFF`               |
| `--enable-sysvshm`                   | `-Dsysvshm=ON`          |                     |
| `--enable-sysvshm=shared`            | `-Dsysvshm=shared`      |                     |
| `--enable-tokenizer` (default)       | `-Dtokenizer=ON`        |                     |
| `--enable-tokenizer=shared`          | `-Dtokenizer=shared`    |                     |
| `--disable-tokenizer`                | `-Dtokenizer=OFF`       |                     |
| `--disable-zend-test` (default)      | `-Dzend_test=OFF`       | `OFF`               |
| `--enable-zend-test`                 | `-Dzend_test=ON`        |                     |
| `--enable-zend-test=shared`          | `-Dzend_test=shared`    |                     |

List of configure environment variables:

These are passed as `./configure VAR=VALUE`.

| configure                        | CMake                               | Default value   |
| -------------------------------- | ----------------------------------- | --------------- |
| `LDFLAGS="..."`                  | `-DCMAKE_EXE_LINKER_FLAGS="..."`    |                 |
|                                  | `-DCMAKE_SHARED_LINKER_FLAGS="..."` |                 |
| `PHP_EXTRA_VERSION="-foo"`       | `-DPHP_VERSION_LABEL="-foo"`        | `-dev` or empty |

### 8.9. CMake presets

The `CMakePresets.json` and `CMakeUserPresets.json` files are available since
CMake 3.19 for sharing build configurations.

### 8.10. CMake generators for building PHP

When using CMake to build PHP, you have the flexibility to choose from various
build systems through the concept of _generators_. CMake generators determine
the type of project files or build scripts that CMake generates from your
`CMakeLists.txt` file. In this example, we will check the following generators:
Unix Makefiles and Ninja.

#### 8.10.1. Unix Makefiles (default)

The Unix Makefiles generator is the most common and widely used generator for
building projects on Unix-like systems, including Linux and macOS. It generates
traditional `Makefile` that can be processed by the `make` command. To use the
Unix Makefiles generator, you simply specify it as an argument when running
CMake in your build directory.

To generate the `Makefile` for building PHP, create a new directory (often
called `build` or `cmake-build`) and navigate to it using the terminal. Then,
execute the following CMake command:

```sh
cmake -G "Unix Makefiles" /path/to/php-src
```

Replace `/path/to/php-src` with the actual path to the PHP source code on
your system (in case build directory is the same as the source directory, use
`.`). CMake will process the `CMakeLists.txt` file in the source directory and
generate the `Makefile` in the current build directory.

After the Makefiles are generated, you can use the make command to build PHP:

```sh
make
```

The make command will build the PHP binaries and libraries according to the
configuration specified in the `CMakeLists.txt` file. If you want to speed up
the build process, you can use the `-j` option to enable parallel builds, taking
advantage of multiple CPU cores:

```sh
make -j$(nproc) # number of CPU cores you want to utilize.
```

#### 8.10.2. Ninja

[Ninja](https://ninja-build.org/) is another build system supported by CMake and
is known for its fast build times due to its minimalistic design. To use the
Ninja generator, you need to have Ninja installed on your system. Most package
managers on Unix systems offer Ninja as a package, so you can install it easily.

To generate Ninja build files for building PHP, navigate to your build directory
in the terminal and run the following CMake command:

```sh
cmake -G "Ninja" /path/to/php-src
```

Again, replace `/path/to/php/src` with the actual path to the PHP source code.
CMake will generate the Ninja build files in the current directory.

To build PHP with Ninja, execute the following command:

```sh
ninja
```

Ninja will then handle the build process based on the CMake configuration.
Similar to the Unix Makefiles generator, you can use the `-j` option to enable
parallel builds with Ninja (by default, however, `-j` is already set to the
number of available CPU cores on your system):

```sh
ninja -j$(nproc)
```

## 9. See more

To learn more about Autoconf and Autotools in general:

* [Autoconf documentation](https://www.gnu.org/software/autoconf/manual/index.html)
* [Autotools Mythbuster](https://autotools.info/) - guide to Autotools

Useful resources to learn more about PHP internals:

* [PHP Internals Book](https://www.phpinternalsbook.com/)

CMake and PHP:

* [php-cmake](https://github.com/gloob/php-cmake) - CMake implementation in PHP.
* [Latest CMake discussion](https://externals.io/message/116655)
