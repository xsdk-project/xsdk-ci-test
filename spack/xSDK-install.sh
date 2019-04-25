#!/bin/bash

XSDKINSTALL="spack graph xsdk<COMPILERS>"

for i in $(./spack/bin/spack compilers | grep @)
do
    rm -rf $i
    mkdir $i
    cd $i
    FILENAME=xsdk-install-$i.sh
    echo "$XSDKINSTALL" >> "$FILENAME"
    sed -i '' 's/\<COMPILERS\>/'%$i'/g' $FILENAME
    sh $FILENAME
    cd ../
done
