#!/bin/bash

set -e

DROPBEAR_DIR=/home/channaveeragouda/bbb-dev/applications/dropbear/dropbear-2026.91
ROOTFS_DIR=/home/channaveeragouda/bbb-dev/rootfs

cd "$DROPBEAR_DIR"

make distclean || true
./configure \
    	--host=arm-none-linux-gnueabihf \
    	--prefix=/usr

make PROGRAMS="dropbear dbclient dropbearkey scp"

make DESTDIR="$ROOTFS_DIR" install
