#!/bin/sh
#
ARCH=$(uname -m)
DISABLE_MASTER_BRANCH=1

#Dual/Quad Core arms are now more prevalent, so don't just limit to x86:
CORES=$(cat /proc/cpuinfo | grep processor | wc -l)

unset GIT_OPTS
unset GIT_NOEDIT
LC_ALL=C git help pull | grep -m 1 -e "--no-edit" >/dev/null 2>&1 && GIT_NOEDIT=1

if [ "${GIT_NOEDIT}" ] ; then
	GIT_OPTS="${GIT_OPTS} --no-edit"
fi

config="imx5_defconfig"

#Kernel/Build
KERNEL_REL=2.6.35
KERNEL_TAG=${KERNEL_REL}.3
BUILD=imx3.7

#v3.X-rcX + upto SHA
#KERNEL_SHA=""

#git branch
BRANCH="imx-bsp"

BUILDREV=1.0
DISTRO=cross
DEBARCH=armel
