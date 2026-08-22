#!/bin/bash

set -e

BBB_DEV=$HOME/bbb-dev
QT_TOP=$BBB_DEV/qt

mkdir -p $QT_TOP/build
mkdir -p $QT_TOP/install
mkdir -p $QT_TOP/host

cd $QT_TOP/build

$QT_TOP/source/qt-everywhere-src-6.11.1/configure \
    -release \
    -nomake examples \
    -nomake tests \
    -prefix /usr/local/qt6 \
    -extprefix $QT_TOP/install \
    -qt-host-path $QT_TOP/host \
    -DCMAKE_TOOLCHAIN_FILE=$QT_TOP/toolchain.cmake
