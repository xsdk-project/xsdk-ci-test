#!/bin/bash

# This script aims to test the m13 policy on a package
# The first parameter must be an inner package source

echo "Tests of XSDK m13 policy ..."

PKGINSTALL=$1

result=0

# Verify package source
if [ ! -d $PKGINSTALL ]; then
    echo "Source directory isn't detected."
    exit 1
fi

if [ ! -d $PKGINSTALL/include ]; then
    echo "Test 13.1 : Checking if the include directory exists: Failure"
    $result=1
else
    echo "Test 13.1 : Checking if the include directory exists: Succes"
fi

if [ ! -d $PKGINSTALL/lib ]; then
    echo "Test 13.2 : Checking if the lib directory exists: Failure"
    $result=1
else
    echo "Test 13.2 : Checking if the lib directory exists: Succes"
fi

exit $result
