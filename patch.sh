#!/bin/sh -e
#
# Copyright (c) 2009-2016 Robert Nelson <robertcnelson@gmail.com>
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

. ${DIR}/version.sh
if [ -f ${DIR}/system.sh ] ; then
	. ${DIR}/system.sh
fi

#Debian 7 (Wheezy): git version 1.7.10.4 and later needs "--no-edit"
unset git_opts
git_no_edit=$(LC_ALL=C git help pull | grep -m 1 -e "--no-edit" || true)
if [ ! "x${git_no_edit}" = "x" ] ; then
	git_opts="--no-edit"
fi

git="git am"
git_patchset=""
#git_opts

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
		if [ "x${wdir}" = "x" ] ; then
			git format-patch -${number} -o ${DIR}/patches/
		else
			git format-patch -${number} -o ${DIR}/patches/${wdir}/
			unset wdir
		fi
	fi
	exit 2
}

cherrypick () {
	if [ ! -d ../patches/${cherrypick_dir} ] ; then
		mkdir -p ../patches/${cherrypick_dir}
	fi
	git format-patch -1 ${SHA} --start-number ${num} -o ../patches/${cherrypick_dir}
	num=$(($num+1))
}

external_git () {
	git_tag=""
	echo "pulling: ${git_tag}"
	git pull ${git_opts} ${git_patchset} ${git_tag}
}

local_patch () {
	echo "dir: dir"
	${git} "${DIR}/patches/dir/0001-patch.patch"
}

#external_git
#local_patch

wand () {
	echo "dir: wand"
	#${git} "${DIR}/patches/wand/0001-ARM-i.MX6-Wandboard-add-wifi-bt-rfkill-driver.patch"
	#${git} "${DIR}/patches/wand/0002-ARM-dts-wandboard-add-binding-for-wand-rfkill-driver.patch"
	${git} "${DIR}/patches/wand/0003-Vivante-v4-driver.patch"
}

freescale () {
	echo "dir: freescale/ipu-v3"
	${git} "${DIR}/patches/freescale/ipu-v3/0001-gpu-ipu-v3-Add-ipu-cpmem-unit.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0002-staging-imx-drm-Convert-to-new-ipu_cpmem-API.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0003-gpu-ipu-v3-Add-functions-to-set-CSI-IC-source-muxes.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0004-gpu-ipu-v3-Rename-and-add-IDMAC-channels.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0005-gpu-ipu-v3-Add-Camera-Sensor-Interface-unit.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0006-gpu-ipu-v3-Add-Image-Converter-unit.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0007-gpu-ipu-v3-smfc-Move-enable-disable-to-ipu-smfc.c.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0008-gpu-ipu-v3-smfc-Convert-to-per-channel.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0009-gpu-ipu-v3-smfc-Add-ipu_smfc_set_watermark.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0010-gpu-ipu-v3-Add-ipu_mbus_code_to_colorspace.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0011-gpu-ipu-v3-Add-rotation-mode-conversion-utilities.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0012-gpu-ipu-v3-Add-helper-function-checking-if-pixfmt-is.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0013-gpu-ipu-v3-Move-IDMAC-channel-names-to-imx-ipu-v3.h.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0014-gpu-ipu-v3-Add-ipu_idmac_buffer_is_ready.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0015-gpu-ipu-v3-Add-ipu_idmac_clear_buffer.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0016-gpu-ipu-v3-Add-__ipu_idmac_reset_current_buffer.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0017-gpu-ipu-v3-Add-ipu_stride_to_bytes.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0018-gpu-ipu-v3-Add-ipu_idmac_enable_watermark.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0019-gpu-ipu-v3-Add-ipu_idmac_lock_enable.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0020-gpu-ipu-cpmem-Add-ipu_cpmem_set_block_mode.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0021-gpu-ipu-cpmem-Add-ipu_cpmem_set_axi_id.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0022-gpu-ipu-cpmem-Add-ipu_cpmem_set_rotation.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0023-gpu-ipu-cpmem-Add-second-buffer-support-to-ipu_cpmem.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0024-gpu-ipu-v3-Add-more-planar-formats-support.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0025-gpu-ipu-cpmem-Add-ipu_cpmem_dump.patch"
	${git} "${DIR}/patches/freescale/ipu-v3/0026-gpu-ipu-v3-Add-ipu_dump.patch"
}

wand
freescale

packaging_setup () {
	cp -v "${DIR}/3rdparty/packaging/builddeb" "${DIR}/KERNEL/scripts/package"
	git commit -a -m 'packaging: sync with mainline' -s

	git format-patch -1 -o "${DIR}/patches/packaging"
}

packaging () {
	echo "dir: packaging"
	#${git} "${DIR}/patches/packaging/0001-packaging-sync-with-mainline.patch"
	${git} "${DIR}/patches/packaging/0002-deb-pkg-install-dtbs-in-linux-image-package.patch"
	#${git} "${DIR}/patches/packaging/0003-deb-pkg-no-dtbs_install.patch"
}

#packaging_setup
packaging
echo "patch.sh ran successfully"
