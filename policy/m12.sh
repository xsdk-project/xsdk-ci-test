#!/bin/bash

# This script aims to test the m12 policy on a package
# The first parameter must be an inner package source

echo "Tests of XSDK m12 policy ..."

PKGSOURCE=$1

# Verify package source
if [ ! -d $PKGSOURCE ]; then
    echo "Source directory isn't detected."
    exit 1
fi

# loop and find a word occurrence into a folder
count_occurrence() {
local nboccurrence=0
for i in "$1"/*;do
    if [ -d "$i" ];then
        nboccurrence=$(( $(count_occurrence "$i" $word) + $nboccurrence))
    elif [ -f "$i" ]; then
        if grep -q $2 "$i"; then
            echo "The file $i contains at least one occurence of $2" >&2
            nboccurrence=$(( $nboccurrence + 1 ))
        fi
    fi
done
echo $nboccurrence
}

# m12 test 12.1: Check if the source code contains any occurence of word
word = cout;
counter=$(count_occurrence $PKGSOURCE $word)

echo "$counter source code files contain at least one occurence of $word"
if [ $counter -gt 0 ]; then
    echo "Test 12.1 : Checking $word is not used in the source code: Failure"
    exit 1
else
    echo "Test 12.1 : Checking $word is not used in the source code: Succes"
fi
