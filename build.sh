#!/bin/sh

OUTPUT_DIRECTORY="output"
BUILDROOT=buildroot-2024.08.1
# Supported targets: cmhybrid (supports cm1 cm3), cm4
TARGET=cm4

#
# Extract the tarball containing the unmodified buildroot version 
#
if [ ! -e $BUILDROOT ]; then
    tar xzf $BUILDROOT.tar.gz
fi

#
# Tell buildroot we have extra files in our external directory
# and use our scriptexecute_defconfig configuration file 
#
if [ ! -e $BUILDROOT/.config ]; then
    make -C $BUILDROOT BR2_EXTERNAL="$PWD/scriptexecute" scriptexecute_${TARGET}_defconfig
fi

#
# Build everything
#
CPU_COUNT=$(nproc)
FORCE_UNSAFE_CONFIGURE=1 make -C $BUILDROOT "-j${CPU_COUNT}"

#
# Copy the files we are interested in from buildroot's "output/images" directory
# to our "output" directory in top level directory 
#

# initramfs file build by buildroot containing the root file system
cp $BUILDROOT/output/images/rootfs.cpio.xz "${OUTPUT_DIRECTORY}/scriptexecute.img"
# Linux kernel
cp $BUILDROOT/output/images/zImage "${OUTPUT_DIRECTORY}/kernel.img"
# Raspberry Pi firmware files
cp $BUILDROOT/output/images/rpi-firmware/* "${OUTPUT_DIRECTORY}"
cp $BUILDROOT/output/images/*.dtb "${OUTPUT_DIRECTORY}"

# Uncomment if using dwc2
mkdir -p "${OUTPUT_DIRECTORY}/overlays"
mv "${OUTPUT_DIRECTORY}/dwc2-overlay.dtb" "${OUTPUT_DIRECTORY}/overlays/dwc2.dtbo"
mv "${OUTPUT_DIRECTORY}/spi-gpio40-45-overlay.dtb" "${OUTPUT_DIRECTORY}/overlays/spi-gpio40-45.dtbo"

echo
echo Build complete. Files are in output folder.
echo
