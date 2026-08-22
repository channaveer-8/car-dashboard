#!/bin/bash

set -e

TOP_DIR=$HOME/bbb-dev
UBOOT_SRC=$TOP_DIR/u-boot/u-boot-2026.04
IMAGE_DIR=$TOP_DIR/images
JOBS=$(nproc)

IMG_PATH=$UBOOT_SRC/u-boot.img
MLO_PATH=$UBOOT_SRC/MLO

export ARCH=arm
export CROSS_COMPILE=arm-none-linux-gnueabihf-

clean()
{
	echo "********************"
	echo "Cleaning U-boot tree"
	echo "********************"

	cd "$UBOOT_SRC"
	make distclean
}

config()
{
	echo "*****************"
	echo "Configuring uboot"
	echo "*****************"
	
	cd "$UBOOT_SRC"
	make am335x_evm_defconfig
}

menu_config()
{
	echo "****************"
	echo "Customize U-boot"
	echo "****************"
	
	cd "$UBOOT_SRC"
	make menuconfig
}

build()
{
	echo "*********************"
	echo "Building U-boot files"
	echo "*********************"
	
	cd "$UBOOT_SRC"
	make -j"$JOBS"
}

copy_artifacts()
{
	echo "***************************"
	echo "Copying files to images dir"
	echo "***************************"
	
	cp "$IMG_PATH" "$IMAGE_DIR"
	cp "$MLO_PATH" "$IMAGE_DIR"
}

show_info()
{
	echo "***********"
	echo "U-boot Info"
	echo "***********"
	
	cd "$UBOOT"
	make ubootversion
	arm-none-linux-gnueabihf-gcc --version | head -1
}

all()
{
	echo "********************"
	echo "Building full U-boot"
	echo "********************"
	
	clean
	config
	build
	copy_artifacts
	show_info
}

case "$1" in
	clean)
		clean
		;;
	config)
		config
		;;
	menu_config)
		menu_config
		;;
	build)
		build
		;;
	copy_artifacts)
		copy_artifacts
		;;
	show_info)
		show_info
		;;
	all)
		all
		;;
	*)
		echo "*************************************"
		echo "./build_uboot_files.sh clean"
		echo "./build_uboot_files.sh config"
		echo "./build_uboot_files.sh menu_config"
		echo "./build_uboot_files.sh build"
		echo "./build_uboot_files.sh copy_artifacts"
		echo "./build_uboot_files.sh show_info"
		echo "*************************************"
		;;
esac
