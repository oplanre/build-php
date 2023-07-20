#!/bin/sh
#
# CMake initialization helper script.

update=0
cmake=0
debug=0

# Go to project root.
cd $(CDPATH= cd -- "$(dirname -- "$0")" && pwd -P)

while test $# -gt 0; do
  if test "$1" = "-h" || test "$1" = "--help"; then
    cat << HELP
PHP CMake initialization helper

SYNOPSIS:
  init.sh [<options>]

OPTIONS:
  -u, --update    Clone and/or pull the php-src Git repository.
  -c, --cmake     Run cmake configuration and build commands.
  --debug         Display warnings.
  -h, --help      Display this help.

ENVIRONMENT:
  The following optional variables are supported:
HELP
    exit 0
  fi

  if test "$1" = "-u" || test "$1" = "--update"; then
    update=1
  fi

  if test "$1" = "-c" || test "$1" = "--cmake"; then
    cmake=1
  fi

  if test "$1" = "--debug"; then
    debug=1
  fi

  shift
done

# Clone a fresh latest php-src repository.
if test ! -d "php-src"; then
  git clone --depth 1 https://github.com/php/php-src ./php-src
fi

if test "$update" = "1"; then
  cd php-src
  git checkout .
  git clean -dffx .
  git pull --rebase
  cd ..
fi

cp -r cmake/* php-src/

# Apply patches to php-src from the patches directory.
patches=$(find ./patches -maxdepth 1 -type f -name "*.patch")
for file in $patches; do
  case $file in
    *.patch)
      patch -p1 -d php-src < $file
      ;;
  esac
done

# Run cmake configuration and build.
if test "$cmake" = "1"; then
  cd php-src
  cmake .
  cmake --build . -- --jobs $(nproc)
  #cmake --build .
else
  echo "Now run:
    cmake .
    cmake --build .
  "
fi
