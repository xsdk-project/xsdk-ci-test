#!/bin/bash

# This script aims to test the m2 policy on a package
# The first parameter must be an inner package build

echo "Tests of XSDK m2 policy ..."

PKGBUILD=$1

# Verify package source
if [ ! -d $PKGBUILD ]; then
    echo "Source directory isn't detected."
exit 1
fi

# m1 test 1: Check CMakeLists file existence
CCURENTDIR=$PWD
cd $PKGBUILD
make test
result = $?
cd $PWD
exit $result
