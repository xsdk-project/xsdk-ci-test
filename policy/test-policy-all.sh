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
    bash $homespace/$POLICYTESTDIR/m1.sh $PKG
    bash $homespace/$POLICYTESTDIR/m3.sh $PKG
    bash $homespace/$POLICYTESTDIR/m7.sh $PKG
done

# TESTS ON BUILD
cd $SPACKPATH/var/spack/stage/
for i in "${PACKAGES[@]}"
do
    echo "Build test policy on $i..."
    PKGBUILD=$(ls -t . | grep $i)
    echo "PKGBUILD : $PKGBUILD"
    PKGBUILDPATH=$SPACKPATH/var/spack/stage/$PKGBUILD/spack-build
    ls $SPACKPATH/var/spack/stage
    bash $homespace/$POLICYTESTDIR/m2.sh $PKGBUILDPATH
done

cd $homespace

# TESTS ON INSTALL
echo "Install test policy..."
DISTRIB=$(echo $(cat /etc/*-release | grep DISTRIB_ID) | cut --complement -d "=" -f 1)
DISTRIBPATH=$(ls $SPACKPATH/opt/spack/ | grep ${DISTRIB,,})
for c in $($SPACKPATH/bin/spack compilers | grep @)
do
    cpath=$(echo "$c" | tr @ -)
    echo "install path : $SPACKPATH/opt/spack/$DISTRIBPATH/$cpath"
    cd $SPACKPATH/opt/spack/$DISTRIBPATH/$cpath
    for i in "${PACKAGES[@]}"
    do
        echo "Compiler $cpath: Install test policy on $i..."
        PKGINSTALL=$(ls . | grep $i)
        bash $homespace/$POLICYTESTDIR/m13.sh $PKGINSTALL
    done
done
cd $homespace
