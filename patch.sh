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
	git format-patch -${number} -o ${DIR}/patches/
	exit
}

arm () {
	echo "dir: arm"
	${git} "${DIR}/patches/arm/0001-deb-pkg-Simplify-architecture-matching-for-cross-bui.patch"
}

imx () {
	echo "imx patches"
	${git} "${DIR}/patches/imx/0001-ARM-imx-Enable-UART1-for-Sabrelite.patch"
	${git} "${DIR}/patches/imx/0002-Add-IMX6Q-AHCI-support.patch"
	${git} "${DIR}/patches/imx/0003-imx-Add-IMX53-AHCI-support.patch"
	${git} "${DIR}/patches/imx/0004-cpufreq-add-imx6q-cpufreq-driver.patch"
	${git} "${DIR}/patches/imx/0005-SAUCE-imx6-enable-sata-clk-if-SATA_AHCI_PLATFORM.patch"
}

imx_cpuidle () {
	echo "dir: imx_cpuidle"
	${git} "${DIR}/patches/imx_cpuidle/0001-ARM-mach-imx-Kconfig-Do-not-select-Babbage-for-MACH_.patch"
	${git} "${DIR}/patches/imx_cpuidle/0002-ARM-imx-remove-unused-imx6q_clock_map_io.patch"
	${git} "${DIR}/patches/imx_cpuidle/0003-ARM-imx-use-debug_ll_io_init-for-imx6q.patch"
	${git} "${DIR}/patches/imx_cpuidle/0004-ARM-imx-Remove-mach-mx51_3ds-board.patch"
	${git} "${DIR}/patches/imx_cpuidle/0005-ARM-imx-Remove-mx508-support.patch"
	${git} "${DIR}/patches/imx_cpuidle/0006-ARM-imx-return-zero-in-case-next-event-gets-a-large-.patch"
	${git} "${DIR}/patches/imx_cpuidle/0007-ARM-imx-mask-gpc-interrupts-initially.patch"
	${git} "${DIR}/patches/imx_cpuidle/0008-ARM-imx-move-imx6q_cpuidle_driver-into-a-separate-fi.patch"
	${git} "${DIR}/patches/imx_cpuidle/0009-ARM-imx6q-support-WAIT-mode-using-cpuidle.patch"
}

arm
imx
imx_cpuidle

echo "patch.sh ran successful"
