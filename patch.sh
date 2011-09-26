#!/bin/bash
# Split out, so build_kernel.sh and build_deb.sh can share..

echo "Starting patch.sh"

function git_add {
git add .
git commit -a -m 'testing patchset'
}

function bugs_trivial {
echo "bugs and trivial stuff"
}

function freescale {
echo "from freescale dump..."

git pull git://github.com/RobertCNelson/linux-2.6.git imx_2.6.35_11.05.01

#Causes Serial Corruption Loco Board
git revert --no-edit a52fde5acdec2fef599130246eb037204db38f3e

}

bugs_trivial
freescale

echo "patch.sh ran successful"

