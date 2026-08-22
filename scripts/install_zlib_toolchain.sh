#!/bin/bash

set -e

ZLIB_DIR=/home/channaveeragouda/bbb-dev/applications/zlib/zlib-1.3.2

SYSROOT=$(arm-none-linux-gnueabihf-gcc -print-sysroot)

cd "$ZLIB_DIR"

make distclean || true

CC=arm-none-linux-gnueabihf-gcc \
./configure --prefix=/usr

make -j$(nproc)

make DESTDIR="$SYSROOT" install
