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
PACKAGES=( $2 )
PACKAGES="${PACKAGES[@]}"
echo "Tests of xsdk policy for the packages : $PACKAGES"

# list of compilers
COMPILERS=( $3 )
if [ -z "$COMPILERS" ]; then
   COMPILERS=$($SPACKEXEPATH compilers | grep @)
else
   COMPILERS="${COMPILERS[@]}"
fi
echo "Tests of xsdk installation with the compilers : $COMPILERS"


# Store the tests policy directory
POLICYTESTDIR=$(dirname $0)
echo "Policy test scripts directory : ${POLICYTESTDIR}"

if [ ! -d "$homespace/report" ]; then
    echo "Creation of report repository..."
    mkdir $homespace/report
fi

# Tests policy :
# 1: Untar source
# 2: Run source tests policies
# 3: Run build tests policies

for c in $COMPILERS
do
    for i in $PACKAGES
    do
        spack cd -s $i%$c
        echo "Source test policy on directory $PKGSOURCE for package $i... "
        tar -xf $SPACKPATH/var/spack/cache/$i/*
        if [ ! -d "$homespace/report/$i" ]; then
            echo "Creation of $i report repository..."
            mkdir $homespace/report/$i
        fi
        echo "Running m1.sh on $i..."
        bash $homespace/$POLICYTESTDIR/m1.sh $PKGSOURCE > $homespace/report/$i/report_m1.log
        echo "Running m3.sh on $i..."
        bash $homespace/$POLICYTESTDIR/m3.sh $PKGSOURCE > $homespace/report/$i/report_m3.log
        echo "Running m7.sh on $i..."
        bash $homespace/$POLICYTESTDIR/m7.sh $PKGSOURCE > $homespace/report/$i/report_m7.log
    done
done
