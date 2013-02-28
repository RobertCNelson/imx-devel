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
	tag="imx_3.0.35_1.1.0"
	echo "pulling: ${tag}"
	git pull ${GIT_OPTS} ${git_patchset} ${tag}
}

arm () {
	echo "dir: arm"
}

imx () {
	echo "dir: imx"
}

wandboard () {
	echo "dir: wandboard"
	${git} "${DIR}/patches/wandboard/0001-Wandboard-3.0.35-1.1.0-20130208.patch"
}

imx_git
arm
imx
wandboard

echo "patch.sh ran successful"
