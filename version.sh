#!/bin/bash
#
ARCH=$(uname -m)
DISABLE_MASTER_BRANCH=1

CORES=1
if [ "x${ARCH}" == "xx86_64" ] || [ "x${ARCH}" == "xi686" ] ; then
	CORES=$(cat /proc/cpuinfo | grep processor | wc -l)
	let CORES=$CORES+1
fi

unset GIT_OPTS
unset GIT_NOEDIT
LC_ALL=C git help pull | grep -m 1 -e "--no-edit" &>/dev/null && GIT_NOEDIT=1

if [ "${GIT_NOEDIT}" ] ; then
	GIT_OPTS+="--no-edit"
fi

CCACHE=ccache

config="imx_v6_v7_defconfig"

#Kernel/Build
KERNEL_REL=3.7
KERNEL_TAG=${KERNEL_REL}.1
BUILD=imx3.1

#v3.X-rcX + upto SHA
#KERNEL_SHA=""

#git branch
BRANCH="v3.7.x-imx"

BUILDREV=1.0
DISTRO=cross
DEBARCH=armel
