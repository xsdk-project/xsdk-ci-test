#!/bin/bash

# This script aims to test the m1 policy on a package
# The first parameter must be an inner package source

echo "Tests of XSDK m1 policy ..."

PKGSOURCE=$1

# Verify package source
if [ ! -d $PKGSOURCE ]; then
    echo "Source directory isn't detected."
    exit 1
fi

RESULT=0
# m1 test 1.1: Check CMakeLists file existence
if [ ! -f $PKGSOURCE/CMakeLists.txt ]; then
    echo "Test 1.1 : Checking if a CMakeLists.txt exists: Failure"
    RESULT=1
else
    echo "Test 1.1 : Checking if a CMakeLists.txt exists: Succes"
    RESULT=0
fi

# m1 test 1.2: Check configure file existence
if [ ! -f $PKGSOURCE/configure ]; then
    echo "Test 1.2 : Checking if a configure exists: Failure"
    RESULT=1
else
    echo "Test 1.2 : Checking if a configure exists: Succes"
    RESULT=0
fi

exit $RESULT
