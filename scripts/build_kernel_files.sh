#!/bin/bash

set -e
####****Configurations****###

export ARCH=arm
export CROSS_COMPILE=arm-none-linux-gnueabihf-

TOP_DIR=$HOME/bbb-dev
KERNEL_SRC=$TOP_DIR/linux/linux-6.18.35
JOBS=$(nproc)

ZIMAGE_PATH=$KERNEL_SRC/arch/arm/boot/zImage
DTB_PATH=$KERNEL_SRC/arch/arm/boot/dts/ti/omap/am335x-boneblack.dtb

IMAGES_DIR=$TOP_DIR/images

###****Functions****###

clean()
{
	echo "Cleaning kernel tree ..."
	cd "$KERNEL_SRC"
	make distclean
}

config()
{
	echo "Configuring kernel ..."
	cd "$KERNEL_SRC"
	make omap2plus_defconfig
}

zimage()
{
	echo "Building kernel zimage ..."
	cd "$KERNEL_SRC"
	make zImage -j"$JOBS"
}

dtbs()
{
	echo "Building DTBs ..."
	cd "$KERNEL_SRC"
	make dtbs -j"$JOBS"
}

modules()
{
	echo "Buillding modules ..."
	cd "$KERNEL_SRC"
	make modules -j"$JOBS"
}

install_modules()
{
	echo "Installing modules ..."
	cd "$KERNEL_SRC"
	make modules_install \
		INSTALL_MOD_PATH="$TOP_DIR"
	echo "Modules are installed. Path:$TOP_DIR"
}

copy_artifacts()
{
	echo "Copying zImage & DTB to, Path:$IMAGES_DIR"
	cd "$KERNEL_SRC"
	cp "$DTB_PATH" "$IMAGES_DIR"
	cp "$ZIMAGE_PATH" "$IMAGES_DIR"
}

prepare()
{
	echo "Preparing kernel for external modules ..."
	cd "$KERNEL_SRC"
	make modules_prepare
}

show_info()
{
	echo "Kernel Release:"
	make kernelrelease
	arm-none-linux-gnueabihf-gcc --version | head -1
}

all()
{
	clean
	config
	zimage
	dtbs
	modules
	install_modules
	copy_artifacts
	prepare
	show_info
}

menu_config()
{
	echo "Customize the Kernel here .."
	cd "$KERNEL_SRC"
	make menuconfig
}

###****Main****####

case "$1" in
	menu_config)
		menu_config
		;;
	clean)
		clean
		;;
	config)
		config
		;;
	zimage)
		zimage
		;;
	dtbs)
		dtbs
		;;
	modules)
		modules
		;;
	install_modules)
		install_modules
		;;
	copy_artifacts)
		copy_artifacts
		;;
	prepare)
		prepare
		;;
	show_info)
		show_info
		;;
	all)
		all
		;;
	*)
		echo
		echo "Path:$TOP_DIR/scripts"
		echo "./build_kernel_files.sh clean"
		echo "./build_kernel_files.sh config"
		echo "./build_kernel_files.sh zimage"
		echo "./build_kernel_files.sh dtbs"
		echo "./build_kernel_files.sh modules"
		echo "./build_kernel_files.sh install_modules"
		echo "./build_kernel_files.sh copy_artifacts"
		echo "./build_kernel_files.sh prepare"
		echo "./build_kernel_files.sh show_info"
		echo "./build_kernel_files.sh all"
		echo "./build_kernel_files.sh menu_config"
		;;
esac
