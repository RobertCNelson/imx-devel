#!/bin/bash
#
# Copyright (c) 2009-2012 Robert Nelson <robertcnelson@gmail.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

# Split out, so build_kernel.sh and build_deb.sh can share..

git="git am"
#git="git am --whitespace=fix"

if [ -f ${DIR}/system.sh ] ; then
	source ${DIR}/system.sh
fi

if [ "${RUN_BISECT}" ] ; then
	git="git apply"
fi

echo "Starting patch.sh"

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

cleanup () {
	git format-patch -7 -o ${DIR}/patches/
	exit
}

bugs_trivial () {
	echo "bugs and trivial stuff"
	${git} "${DIR}/patches/trivial/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"
}

mainline_fixes () {
	echo "mainline patches"
	${git} "${DIR}/patches/mainline-fixes/0001-arm-add-definition-of-strstr-to-decompress.c.patch"
}

freescale_patch_tree () {
	echo "freescale patch tree"
	#git pull git://github.com/Freescale/linux-mainline.git patches-3.5-rc5
}

drm () {
	echo "drm"
	${git} "${DIR}/patches/drm/0001-DRM-Add-DRM-kms-fb-cma-helper.patch"
	${git} "${DIR}/patches/drm/0002-staging-drm-imx-Add-i.MX-drm-core-support.patch"
	${git} "${DIR}/patches/drm/0003-staging-drm-imx-Add-parallel-display-support.patch"
	${git} "${DIR}/patches/drm/0004-staging-drm-imx-add-i.MX-IPUv3-base-driver.patch"
	${git} "${DIR}/patches/drm/0005-staging-drm-imx-Add-i.MX-IPUv3-crtc-support.patch"
	${git} "${DIR}/patches/drm/0006-staging-drm-imx-Add-devicetree-binding-documentation.patch"
	${git} "${DIR}/patches/drm/0007-staging-drm-imx-Add-TODO.patch"
}

bugs_trivial
mainline_fixes
#freescale_patch_tree
drm

echo "patch.sh ran successful"

