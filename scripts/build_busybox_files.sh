#!/bin/bash

set -e

TOP_DIR=$HOME/bbb-dev
BUSYBOX_SRC=$TOP_DIR/busybox/busybox-1.36.1
TOOLCHAIN_LIB=$TOP_DIR/toolchain/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-linux-gnueabihf/arm-none-linux-gnueabihf/libc

ROOTFS_DIR=$TOP_DIR/rootfs

JOBS=$(nproc)

export ARCH=arm
export CROSS_COMPILE=arm-none-linux-gnueabihf-

clean()
{
	echo
	echo "*************************"
	echo "Cleaning the Busybox tree"
	echo "*************************"
	echo

	cd "$BUSYBOX_SRC"
	make distclean
	cd "$ROOTFS_DIR"
	rm -rf *
}
config()
{
	echo
	echo "*******************"
	echo "Configuring Busybox"
	echo "*******************"
	echo

	cd "$BUSYBOX_SRC"
	make defconfig
}
menuconfig()
{
	echo
	echo "*********************"
	echo "Customize Rootfs here"
	echo "*********************"
	echo

	cd "$BUSYBOX_SRC"
	make menuconfig
}
build()
{
	echo
	echo "*********************"
	echo "Building Rootfs files"
	echo "*********************"
	echo

	cd "$BUSYBOX_SRC"
	make -j"$JOBS"
}
install()
{
	echo
	echo "*****************"
	echo "Installing Rootfs"
	echo "*****************"
	echo

	cd "$BUSYBOX_SRC"
	make CONFIG_PREFIX="$ROOTFS_DIR" install
}
rootfs_overlays()
{
	echo
	echo "***********************"
	echo "Copying ROOTFS overlays"
	echo "***********************"
	echo

	cd "$TOP_DIR"
	cp -a rootfs-overlays/. rootfs/
}
cp_toolchain_lib()
{
	echo
	echo "*********************"
	echo "Copying Toolchain lib"
	echo "*********************"
	echo
	cd "$ROOTFS_DIR"
	mkdir -p lib
	mkdir -p usr/lib

	cd "$TOOLCHAIN_LIB"
	cp -a lib/* "$ROOTFS_DIR"/lib/
	cp -a usr/lib/* "$ROOTFS_DIR"/usr/lib/
}
cp_kernel_modules()
{
	echo
	echo "**********************"
	echo "Copying Kernel Modules"
	echo "**********************"
	echo

	cd "$ROOTFS_DIR"
	mkdir -p lib

	cd "$TOP_DIR"
	cp -a lib/* "$ROOTFS_DIR"/lib/
}
all()
{
	clean
	config
	menuconfig
	build
	install
	rootfs_overlays
	cp_toolchain_lib
	cp_kernel_modules
}

case "$1" in
	clean)
		clean
		;;
	config)
		config
		;;
	menuconfig)
		menuconfig
		;;
	build)
		build
		;;
	install)
		install
		;;
	rootfs_overlays)
		rootfs_overlays
		;;
	cp_toolchain_lib)
		cp_toolchain_lib
		;;
	cp_kernel_modules)
		cp_kernel_modules
		;;
	all)
		all
		;;
	*)
		echo
		echo "*****************************"
		echo "./build_busybox_files.sh clean"
		echo "./build_busybox_files.sh config"
		echo "./build_busybox_files.sh menuconfig"
		echo "./build_busybox_files.sh build"
		echo "./build_busybox_files.sh install"
		echo "./build_busybox_files.sh rootfs_overlays"
		echo "./build_busybox_files.sh cp_toolchain_lib"
		echo "./build_busybox_files.sh cp_kernel_modules"
		echo "./build_busybox_files.sh all"
		echo "*****************************"
		echo
		;;
esac

