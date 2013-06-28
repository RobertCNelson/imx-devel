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
	git format-patch -${number} -o ${DIR}/patches/
	exit
}

arm () {
	echo "dir: arm"
	${git} "${DIR}/patches/arm/0001-deb-pkg-Simplify-architecture-matching-for-cross-bui.patch"
}

gpu () {
	echo "dir: gpu"
	${git} "${DIR}/patches/gpu/0001-ARM-i.MX5-Move-IPU-clock-lookups-into-device-tree.patch"
	${git} "${DIR}/patches/gpu/0002-ARM-i.MX-Add-imx_clk_divider_flags-and-imx_clk_mux_f.patch"
	${git} "${DIR}/patches/gpu/0003-ARM-i.MX5-Remove-tve_sel-clock-from-i.MX53-clock-tre.patch"
	${git} "${DIR}/patches/gpu/0004-ARM-i.MX53-Remove-unused-tve_gate-clkdev-entry.patch"
	${git} "${DIR}/patches/gpu/0005-ARM-i.MX53-make-tve_ext_sel-propagate-rate-change-to.patch"
	${git} "${DIR}/patches/gpu/0006-ARM-i.MX53-tve_di-clock-is-not-part-of-the-CCM-but-o.patch"
	${git} "${DIR}/patches/gpu/0007-ARM-i.MX53-set-CLK_SET_RATE_PARENT-flag-on-the-tve_e.patch"
	${git} "${DIR}/patches/gpu/0008-ARM-i.MX53-Add-TVE-entry-to-i.MX53-dtsi.patch"
	${git} "${DIR}/patches/gpu/0009-ARM-i.MX53-dts-Add-TVE-to-i.MX53-QSB-device-tree.patch"
	${git} "${DIR}/patches/gpu/0010-staging-drm-imx-ipu-dc-add-24-bit-GBR-support-to-DC.patch"
	${git} "${DIR}/patches/gpu/0011-staging-drm-imx-ipuv3-crtc-use-external-clock-for-TV.patch"
	${git} "${DIR}/patches/gpu/0012-staging-drm-imx-ipu-di-add-comments-explaining-signa.patch"
	${git} "${DIR}/patches/gpu/0013-staging-drm-imx-Add-support-for-VGA-via-TVE-on-i.MX5.patch"
	${git} "${DIR}/patches/gpu/0014-staging-drm-imx-ipu-dc-add-WCLK-WRG-opcodes.patch"
	${git} "${DIR}/patches/gpu/0015-staging-drm-imx-ipu-dc-force-black-output-during-bla.patch"
	${git} "${DIR}/patches/gpu/0016-staging-drm-imx-Add-support-for-Television-Encoder-T.patch"
}

imx () {
	echo "dir: imx"
	${git} "${DIR}/patches/imx/0001-ARM-imx-Enable-UART1-for-Sabrelite.patch"
	${git} "${DIR}/patches/imx/0002-Add-IMX6Q-AHCI-support.patch"
	${git} "${DIR}/patches/imx/0003-imx-Add-IMX53-AHCI-support.patch"
	${git} "${DIR}/patches/imx/0005-SAUCE-imx6-enable-sata-clk-if-SATA_AHCI_PLATFORM.patch"
#	${git} "${DIR}/patches/imx/0005-staging-imx-drm-request-irq-only-after-adding-the-cr.patch"
	${git} "${DIR}/patches/imx/0006-arm-fec-use-random-mac-when-everything-else-fails.patch"
#	${git} "${DIR}/patches/imx/0007-imx-add-imx6q-Nitrogen6X.dts-as-a-clone-of-imx6q-sab.patch"
	${git} "${DIR}/patches/imx/0008-imx6q-restart-fix.patch"
}

chipidea () {
	echo "dir: chipidea"
	${git} "${DIR}/patches/chipidea/0001-USB-move-bulk-of-otg-otg.c-to-phy-phy.c.patch"
	${git} "${DIR}/patches/chipidea/0002-USB-add-devicetree-helpers-for-determining-dr_mode-a.patch"
	${git} "${DIR}/patches/chipidea/0003-USB-chipidea-ci13xxx-imx-create-dynamic-platformdata.patch"
	${git} "${DIR}/patches/chipidea/0004-USB-chipidea-add-PTW-and-PTS-handling.patch"
	${git} "${DIR}/patches/chipidea/0005-USB-chipidea-introduce-dual-role-mode-pdata-flags.patch"
	${git} "${DIR}/patches/chipidea/0006-USB-chipidea-i.MX-introduce-dr_mode-property.patch"
	${git} "${DIR}/patches/chipidea/0007-USB-mxs-phy-Register-phy-with-framework.patch"
	${git} "${DIR}/patches/chipidea/0008-USB-chipidea-i.MX-use-devm_usb_get_phy_by_phandle-to.patch"
	${git} "${DIR}/patches/chipidea/0009-Revert-USB-chipidea-add-vbus-detect-for-udc.patch"
	${git} "${DIR}/patches/chipidea/0010-usb-chipidea-add-otg-file.patch"
	${git} "${DIR}/patches/chipidea/0011-usb-chipidea-add-otg-id-switch-and-vbus-connect-disc.patch"
	${git} "${DIR}/patches/chipidea/0012-usb-chipidea-udc-add-pullup-pulldown-dp-at-hw_device.patch"
	${git} "${DIR}/patches/chipidea/0013-usb-chipidea-udc-retire-the-flag-CI13_PULLUP_ON_VBUS.patch"
	${git} "${DIR}/patches/chipidea/0014-usb-chipidea-add-vbus-regulator-control.patch"
	${git} "${DIR}/patches/chipidea/0015-usb-chipidea-delete-the-delayed-work.patch"
	${git} "${DIR}/patches/chipidea/0016-usb-chipidea-imx-add-getting-vbus-regulator-code.patch"
	${git} "${DIR}/patches/chipidea/0017-usb-chipidea-udc-fix-the-oops-when-plugs-in-usb-cabl.patch"
	${git} "${DIR}/patches/chipidea/0018-usb-chipidea-imx-select-usb-id-pin-using-syscon-inte.patch"
	${git} "${DIR}/patches/chipidea/0019-usb-chipidea-usbmisc-rename-file-struct-and-function.patch"
	${git} "${DIR}/patches/chipidea/0020-usb-chipidea-usbmisc-unset-global-varibale-usbmisc-o.patch"
	${git} "${DIR}/patches/chipidea/0021-usb-chipidea-usbmisc-fix-a-potential-race-condition.patch"
	${git} "${DIR}/patches/chipidea/0022-usb-chipidea-usbmisc-prepare-driver-to-handle-more-t.patch"
	${git} "${DIR}/patches/chipidea/0023-usb-chipidea-usbmisc-add-mx53-support.patch"
	${git} "${DIR}/patches/chipidea/0024-usb-chipidea-usbmisc-add-post-handling-and-errata-fi.patch"
	${git} "${DIR}/patches/chipidea/0025-usb-chipidea-imx-Add-system-suspend-resume-API.patch"
	${git} "${DIR}/patches/chipidea/0026-ARM-dts-imx-add-imx5x-usbmisc-entries.patch"
	${git} "${DIR}/patches/chipidea/0027-ARM-dts-imx-add-imx5x-usb-clock-DT-lookups.patch"
	${git} "${DIR}/patches/chipidea/0028-ARM-dts-imx-use-usb-nop-xceiv-usbphy-entries-for-imx.patch"
	${git} "${DIR}/patches/chipidea/0029-ARM-dts-imx-imx53-qsb.dts-enable-usbotg-and-usbh1.patch"
}

saucy () {
	echo "dir: saucy"
	${git} "${DIR}/patches/saucy/0001-saucy-disable-stack-protector.patch"
}

arm
#gpu
imx
chipidea
saucy

echo "patch.sh ran successful"
