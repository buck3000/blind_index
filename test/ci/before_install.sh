#!/bin/sh

set -e

LIBSODIUM_VERSION="1.0.16"

if [ ! -d "$HOME/libsodium" ]; then
  wget "https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VERSION.tar.gz"
  tar xvfz "libsodium-$LIBSODIUM_VERSION.tar.gz"
  cd "libsodium-$LIBSODIUM_VERSION"
  ./configure --prefix=$HOME/libsodium
  make && make check
  make install
fi
