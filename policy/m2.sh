#!/bin/bash

# This script aims to test the m2 policy on a package
# The first parameter must be an inner package build

echo "Tests of XSDK m2 policy ..."

PKGBUILD=$1

# Verify package source
if [ ! -d $PKGBUILD ]; then
    echo "build directory isn't detected."
exit 1
fi

# m2 test 1: Run make test
echo "Test 2.1 : Running make test on $PKGBUILD..."
CURRENTDIR=$PWD
cd $PKGBUILD
make test
result=$?
cd $CURRENTDIR
exit $result
