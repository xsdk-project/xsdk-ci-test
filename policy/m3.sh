#!/bin/bash

# This script aims to test the m3 policy on a package
# The first parameter must be an inner package source

echo "Tests of XSDK m3 policy ..."

PKGSOURCE=$1

# Verify package source
if [ ! -d $PKGSOURCE ]; then
    echo "Source directory isn't detected."
    exit 1
fi

# loop & print a folder recusively,
count_mpi_occurence() {
for i in "$1"/*;do
    if [ -d "$i" ];then
        count_mpi_occurence "$i"
    elif [ -f "$i" ]; then
        if grep -q MPI_COMM_WORLD "$file"; then
            $2=$(($2+1))
        fi
    fi
done
}

# m1 test 3.1: Check if the source code contains any occurence of MPI_COMM_WORLD
counter=0
count_mpi_occurence $PKGSOURCE $counter
#for file in $PKGSOURCE/*
#do
#    if [ -f $file ]; then
#        if grep -q MPI_COMM_WORLD "$file"; then
#            counter=$((counter+1))
#        fi
#    fi
#done

echo "MPI_COMM_WORLD has been found $counter times in the sources code "
if [ $counter -gt 0 ]; then
    echo "Test 3.1 : Checking MPI_COMM_WORLD is not used in the source code: Failure"
else
    echo "Test 3.1 : Checking MPI_COMM_WORLD is not used in the source code: Succes"
fi
