#!/bin/bash

set -e

ZLIB_DIR=/home/channaveeragouda/bbb-dev/applications/zlib/zlib-1.3.2
ROOTFS_DIR=/home/channaveeragouda/bbb-dev/rootfs

cd "$ZLIB_DIR"

CC=arm-none-linux-gnueabihf-gcc \
./configure --prefix=/usr

make

make DESTDIR="$ROOTFS_DIR" install
