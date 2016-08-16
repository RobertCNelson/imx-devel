#!/bin/sh
#
ARCH=$(uname -m)

config="imx_v6_v7_defconfig"

build_prefix="-rex"
branch_prefix="v"
branch_postfix=".x-rex"

#arm
KERNEL_ARCH=arm
#toolchain="gcc_linaro_eabi_4_8"
#toolchain="gcc_linaro_eabi_4_9"
#toolchain="gcc_linaro_eabi_5"
#toolchain="gcc_linaro_eabi_6"
#toolchain="gcc_linaro_gnueabi_4_6"
#toolchain="gcc_linaro_gnueabihf_4_7"
#toolchain="gcc_linaro_gnueabihf_4_8"
toolchain="gcc_linaro_gnueabihf_4_9"
#toolchain="gcc_linaro_gnueabihf_5"
#toolchain="gcc_linaro_gnueabihf_6"
#arm64
#KERNEL_ARCH=arm64
#toolchain="gcc_linaro_aarch64_gnu_5"
#toolchain="gcc_linaro_aarch64_gnu_6"

#Kernel/Build
KERNEL_REL=3.17
KERNEL_TAG=${KERNEL_REL}-rc5
BUILD=${build_prefix}3

#v3.X-rcX + upto SHA
#KERNEL_SHA="c9d26423e56ce1ab4d786f92aebecf859d419293"

#git branch
BRANCH="${branch_prefix}${KERNEL_REL}${branch_postfix}"

DISTRO=cross
DEBARCH=armhf
#
