#!/bin/bash

set -e

BBB_DEV=$HOME/bbb-dev
QT_SRC=$BBB_DEV/qt/source/qt-everywhere-src-6.11.1
QT_BUILD=$BBB_DEV/qt/build-host
QT_HOST=$BBB_DEV/qt/host

mkdir -p $QT_BUILD
mkdir -p $QT_HOST

cd $QT_BUILD

$QT_SRC/configure \
    -release \
    -nomake tests \
    -nomake examples \
    -prefix $QT_HOST

cmake --build . -j$(nproc)

cmake --install .

echo ""
echo "Host Qt build completed."
echo "Installed at: $QT_HOST"
