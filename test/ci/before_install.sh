#!/bin/sh

set -e

LIBSODIUM_VERSION="1.0.16"
CACHE_DIR="$HOME/libsodium/$LIBSODIUM_VERSION"

if [ ! -d $CACHE_DIR ]; then
  mkdir -p $CACHE_DIR
  wget "https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VERSION.tar.gz"
  tar xvfz "libsodium-$LIBSODIUM_VERSION.tar.gz"
  cd "libsodium-$LIBSODIUM_VERSION"
  ./configure --prefix=$CACHE_DIR
  make && make check
  make install
fi
