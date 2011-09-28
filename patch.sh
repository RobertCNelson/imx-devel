#!/bin/bash
# Split out, so build_kernel.sh and build_deb.sh can share..

echo "Starting patch.sh"

function git_add {
git add .
git commit -a -m 'testing patchset'
}

function bugs_trivial {
echo "bugs and trivial stuff"
patch -s -p1 < "${DIR}/patches/trivial/0001-kbuild-deb-pkg-set-host-machine-after-dpkg-gencontro.patch"
}

function freescale {
echo "from freescale dump..."
patch -p1 -s < "${DIR}/patches/freescale/0001-arm-imx-freescale-2.6.35.3-imx_11.01.00.patch"

}

function imx_sata {
echo "sata support"
git pull git://github.com/RobertCNelson/linux.git imx_mx53_sata_v3.1-rc8
}

bugs_trivial
#freescale
imx_sata

echo "patch.sh ran successful"

