#!/bin/bash

# This script aims to test the m3 policy on a package
# The first parameter must be an inner package source

echo "Tests of XSDK m1 policy ..."

PKGSOURCE=$1

# Verify package source
if [ ! -d $PKGSOURCE ]; then
    echo "Source directory isn't detected."
    exit 1
fi

# m1 test 3.1: Check if the source code contains any occurence of MPI_COMM_WORLD
counter=0
for file in $PKGSOURCE/*
do
    if [ -f $file ]; then
        if grep -q MPI_COMM_WORLD "$file"; then
            counter=$((counter+1))
        fi
    fi
done

echo "MPI_COMM_WORLD has been found $counter times in the sources code "
if counter > 0; then
    echo "Test 3.1 : Checking MPI_COMM_WORLD is not used in the source code: Failure"
fi
else
    echo "Test 3.1 : Checking MPI_COMM_WORLD is not used in the source code: Succes"
fi
