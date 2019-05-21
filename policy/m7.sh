#!/bin/bash

# This script aims to test the m7 policy on a package
# The first parameter must be an inner package source

echo "Tests of XSDK m7 policy ..."

PKGSOURCE=$1

# Verify package source
if [ ! -d "$PKGSOURCE" ]; then
    echo "Source directory isn't detected."
    exit 1
fi

# m7 test 7.1: Check Licence file existence
if [ ! -f $PKGSOURCE/LICENSE* ]; then
    echo "Test 7.1 : Checking if the Licence exists: Failure"
    exit 1
else
    echo "Test 7.1 : Checking if the Licence exists: Succes"
fi

# m7 test 7.2: Check Licence file is empty
if [ ! -s $PKGSOURCE/LICENSE* ]; then
    echo "Test 7.2 : Checking Licence file isn't empty: Failure"
    exit 1
else
    echo "Test 7.2 : Checking Licence file isn't empty: Succes"
fi
