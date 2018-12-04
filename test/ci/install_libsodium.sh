#!/bin/sh

set -e

if [ ! -d "$HOME/libsodium/$LIBSODIUM_VERSION" ]; then
  wget https://download.libsodium.org/libsodium/releases/libsodium-$LIBSODIUM_VERSION.tar.gz
  tar xvfz libsodium-$LIBSODIUM_VERSION.tar.gz
  cd libsodium-$LIBSODIUM_VERSION
  ./configure --prefix=$HOME/libsodium/$LIBSODIUM_VERSION
  make
  make install
else
  echo "Libsodium cached"
fi
