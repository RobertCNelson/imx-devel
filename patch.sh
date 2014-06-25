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

git_patchset="git://git.freescale.com/imx/linux-2.6-imx.git"

if [ -f ${DIR}/system.sh ] ; then
	. ${DIR}/system.sh
fi

. ${DIR}/version.sh

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

imx_git () {
	tag="imx_3.0.35_1.1.0"
	echo "pulling: ${tag}"
	git pull ${GIT_OPTS} ${git_patchset} ${tag}
}

rex () {
	echo "dir: rex"
	${git} "${DIR}/patches/rex/0001-3.0.35-mega-rex.patch"
}

arm () {
	echo "dir: arm"
}

imx () {
	echo "dir: imx"
}

fixes () {
	echo "dir: fixes"
}

saucy () {
	echo "dir: saucy"
#	${git} "${DIR}/patches/saucy/0001-saucy-disable-Werror-pointer-sign.patch"
#	${git} "${DIR}/patches/saucy/0002-saucy-disable-stack-protector.patch"
}

imx_git
rex
arm
imx
fixes
saucy

echo "patch.sh ran successful"
