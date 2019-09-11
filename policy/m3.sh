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

FILETODISPLAY=""
COUNTER=0
# loop and find mpi occurrence into a folder
count_mpi_occurrence()
{
    for i in "$1"/*;do
        if [ -d "$i" ];then
             count_mpi_occurrence "$i"
        elif [ -f "$i" ]; then
            if grep -q MPI_COMM_WORLD "$i"; then
                echo "The file $i contains at least one occurence of MPI_COMM_WORLD"
                COUNTER=$(( $COUNTER + 1 ))
            fi
        fi
    done
}

# m1 test 3.1: Check if the source code contains any occurence of MPI_COMM_WORLD
count_mpi_occurrence $PKGSOURCE FILETODISPLAY

echo "$COUNTER source code files contain at least one occurence of MPI_COMM_WORLD"
if [ $COUNTER -gt 0 ]; then
    echo "Test 3.1 : Checking MPI_COMM_WORLD is not used in the source code: Failure"
    exit 1
else
    echo "Test 3.1 : Checking MPI_COMM_WORLD is not used in the source code: Succes"
fi
