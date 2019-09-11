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
    PKGSOURCE=$(ls)
    echo "Source test policy on directory $PKGSOURCE for package $i... "
    tar -xf $SPACKPATH/var/spack/cache/$i/*
    echo "Running m1.sh on $i..."
    bash $homespace/$POLICYTESTDIR/m1.sh $PKGSOURCE > $homespace/report/$i/report_m1.txt
    echo "Running m3.sh on $i..."
    bash $homespace/$POLICYTESTDIR/m3.sh $PKGSOURCE > $homespace/report/$i/report_m3.txt
    echo "Running m7.sh on $i..."
    bash $homespace/$POLICYTESTDIR/m7.sh $PKGSOURCE > $homespace/report/$i/report_m7.txt
done

# TESTS ON BUILD
cd $SPACKPATH/var/spack/stage/
for i in "${PACKAGES[@]}"
do
    PKGBUILD=$(ls -t . | grep $i)
    echo "Build test policy on directory $PKGBUILD for package $i... "
    PKGBUILDPATH=$SPACKPATH/var/spack/stage/$PKGBUILD/spack-build
    echo "Running m2.sh on $i..."
    bash $homespace/$POLICYTESTDIR/m2.sh $PKGBUILDPATH > $homespace/$i/report_m2.txt
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
        echo "Running m13.sh on $i..."
        bash $homespace/$POLICYTESTDIR/m13.sh $PKGINSTALL > $homespace/$i/report_m13.txt
    done
done
cd $homespace
