#!/bin/sh
#
# Copyright (c) 2009-2013 Robert Nelson <robertcnelson@gmail.com>
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

if [ -f ${DIR}/system.sh ] ; then
	. ${DIR}/system.sh
fi

if [ "${RUN_BISECT}" ] ; then
	git="git apply"
fi

echo "Starting patch.sh"

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

start_cleanup () {
	git="git am --whitespace=fix"
}

cleanup () {
	if [ "${number}" ] ; then
		git format-patch -${number} -o ${DIR}/patches/
	fi
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
	#Status: pulled from next v3.7-rc:
	#From: http://cgit.freedesktop.org/~airlied/linux/log/?h=drm-next
	${git} "${DIR}/patches/drm/0001-DRM-Add-DRM-GEM-CMA-helper.patch"
	${git} "${DIR}/patches/drm/0002-DRM-Add-DRM-KMS-FB-CMA-helper.patch"

	#Status: maybe for v3.7-rc?
	#From: https://patchwork.kernel.org/patch/1361511/
	${git} "${DIR}/patches/drm/0003-ARM-export-set_irq_flags-irq_set_chip_and_handler.patch"

	#Status: in staging for v3.7-rc
	#From: http://git.kernel.org/?p=linux/kernel/git/gregkh/staging.git;a=summary
	${git} "${DIR}/patches/drm_imx/0001-staging-drm-imx-Add-i.MX-drm-core-support.patch"
	${git} "${DIR}/patches/drm_imx/0002-staging-drm-imx-Add-parallel-display-support.patch"
	${git} "${DIR}/patches/drm_imx/0003-staging-drm-imx-add-i.MX-IPUv3-base-driver.patch"
	${git} "${DIR}/patches/drm_imx/0004-staging-drm-imx-Add-i.MX-IPUv3-crtc-support.patch"
	${git} "${DIR}/patches/drm_imx/0005-staging-drm-imx-Add-devicetree-binding-documentation.patch"
	${git} "${DIR}/patches/drm_imx/0006-staging-drm-imx-Add-TODO.patch"

	#Status: Cherry Picked from:
	#http://git.pengutronix.de/?p=imx/linux-2.6.git;a=shortlog;h=refs/heads/work/gpu/imx-drm-ipu-complete-rebase
	${git} "${DIR}/patches/drm_imx/0007-ARM-i.MX51-babbage-Add-IPU-support.patch"
	${git} "${DIR}/patches/drm_imx/0008-ARM-i.MX53-LOCO-Add-IPU-support.patch"
	${git} "${DIR}/patches/drm_imx/0009-ARM-i.MX51-setup-mipi.patch"
	${git} "${DIR}/patches/drm_imx/0010-ARM-i.MX5-initialize-m4if-interface.patch"
	${git} "${DIR}/patches/drm_imx/0011-ARM-i.MX5-Hard-reset-the-IPU-during-startup.patch"
	${git} "${DIR}/patches/drm_imx/0012-clk-add-a-__clk_set_flags-function.patch"
	${git} "${DIR}/patches/drm_imx/0013-ARM-i.MX53-clk-Fix-ldb-parent-clocks.patch"
	${git} "${DIR}/patches/drm_imx/0014-ARM-i.MX5-IPU-clk-support.patch"
	${git} "${DIR}/patches/drm_imx/0015-ARM-i.MX6-Add-IPU-device-support.patch"
	${git} "${DIR}/patches/drm_imx/0016-ARM-i.MX6-clk-initialize-some-video-clocks.patch"
	${git} "${DIR}/patches/drm_imx/0017-DRM-allow-create-map-destroy-dumb-buffer-ioctls-for-.patch"
	${git} "${DIR}/patches/drm_imx/0018-ARM-i.MX53-Fix-IPU-clk.patch"
	${git} "${DIR}/patches/drm_imx/0019-of-Add-videomode-helper.patch"
}

bugs_trivial
mainline_fixes
#freescale_patch_tree
#drm

echo "patch.sh ran successful"
