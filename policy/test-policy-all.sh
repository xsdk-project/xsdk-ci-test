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
echo "Tests of xsdk installation with the compilers : $COMPILERS"


# Store the tests policy directory
POLICYTESTDIR=$(dirname $0)
echo "Policy test scripts directory : ${POLICYTESTDIR}"

if [ ! -d "$homespace/report" ]; then
    echo "Creation of report repository..."
    mkdir $homespace/report
fi

# For every compilers and every packagesTests policy :
# 1: Run source tests policies
# 2: Run build tests policies
# 3: Run build tests policies

for c in $COMPILERS
do
    for p in $PACKAGES
    do
        if [ ! -d "$homespace/report/$c" ]; then
            mkdir $homespace/report/$c
        fi
        if [ ! -d "$homespace/report/$c/$p" ]; then
            echo "Creation of $homespace/report/$c/$p report repository..."
            mkdir $homespace/report/$c/$p
        fi
        # Run source tests policies
        spack cd -b $p%$c
        PKGSOURCE=$(pwd)
        echo "Source test policy on directory $PKGSOURCE for package $p... "
        echo "Running m1.sh on $i and write report to $homespace/report/$c/$p/report_m1.log..."
        bash $homespace/$POLICYTESTDIR/m1.sh $PKGSOURCE > $homespace/report/$c/$p/report_m1.log
        echo "Running m3.sh on $i and write report to $homespace/report/$c/$p/report_m3.log..."
        bash $homespace/$POLICYTESTDIR/m3.sh $PKGSOURCE > $homespace/report/$c/$p/report_m3.log
        echo "Running m7.sh on $i and write report to $homespace/report/$c/$p/report_m7.log..."
        bash $homespace/$POLICYTESTDIR/m7.sh $PKGSOURCE > $homespace/report/$c/$p/report_m7.log
        # Run build tests policies
        spack cd -s $p%$c
        cd spack-build
        PKGBUILD=$(pwd)
        echo "Running m2.sh on $i and write report to $homespace/report/$c/$p/report_m2.log..."
        bash $homespace/$POLICYTESTDIR/m2.sh $PKGBUILD > $homespace/report/$c/$p/report_m2.log
        spack cd -i $p%$c
        PKGINSTALL=$(pwd)
        echo "Running m13.sh on $i and write report to $homespace/report/$c/$p/report_m13.log..."
        bash $homespace/$POLICYTESTDIR/m13.sh $PKGINSTALL > $homespace/report/$c/$p/report_m13.log
    done
done

cd $homespace
