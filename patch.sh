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

git_patchset="git://github.com/RobertCNelson/linux.git"
if [ -f ${DIR}/system.sh ] ; then
	source ${DIR}/system.sh
	if [ "${GIT_OVER_HTTP}" ] ; then
		git_patchset="https://github.com/RobertCNelson/linux.git"
	fi
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
	git format-patch -${number} -o ${DIR}/patches/
	exit
}

imx_git () {
	tag="imx_3.0.35_jb4.1.2_1.0.0-beta_wandboard"
	echo "pulling: ${tag}"
	git pull ${GIT_OPTS} ${git_patchset} ${tag}
}

wandboard () {
	echo "dir: wandboard"
	#http://repo.or.cz/w/wandboard.git/shortlog/refs/heads/wandboard
	#git clone --reference /opt/git_repo/linux git://github.com/RobertCNelson/linux.git
	#cd linux
	#git checkout origin/imx_3.0.35_jb4.1.2_1.0.0-beta_wandboard -b tmp
	#git pull --no-edit git://repo.or.cz/wandboard.git wandboard
	#git rebase 699cd64427e41c9331e074fd51b651e548e87de0
	#git format-patch -53 | grep 'Wandboard-Add-support-for-PCI-Express.patch'

	${git} "${DIR}/patches/wandboard/0001-Wandboard-Add-author-s-names-to-the-board-file.patch"
	${git} "${DIR}/patches/wandboard/0002-ENGR00235626-FEC-Enable-phy-pause-frame-feature.patch"
	${git} "${DIR}/patches/wandboard/0003-ENGR00235624-Quad-DualLite-ARD-MTD-partition-non-ali.patch"
	${git} "${DIR}/patches/wandboard/0004-ENGR00236620-Add-fastboot-and-recovery-methods-for-i.patch"
	${git} "${DIR}/patches/wandboard/0005-ENGR00235370-4-pmic-Fix-the-bug-of-pmic-I2C.patch"
	${git} "${DIR}/patches/wandboard/0006-ENGR00235665-mxc_v4l2_capture-add-YV12-format-suppor.patch"
	${git} "${DIR}/patches/wandboard/0007-ENGR00236196-mxc_vout-add-YV12-format-support-in-enu.patch"
	${git} "${DIR}/patches/wandboard/0008-ENGR00236499-ASRC-fix-build-warning.patch"
	${git} "${DIR}/patches/wandboard/0009-ENGR00235817-mx6-use-SNVS-LPGPR-register-to-store-bo.patch"
	${git} "${DIR}/patches/wandboard/0010-ENGR00236020-1-ALSA-add-calling-of-trigger-in-machin.patch"
	${git} "${DIR}/patches/wandboard/0011-ENGR00236827-Enable-MPR121-capacitive-button-driver.patch"
	${git} "${DIR}/patches/wandboard/0012-ENGR00236827-1-Enable-MPR121-capacitive-button-drive.patch"
	${git} "${DIR}/patches/wandboard/0013-gpu-ion-several-bugfixes-and-enhancements-of-ION.patch"
	${git} "${DIR}/patches/wandboard/0014-ENGR00236834-RTC-fix-a-crash-in-mxc_rtc_read_time-wh.patch"
	${git} "${DIR}/patches/wandboard/0015-ENGR00236052-add-keychord-driver-in-android-config.patch"
	${git} "${DIR}/patches/wandboard/0016-ENGR00236512-mmc-esdhc-make-sd3-and-sd2-have-same-pl.patch"
	${git} "${DIR}/patches/wandboard/0017-ENGR00179636-07-i.MX6-Enable-ethernet-NAPI-method-in.patch"
	${git} "${DIR}/patches/wandboard/0018-ENGR00236169-MX6-USB-kfree-udc_controller-when-remov.patch"
	${git} "${DIR}/patches/wandboard/0019-ENGR00235540-add-fbmem-config-for-sabreauto.patch"
	${git} "${DIR}/patches/wandboard/0020-ENGR00235540-1-reserve-mem-for-framebuffer-in-sabrea.patch"
	${git} "${DIR}/patches/wandboard/0021-ENGR00237520-MX6-PCIE-add-flag-to-keep-power-supply.patch"
	${git} "${DIR}/patches/wandboard/0022-ENGR00237520-mx6q_sabresd-Move-power-control-to-pcie.patch"
	${git} "${DIR}/patches/wandboard/0023-ENGR00235370-5-pmic-Fix-the-bug-of-wm8326-pmic.patch"
	${git} "${DIR}/patches/wandboard/0024-ENGR00237868-input-egalax_ts-remove-the-while-loop-f.patch"
	${git} "${DIR}/patches/wandboard/0025-ENGR00237678-IPUv3-Clean-up-sync-and-error-interrupt.patch"
	${git} "${DIR}/patches/wandboard/0026-ENGR00238052-Add-support-for-Android-RAM-console-for.patch"
	${git} "${DIR}/patches/wandboard/0027-ENGR00238053-Fix-the-bug-in-Fuse-read-for-VPU-and-GP.patch"
	${git} "${DIR}/patches/wandboard/0028-ENGR00238201-1-V4L2-ADV7180-enable-adv7180-in-Androi.patch"
	${git} "${DIR}/patches/wandboard/0029-ENGR00238201-2-V4L2-ADV7180-enable-adv7180-in-Androi.patch"
	${git} "${DIR}/patches/wandboard/0030-ENGR00238201-3-V4L2-ADV7180-enable-adv7180-in-Androi.patch"
	${git} "${DIR}/patches/wandboard/0031-ENGR00238276-rfkill-change-rfkill-node-permission.patch"
	${git} "${DIR}/patches/wandboard/0032-ENGR00235540-Change-the-menu-key-to-power-key-for-sa.patch"
	${git} "${DIR}/patches/wandboard/0033-ENGR00237588-Add-PTP-ctrl-request-func.patch"
	${git} "${DIR}/patches/wandboard/0034-ENGR00180079-rfkill-revert-change-rfkill-node-permis.patch"
	${git} "${DIR}/patches/wandboard/0035-ENGR00238357-MX6x-Change-HDMI-default-output-RGB.patch"
	${git} "${DIR}/patches/wandboard/0036-ENGR00238382-MX6-HDMI-Change-VGA-mode-flag-adjust-de.patch"
	${git} "${DIR}/patches/wandboard/0037-ENGR00238384-MX6x-HDMI-Update-HDMI-setting-when-HDMI.patch"
	${git} "${DIR}/patches/wandboard/0038-ENGR00238391-MX6x-HDMI-Add-default-EDID-config-funct.patch"
	${git} "${DIR}/patches/wandboard/0039-ENGR00239187-input-novatek_ts-fix-some-point-not-rel.patch"
	${git} "${DIR}/patches/wandboard/0040-ENGR00238882-yaffs2-fix-yaffs2-build.patch"
	${git} "${DIR}/patches/wandboard/0041-ENGR00238947-GPU-Integrate-Vivante-4.6.9p10-gpu-driv.patch"
	${git} "${DIR}/patches/wandboard/0042-ENGR00240112-1-caam-fix-user-space-crypto-API-suppor.patch"
	${git} "${DIR}/patches/wandboard/0043-ENGR00240112-2-crypto-caam-add-ecb-aes-crypto-algori.patch"
	${git} "${DIR}/patches/wandboard/0044-ENGR00240740-1-IPUv3-Workaround-Android-bootup-ipu-e.patch"
	${git} "${DIR}/patches/wandboard/0045-ENGR00240740-2-ARM-IPUv3-Add-an-interface-to-disable.patch"
	${git} "${DIR}/patches/wandboard/0046-ENGR00240740-3-IPUv3-fb-Workaround-Android-bootup-ip.patch"
	${git} "${DIR}/patches/wandboard/0047-ENGR00239734-Mx6-HDMI-PHY-Add-2-variable-to-pass-boa.patch"
	${git} "${DIR}/patches/wandboard/0048-ENGR00241251-imx6_sabreauto-workaround-touch-screen-.patch"
	${git} "${DIR}/patches/wandboard/0049-ENGR00241251-input-egalax_ts-not-suspend-when-not-ab.patch"
	${git} "${DIR}/patches/wandboard/0050-ENGR00241777-fix-rare-kernel-panic-by-gpu-lowmem-kil.patch"
	${git} "${DIR}/patches/wandboard/0051-ENGR00241962-Add-another-hdmi-switch-for-hdmi-driver.patch"
	${git} "${DIR}/patches/wandboard/0052-fix-a-couple-uninitialized-variables.patch"
	${git} "${DIR}/patches/wandboard/0053-Wandboard-Fix-SDHC-platform-data.patch"
}

arm () {
	echo "dir: arm"
	${git} "${DIR}/patches/arm/0001-deb-disable-header-generation.patch"
}

imx () {
	echo "dir: imx"
}

fixes () {
	echo "dir: fixes"
}

imx_git
wandboard
arm
imx
fixes

echo "patch.sh ran successful"
