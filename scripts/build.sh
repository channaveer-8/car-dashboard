#!/bin/bash

CONFIG_FILE=".config"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Error: .config not found"
    exit 1
fi

source "$CONFIG_FILE"

# Clean Operations
[ "$CONFIG_CLEAN_ALL" = "y" ] && {
    ./build_uboot_files.sh clean
    ./build_kernel_files.sh clean
    ./build_busybox_files.sh clean
    exit 0
}

[ "$CONFIG_CLEAN_UBOOT" = "y" ] && \
    ./build_uboot_files.sh clean

[ "$CONFIG_CLEAN_KERNEL" = "y" ] && \
    ./build_kernel_files.sh clean

[ "$CONFIG_CLEAN_ROOTFS" = "y" ] && \
    ./build_busybox_files.sh clean


# Configure Operations
[ "$CONFIG_CONFIGURE_UBOOT" = "y" ] && \
    ./build_uboot_files.sh menu_config

[ "$CONFIG_CONFIGURE_KERNEL" = "y" ] && \
    ./build_kernel_files.sh menu_config

[ "$CONFIG_CONFIGURE_ROOTFS" = "y" ] && \
    ./build_busybox_files.sh menuconfig


# Build Operations
[ "$CONFIG_BUILD_ALL" = "y" ] && {
    ./build_uboot_files.sh all
    ./build_kernel_files.sh all
    ./build_busybox_files.sh all
    exit 0
}

[ "$CONFIG_BUILD_UBOOT" = "y" ] && \
    ./build_uboot_files.sh all

[ "$CONFIG_BUILD_KERNEL" = "y" ] && \
    ./build_kernel_files.sh all

[ "$CONFIG_BUILD_ROOTFS" = "y" ] && \
    ./build_busybox_files.sh all

echo "Done."
