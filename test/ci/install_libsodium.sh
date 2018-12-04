#!/bin/sh

set -e

CACHE_DIR="$HOME/libsodium/$LIBSODIUM_VERSION"
if [ ! -d "$CACHE_DIR/lib" ]; then
  wget "https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VERSION.tar.gz"
  tar xvfz "libsodium-$LIBSODIUM_VERSION.tar.gz"
  cd "libsodium-$LIBSODIUM_VERSION"
  ./configure --prefix=$CACHE_DIR
  make && make check
  make install
else
  echo "Libsodium $LIBSODIUM_VERSION cached"
fi
