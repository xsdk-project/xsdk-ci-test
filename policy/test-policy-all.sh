#!/bin/bash

# This script aims to test all policies
# The first parameter must be the spack root path

echo "Tests of XSDK policy"

SPACKPATH=$1

# Verify spack path
if [ ! -d "$SPACKPATH" ]; then
    echo "Spack is not detected."
    exit 1
fi

homespace=$(pwd)

# list of packages
PACKAGES=( phist )

# TESTS ON SOURCE
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

for i in "${PACKAGES[@]}"
do
    echo "Source test policy on $i..."
    tar -xvf $SPACKPATH/var/spack/cache/$i/*
    PKG=$(ls)
    bash /$POLICYTESTDIR/m1.sh $PKG
    bash $POLICYTESTDIR/m3.sh $PKG
    bash $homespace/$POLICYTESTDIR/m7.sh $PKG
done

# TESTS ON BUILD
cd $SPACKPATH/var/spack/stage/
for i in "${PACKAGES[@]}"
do
    echo "Build test policy on $i..."
    PKGBUILD=$(ls . | grep $i)
    bash $homespace/$POLICYTESTDIR/m2.sh $PKGBUILD/spack-build
done

cd $homespace

# TESTS ON INSTALL
DISTRIBPATH=$(ls $SPACKPATH/opt/spack/)
for c in $($SPACKPATH/bin/spack compilers | grep @)
do
    cpath=$(echo "$c" | tr @ -)
    cd $SPACKPATH/opt/spack/$DISTRIBPATH/$cpath
    for i in "${PACKAGES[@]}"
    do
        echo "Compiler $c: Build test policy on $i..."
        PKGINSTALL=$(ls . | grep $i)
        bash $homespace/$POLICYTESTDIR/m13.sh $PKGINSTALL
    done
done
cd $homespace
