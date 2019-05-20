#!/bin/bash

# This script aims to test all policies
# The first parameter must be the spack root path

echo "Tests of XSDK policy"

SPACKPATH=$1

# Verify spack path
if [ ! -d "$SPACKPATH" ]; then
    echo "Spack is not detected."
    return 1
fi

# Create and move to the inner sources directory
XSDKINNERSOURCES=$(pwd)/xsdk-inner-sources
if [ ! -d "$XSDKINNERSOURCES" ]; then
    echo "Creation of xsdk-inner-source..."
    mkdir $XSDKINNERSOURCES
fi
cd $XSDKINNERSOURCES

# Store the tests policy directory
POLICYTESTDIR=$(dirname $0)
echo "Policy test scripts directory : ${POLICYTESTDIR}"

# Tests policy :
# 1: Untar source
# 2: Run source tests policies
# 3: Run build tests policies

PACKAGES=( phist )
for i in "${PACKAGES[@]}"
do
    echo "Test policy on $i..."
    tar -xvf ../../spack/var/spack/cache/$i/*
    PKG=$(ls)
    sh $POLICYTESTDIR/m1.sh $PKG
done
