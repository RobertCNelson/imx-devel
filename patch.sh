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

# DIR=`pwd`

echo "Starting patch.sh"

git_add () {
	git add .
	git commit -a -m 'testing patchset'
}

cleanup () {
	git format-patch -1 -o ${DIR}/patches/
	exit
}

bugs_trivial () {
	echo "bugs and trivial stuff"
	git am "${DIR}/patches/trivial/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"
}

mainline_fixes () {
	echo "mainline patches"
	git am "${DIR}/patches/mainline-fixes/0001-arm-add-definition-of-strstr-to-decompress.c.patch"
	git am "${DIR}/patches/omap_fixes/0004-only-call-smp_send_stop-on-SMP.patch"
}

freescale_patch_tree () {
	echo "freescale patch tree"
	#git pull git://github.com/Freescale/linux-mainline.git patches-3.5-rc5

	git am "${DIR}/patches/freescale/0001-usb-chipidea-remove-unneeded-NULL-check.patch"
	git am "${DIR}/patches/freescale/0002-usb-chipidea-drop-useless-arch-check.patch"
	git am "${DIR}/patches/freescale/0003-usb-chipidea-msm-add-missing-section-annotation.patch"
	git am "${DIR}/patches/freescale/0004-usb-chipidea-msm-add-remove-method.patch"
	git am "${DIR}/patches/freescale/0005-USB-Chipidea-rename-struct-ci13xxx_udc_driver-to-str.patch"
	git am "${DIR}/patches/freescale/0006-USB-Chipidea-rename-struct-ci13xxx-variables-from-ud.patch"
	git am "${DIR}/patches/freescale/0007-USB-Chipidea-add-unified-ci13xxx_-add-remove-_device.patch"
	git am "${DIR}/patches/freescale/0008-USB-Chipidea-add-ci13xxx-device-id-management.patch"
	git am "${DIR}/patches/freescale/0009-usb-chipidea-select-USB_EHCI_ROOT_HUB_TT-in-USB_CHIP.patch"
	git am "${DIR}/patches/freescale/0010-mfd-anatop-permit-adata-be-NULL-when-access-register.patch"
	git am "${DIR}/patches/freescale/0011-ARM-imx6q-prepare-and-enable-init-on-clks-directly-i.patch"
	git am "${DIR}/patches/freescale/0012-usb-otg-add-notify_connect-notify_disconnect-callbac.patch"
	git am "${DIR}/patches/freescale/0013-USB-move-transceiver-from-ehci_hcd-and-ohci_hcd-to-h.patch"
	git am "${DIR}/patches/freescale/0014-USB-notify-phy-when-root-hub-port-connect-change.patch"
	git am "${DIR}/patches/freescale/0015-usb-chipidea-permit-driver-bindings-pass-phy-pointer.patch"
	git am "${DIR}/patches/freescale/0016-usb-otg-add-basic-mxs-phy-driver-support.patch"
	git am "${DIR}/patches/freescale/0017-usb-chipidea-add-imx-platform-driver.patch"
	git am "${DIR}/patches/freescale/0018-ARM-imx6q-correct-device-name-of-usbphy-and-usb-cont.patch"
	git am "${DIR}/patches/freescale/0019-ARM-imx6q-add-config-on-boot-gpios.patch"
	git am "${DIR}/patches/freescale/0020-ARM-imx6q-add-usbphy-clocks.patch"
	git am "${DIR}/patches/freescale/0021-ARM-imx6q-disable-usb-charger-detector.patch"
	git am "${DIR}/patches/freescale/0022-ARM-dts-imx6q-sabrelite-add-usb-devices.patch"
	git am "${DIR}/patches/freescale/0023-ARM-mxs-clk_register_clkdev-mx28-usb-clocks.patch"
	git am "${DIR}/patches/freescale/0024-ARM-dts-imx28-evk-add-usb-devices.patch"
	git am "${DIR}/patches/freescale/0025-ARM-mx23-Add-initial-support-for-olinuxino-board.patch"
	git am "${DIR}/patches/freescale/0026-ARM-mxs_defconfig-Let-USB-driver-be-built-by-default.patch"
	git am "${DIR}/patches/freescale/0027-ARM-imx23-olinuxino.dts-Add-USB-support.patch"
	git am "${DIR}/patches/freescale/0028-ARM-imx6q-ensure-regulator-is-available.patch"
	git am "${DIR}/patches/freescale/0029-clk-mxs-Register-USB-clocks-for-mx23.patch"
}

bugs_trivial
mainline_fixes
freescale_patch_tree

echo "patch.sh ran successful"

