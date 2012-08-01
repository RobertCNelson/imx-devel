#!/bin/bash -e
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

unset KERNEL_REL
unset STABLE_PATCH
unset RC_KERNEL
unset RC_PATCH
unset BUILD
unset CC
unset LINUX_GIT
unset LATEST_GIT
unset DEBUG_SECTION

unset LOCAL_PATCH_DIR

DIR=$PWD

mkdir -p ${DIR}/deploy/

function git_kernel_torvalds {
	echo "pulling from torvalds kernel.org tree"
	git pull ${GIT_OPTS} git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master --tags || true
}

function git_kernel_stable {
	echo "fetching from stable kernel.org tree"
	git fetch git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git master --tags || true
}

function check_and_or_clone {
	if [ ! "${LINUX_GIT}" ] ; then
		if [ -f "${HOME}/linux-src/.git/config" ] ; then
			echo "Warning: LINUX_GIT not defined in system.sh, using default location: ${HOME}/linux-src"
		else
			echo "Warning: LINUX_GIT not defined in system.sh, cloning torvalds git tree to default location: ${HOME}/linux-src"
			git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git ${HOME}/linux-src
		fi
		LINUX_GIT="${HOME}/linux-src"
	fi
}

function git_kernel {

	check_and_or_clone

	#In the past some users set LINUX_GIT = DIR, fix that...
	if [ -f "${LINUX_GIT}/version.sh" ] ; then
		unset LINUX_GIT
		check_and_or_clone
	fi

	if [ -f "${LINUX_GIT}/.git/config" ] ; then
		cd ${LINUX_GIT}/
		echo "Debug: LINUX_GIT setup..."
		pwd
		cat .git/config
		echo "Updating LINUX_GIT tree via: git fetch"
		git fetch || true
		cd -

		if [ ! -f ${DIR}/KERNEL/.git/config ] ; then
			rm -rf ${DIR}/KERNEL/ || true
			git clone --shared ${LINUX_GIT} ${DIR}/KERNEL
		fi

		cd ${DIR}/KERNEL/
		#So we are now going to assume the worst, and create a new master branch
		git am --abort || echo "git tree is clean..."
		git add .
		git commit --allow-empty -a -m 'empty cleanup commit'

		git checkout origin/master -b tmp-master
		git branch -D master &>/dev/null || true

		git checkout origin/master -b master
		git branch -D tmp-master &>/dev/null || true

		git pull ${GIT_OPTS} || true

		if [ ! "${LATEST_GIT}" ] ; then
			if [ "${RC_PATCH}" ] ; then
				git tag | grep v${RC_KERNEL}${RC_PATCH} &>/dev/null || git_kernel_torvalds
				git branch -D v${RC_KERNEL}${RC_PATCH}-${BUILD} &>/dev/null || true
				git checkout v${RC_KERNEL}${RC_PATCH} -b v${RC_KERNEL}${RC_PATCH}-${BUILD}
			elif [ "${STABLE_PATCH}" ] ; then
				git tag | grep v${KERNEL_REL}.${STABLE_PATCH} &>/dev/null || git_kernel_stable
				git branch -D v${KERNEL_REL}.${STABLE_PATCH}-${BUILD} &>/dev/null || true
				git checkout v${KERNEL_REL}.${STABLE_PATCH} -b v${KERNEL_REL}.${STABLE_PATCH}-${BUILD}
			else
				git tag | grep v${KERNEL_REL} | grep -v rc &>/dev/null || git_kernel_torvalds
				git branch -D v${KERNEL_REL}-${BUILD} &>/dev/null || true
				git checkout v${KERNEL_REL} -b v${KERNEL_REL}-${BUILD}
			fi
		else
			git branch -D top-of-tree &>/dev/null || true
			git checkout v${KERNEL_REL} -b top-of-tree
			git describe
			git pull ${GIT_OPTS} git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master || true
		fi

		git describe

		cd ${DIR}/
	else
		echo ""
		echo "error: failure in git_kernel"
		echo "debug: LINUX_GIT = ${LINUX_GIT}"
		echo ""
		exit
	fi
}

function patch_kernel {
	cd ${DIR}/KERNEL
	export DIR GIT_OPTS
	/bin/bash -e ${DIR}/patch.sh || { git add . ; exit 1 ; }

	git add .
	if [ "${RC_PATCH}" ] ; then
		git commit --allow-empty -a -m ''$RC_KERNEL''$RC_PATCH'-'$BUILD' patchset'
	elif [ "${STABLE_PATCH}" ] ; then
		git commit --allow-empty -a -m ''$KERNEL_REL'.'$STABLE_PATCH'-'$BUILD' patchset'
	else
		git commit --allow-empty -a -m ''$KERNEL_REL'-'$BUILD' patchset'
	fi

#Test Patches:
#exit

	if [ "${LOCAL_PATCH_DIR}" ] ; then
		for i in ${LOCAL_PATCH_DIR}/*.patch ; do patch  -s -p1 < $i ; done
		BUILD+='+'
	fi

	cd ${DIR}/
}

function copy_defconfig {
  cd ${DIR}/KERNEL/
  make ARCH=arm CROSS_COMPILE=${CC} distclean
  make ARCH=arm CROSS_COMPILE=${CC} ${config}
  cp -v .config ${DIR}/patches/ref_${config}
  cp -v ${DIR}/patches/defconfig .config
  cd ${DIR}/
}

function make_menuconfig {
  cd ${DIR}/KERNEL/
  make ARCH=arm CROSS_COMPILE=${CC} menuconfig
  cp -v .config ${DIR}/patches/defconfig
  cd ${DIR}/
}

function make_kernel {
	cd ${DIR}/KERNEL/
	echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CCACHE} ${CC}\" ${CONFIG_DEBUG_SECTION} zImage modules"
	time make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CCACHE} ${CC}" ${CONFIG_DEBUG_SECTION} zImage modules

	echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CCACHE} ${CC}\" ${CONFIG_DEBUG_SECTION} dtbs"
	time make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CCACHE} ${CC}" ${CONFIG_DEBUG_SECTION} dtbs

	KERNEL_UTS=$(cat ${DIR}/KERNEL/include/generated/utsrelease.h | awk '{print $3}' | sed 's/\"//g' )
	if [ -f ./arch/arm/boot/zImage ] ; then
		cp arch/arm/boot/zImage ${DIR}/deploy/${KERNEL_UTS}.zImage
		cp .config ${DIR}/deploy/${KERNEL_UTS}.config
	else
		echo "Error: make zImage modules failed"
		exit
	fi
	cd ${DIR}/
}

function make_uImage {
	cd ${DIR}/KERNEL/
	echo "make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE=\"${CCACHE} ${CC}\" ${CONFIG_DEBUG_SECTION} uImage"
	time make -j${CORES} ARCH=arm LOCALVERSION=-${BUILD} CROSS_COMPILE="${CCACHE} ${CC}" ${CONFIG_DEBUG_SECTION} uImage
	KERNEL_UTS=$(cat ${DIR}/KERNEL/include/generated/utsrelease.h | awk '{print $3}' | sed 's/\"//g' )
	if [ -f ./arch/arm/boot/uImage ] ; then
		cp arch/arm/boot/uImage ${DIR}/deploy/${KERNEL_UTS}.uImage
	else
		echo "Error: make uImage failed"
		exit
	fi
	cd ${DIR}/
}

function make_modules_pkg {
  cd ${DIR}/KERNEL/

  echo ""
  echo "Building Module Archive"
  echo ""

  rm -rf ${DIR}/deploy/mod &> /dev/null || true
  mkdir -p ${DIR}/deploy/mod
  make ARCH=arm CROSS_COMPILE=${CC} modules_install INSTALL_MOD_PATH=${DIR}/deploy/mod
  echo "Building ${KERNEL_UTS}-modules.tar.gz"
  cd ${DIR}/deploy/mod
  tar czf ../${KERNEL_UTS}-modules.tar.gz *
  cd ${DIR}/
}

function make_headers_pkg {
  cd ${DIR}/KERNEL/

  echo ""
  echo "Building Header Archive"
  echo ""

  rm -rf ${DIR}/deploy/headers &> /dev/null || true
  mkdir -p ${DIR}/deploy/headers/usr
  make ARCH=arm CROSS_COMPILE=${CC} headers_install INSTALL_HDR_PATH=${DIR}/deploy/headers/usr
  cd ${DIR}/deploy/headers
  echo "Building ${KERNEL_UTS}-headers.tar.gz"
  tar czf ../${KERNEL_UTS}-headers.tar.gz *
  cd ${DIR}/
}

  /bin/bash -e ${DIR}/tools/host_det.sh || { exit 1 ; }

if [ -e ${DIR}/system.sh ] ; then
	source ${DIR}/system.sh
	source ${DIR}/version.sh

	GCC="gcc"
	if [ "x${GCC_OVERRIDE}" != "x" ] ; then
		GCC="${GCC_OVERRIDE}"
	fi
	echo ""
	echo "Debug: using $(LC_ALL=C ${CC}${GCC} --version)"
	echo ""

	if [ "${LATEST_GIT}" ] ; then
		echo ""
		echo "Warning LATEST_GIT is enabled from system.sh I hope you know what your doing.."
		echo ""
	fi

	unset CONFIG_DEBUG_SECTION
	if [ "${DEBUG_SECTION}" ] ; then
		CONFIG_DEBUG_SECTION="CONFIG_DEBUG_SECTION_MISMATCH=y"
	fi

#	git_kernel
#	patch_kernel
#	copy_defconfig
	make_menuconfig
	if [ "x${GCC_OVERRIDE}" != "x" ] ; then
		sed -i -e 's:CROSS_COMPILE)gcc:CROSS_COMPILE)'$GCC_OVERRIDE':g' ${DIR}/KERNEL/Makefile
	fi
	make_kernel
	if [ "${BUILD_UIMAGE}" ] ; then
		make_uImage
	else
		echo ""
		echo "NOTE: enable BUILD_UIMAGE variables in system.sh to build uImage's"
		echo ""
	fi
	make_modules_pkg
#	make_headers_pkg
	if [ "x${GCC_OVERRIDE}" != "x" ] ; then
		sed -i -e 's:CROSS_COMPILE)'$GCC_OVERRIDE':CROSS_COMPILE)gcc:g' ${DIR}/KERNEL/Makefile
	fi
else
	echo ""
	echo "ERROR: Missing (your system) specific system.sh, please copy system.sh.sample to system.sh and edit as needed."
	echo ""
	echo "example: cp system.sh.sample system.sh"
	echo "example: gedit system.sh"
	echo ""
fi
