#!/bin/bash
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
	git format-patch -${number} -o ${DIR}/patches/
	exit
}

arm () {
	echo "dir: arm"
	${git} "${DIR}/patches/arm/0001-deb-pkg-Simplify-architecture-matching-for-cross-bui.patch"
}

imx () {
	echo "dir: imx"
	${git} "${DIR}/patches/imx/0001-ARM-imx-Enable-UART1-for-Sabrelite.patch"
	${git} "${DIR}/patches/imx/0002-Add-IMX6Q-AHCI-support.patch"
	${git} "${DIR}/patches/imx/0003-imx-Add-IMX53-AHCI-support.patch"
	${git} "${DIR}/patches/imx/0005-SAUCE-imx6-enable-sata-clk-if-SATA_AHCI_PLATFORM.patch"
#	${git} "${DIR}/patches/imx/0005-staging-imx-drm-request-irq-only-after-adding-the-cr.patch"
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
}

arm
imx
chipidea

echo "patch.sh ran successful"
